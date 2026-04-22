library(tidyverse)

# ----------------------------
# 0. Set folders
# ----------------------------
base_path <- "/Users/sanjitsubhash/Desktop/BigDataAnalysis-FinalProject"
output_path <- file.path(base_path, "output")
figures_path <- file.path(output_path, "figures")
tables_path <- file.path(output_path, "tables")

dir.create(output_path, showWarnings = FALSE, recursive = TRUE)
dir.create(figures_path, showWarnings = FALSE, recursive = TRUE)
dir.create(tables_path, showWarnings = FALSE, recursive = TRUE)

# ----------------------------
# 1. Load cleaned analysis data
# ----------------------------
analysis_df <- read_csv(file.path(tables_path, "analysis_df.csv"), show_col_types = FALSE)

# ----------------------------
# 2. Summary table for main variables
# ----------------------------
summary_table <- analysis_df %>%
  select(Fatigue, MonitoringScore, TrainingReadiness,
         DailyLoad, AcuteLoad, ChronicLoad, AcuteChronicRatio) %>%
  summary()

print(summary_table)

# Save missingness summary
missingness_table <- analysis_df %>%
  select(Fatigue, MonitoringScore, TrainingReadiness,
         DailyLoad, AcuteLoad, ChronicLoad, AcuteChronicRatio, GameDay) %>%
  summarise(across(everything(), ~ mean(is.na(.)))) %>%
  pivot_longer(cols = everything(),
               names_to = "Variable",
               values_to = "MissingRate")

print(missingness_table)
write_csv(missingness_table, file.path(tables_path, "missingness_summary.csv"))

# ----------------------------
# 3. Histograms of main wellness outcomes
# ----------------------------
p1 <- ggplot(analysis_df, aes(x = Fatigue)) +
  geom_histogram(bins = 20) +
  labs(
    title = "Distribution of Fatigue",
    x = "Fatigue",
    y = "Count"
  ) +
  theme_minimal()

print(p1)
ggsave(file.path(figures_path, "fatigue_hist.png"), p1, width = 6, height = 4)

p2 <- ggplot(analysis_df, aes(x = MonitoringScore)) +
  geom_histogram(bins = 20) +
  labs(
    title = "Distribution of Monitoring Score",
    x = "Monitoring Score",
    y = "Count"
  ) +
  theme_minimal()

print(p2)
ggsave(file.path(figures_path, "monitoring_hist.png"), p2, width = 6, height = 4)

p3 <- ggplot(analysis_df, aes(x = TrainingReadiness)) +
  geom_histogram(bins = 20) +
  labs(
    title = "Distribution of Training Readiness",
    x = "Training Readiness",
    y = "Count"
  ) +
  theme_minimal()

print(p3)
ggsave(file.path(figures_path, "trainingreadiness_hist.png"), p3, width = 6, height = 4)

# ----------------------------
# 4. Scatterplots: workload vs wellness
# ----------------------------
scatter_df1 <- analysis_df %>%
  filter(!is.na(AcuteLoad), !is.na(Fatigue))

p4 <- ggplot(scatter_df1, aes(x = AcuteLoad, y = Fatigue)) +
  geom_point(alpha = 0.4) +
  geom_smooth(method = "lm", se = TRUE) +
  labs(
    title = "Acute Load vs Fatigue",
    x = "Acute Load",
    y = "Fatigue"
  ) +
  theme_minimal()

print(p4)
ggsave(file.path(figures_path, "acuteload_fatigue.png"), p4, width = 6, height = 4)

scatter_df2 <- analysis_df %>%
  filter(!is.na(AcuteChronicRatio), !is.na(TrainingReadiness))

p5 <- ggplot(scatter_df2, aes(x = AcuteChronicRatio, y = TrainingReadiness)) +
  geom_point(alpha = 0.4) +
  geom_smooth(method = "lm", se = TRUE) +
  labs(
    title = "Acute-Chronic Ratio vs Training Readiness",
    x = "Acute-Chronic Ratio",
    y = "Training Readiness"
  ) +
  theme_minimal()

print(p5)
ggsave(file.path(figures_path, "acr_trainingreadiness.png"), p5, width = 6, height = 4)

scatter_df3 <- analysis_df %>%
  filter(!is.na(AcuteLoad), !is.na(MonitoringScore))

p6 <- ggplot(scatter_df3, aes(x = AcuteLoad, y = MonitoringScore)) +
  geom_point(alpha = 0.4) +
  geom_smooth(method = "lm", se = TRUE) +
  labs(
    title = "Acute Load vs Monitoring Score",
    x = "Acute Load",
    y = "Monitoring Score"
  ) +
  theme_minimal()

print(p6)
ggsave(file.path(figures_path, "acuteload_monitoringscore.png"), p6, width = 6, height = 4)

# ----------------------------
# 5. Boxplots: game day vs non-game day
# ----------------------------
p7 <- ggplot(analysis_df, aes(x = factor(GameDay), y = Fatigue)) +
  geom_boxplot() +
  labs(
    title = "Fatigue on Game Days vs Non-Game Days",
    x = "Game Day (0 = No, 1 = Yes)",
    y = "Fatigue"
  ) +
  theme_minimal()

print(p7)
ggsave(file.path(figures_path, "gameday_fatigue_boxplot.png"), p7, width = 6, height = 4)

p8 <- ggplot(analysis_df, aes(x = factor(GameDay), y = TrainingReadiness)) +
  geom_boxplot() +
  labs(
    title = "Training Readiness on Game Days vs Non-Game Days",
    x = "Game Day (0 = No, 1 = Yes)",
    y = "Training Readiness"
  ) +
  theme_minimal()

print(p8)
ggsave(file.path(figures_path, "gameday_trainingreadiness_boxplot.png"), p8, width = 6, height = 4)

p9 <- ggplot(analysis_df, aes(x = factor(GameDay), y = MonitoringScore)) +
  geom_boxplot() +
  labs(
    title = "Monitoring Score on Game Days vs Non-Game Days",
    x = "Game Day (0 = No, 1 = Yes)",
    y = "Monitoring Score"
  ) +
  theme_minimal()

print(p9)
ggsave(file.path(figures_path, "gameday_monitoringscore_boxplot.png"), p9, width = 6, height = 4)

# ----------------------------
# 6. Correlation table for main numeric variables
# ----------------------------
corr_df <- analysis_df %>%
  select(Fatigue, MonitoringScore, TrainingReadiness,
         AcuteLoad, ChronicLoad, AcuteChronicRatio)

correlation_matrix <- cor(corr_df, use = "pairwise.complete.obs")

print(correlation_matrix)
write.csv(correlation_matrix, file.path(tables_path, "correlation_matrix.csv"), row.names = TRUE)

# ----------------------------
# 7. Quick confirmation
# ----------------------------
cat("Loaded analysis data from:\n", file.path(tables_path, "analysis_df.csv"), "\n\n")
cat("EDA figures saved to:\n", figures_path, "\n\n")
cat("EDA tables saved to:\n", tables_path, "\n")