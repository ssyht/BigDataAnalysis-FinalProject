library(tidyverse)
library(readxl)
library(lubridate)

# ----------------------------
# 1. Load data
# ----------------------------
games <- read_csv("/Users/sanjitsubhash/Desktop/data/games.csv", show_col_types = FALSE)
rpe <- read_csv("/Users/sanjitsubhash/Desktop/data/rpe.csv", show_col_types = FALSE)
wellness <- read_csv("/Users/sanjitsubhash/Desktop/data/wellness.csv", show_col_types = FALSE)

# ----------------------------
# 2. Basic cleaning
# ----------------------------
games <- games %>%
  mutate(Date = as.Date(Date))

rpe <- rpe %>%
  mutate(Date = as.Date(Date))

wellness <- wellness %>%
  mutate(Date = as.Date(Date))

# Remove players 18-21 based on project overview
rpe <- rpe %>% filter(!(PlayerID %in% 18:21))
wellness <- wellness %>% filter(!(PlayerID %in% 18:21))

# ----------------------------
# 3. Clean TrainingReadiness
# ----------------------------
wellness <- wellness %>%
  mutate(
    TrainingReadiness = str_remove(TrainingReadiness, "%"),
    TrainingReadiness = as.numeric(TrainingReadiness)
  )

# ----------------------------
# 4. Create game-day table
# ----------------------------
game_days <- games %>%
  distinct(Date) %>%
  mutate(GameDay = 1)

# ----------------------------
# 5. Aggregate RPE to player-date level
# ----------------------------
rpe_daily <- rpe %>%
  group_by(PlayerID, Date) %>%
  summarise(
    NumSessions = n(),
    HasGameSession = as.integer(any(SessionType == "Game", na.rm = TRUE)),
    TotalSessionLoad = sum(SessionLoad, na.rm = TRUE),
    
    DailyLoad = first(na.omit(DailyLoad)),
    AcuteLoad = first(na.omit(AcuteLoad)),
    ChronicLoad = first(na.omit(ChronicLoad)),
    AcuteChronicRatio = first(na.omit(AcuteChronicRatio)),
    
    MeanRPE = mean(RPE, na.rm = TRUE),
    .groups = "drop"
  ) %>%
  mutate(
    DailyLoad = ifelse(is.infinite(DailyLoad), NA, DailyLoad),
    AcuteLoad = ifelse(is.infinite(AcuteLoad), NA, AcuteLoad),
    ChronicLoad = ifelse(is.infinite(ChronicLoad), NA, ChronicLoad),
    AcuteChronicRatio = ifelse(is.infinite(AcuteChronicRatio), NA, AcuteChronicRatio),
    MeanRPE = ifelse(is.nan(MeanRPE), NA, MeanRPE)
  )

# ----------------------------
# 6. Merge wellness + workload + game-day
# ----------------------------
analysis_df <- wellness %>%
  left_join(rpe_daily, by = c("PlayerID", "Date")) %>%
  left_join(game_days, by = "Date") %>%
  mutate(
    GameDay = replace_na(GameDay, 0)
  )

# ----------------------------
# 7. Optional player-level standardization
#    This helps compare athletes with different scoring habits
# ----------------------------
analysis_df <- analysis_df %>%
  group_by(PlayerID) %>%
  mutate(
    Fatigue_z = as.numeric(scale(Fatigue)),
    MonitoringScore_z = as.numeric(scale(MonitoringScore)),
    TrainingReadiness_z = as.numeric(scale(TrainingReadiness)),
    DailyLoad_z = as.numeric(scale(DailyLoad)),
    AcuteLoad_z = as.numeric(scale(AcuteLoad)),
    ChronicLoad_z = as.numeric(scale(ChronicLoad)),
    AcuteChronicRatio_z = as.numeric(scale(AcuteChronicRatio))
  ) %>%
  ungroup()

# ----------------------------
# 8. Quick checks
# ----------------------------
cat("Rows in final analysis dataset:", nrow(analysis_df), "\n")
cat("Columns in final analysis dataset:", ncol(analysis_df), "\n\n")

cat("Missingness in main variables:\n")
analysis_df %>%
  select(Fatigue, MonitoringScore, TrainingReadiness,
         DailyLoad, AcuteLoad, ChronicLoad, AcuteChronicRatio,
         GameDay) %>%
  summarise(across(everything(), ~ mean(is.na(.)))) %>%
  print()

# ----------------------------
# 9. Save cleaned file
# ----------------------------
dir.create("output", showWarnings = FALSE)
write_csv(analysis_df, "output/analysis_df.csv")



