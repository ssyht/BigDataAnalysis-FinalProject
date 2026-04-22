library(tidyverse)

analysis_df <- read_csv("output/analysis_df.csv", show_col_types = FALSE)

# Keep rows with main variables available
model_df <- analysis_df %>%
  filter(
    !is.na(Fatigue),
    !is.na(MonitoringScore),
    !is.na(TrainingReadiness)
  )

# Model 1: Fatigue
m1 <- lm(Fatigue ~ AcuteLoad + ChronicLoad + AcuteChronicRatio + GameDay + factor(PlayerID),
         data = model_df)

# Model 2: Monitoring Score
m2 <- lm(MonitoringScore ~ AcuteLoad + ChronicLoad + AcuteChronicRatio + GameDay + factor(PlayerID),
         data = model_df)

# Model 3: Training Readiness
m3 <- lm(TrainingReadiness ~ AcuteLoad + ChronicLoad + AcuteChronicRatio + GameDay + factor(PlayerID),
         data = model_df)

summary(m1)
summary(m2)
summary(m3)