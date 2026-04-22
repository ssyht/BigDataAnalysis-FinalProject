library(tidyverse)

analysis_df <- read_csv("output/analysis_df.csv", show_col_types = FALSE)

# 1. Summary table
analysis_df %>%
  select(Fatigue, MonitoringScore, TrainingReadiness,
         DailyLoad, AcuteLoad, ChronicLoad, AcuteChronicRatio) %>%
  summary()

# 2. Histograms
ggplot(analysis_df, aes(x = Fatigue)) +
  geom_histogram(bins = 20) +
  theme_minimal()

ggplot(analysis_df, aes(x = MonitoringScore)) +
  geom_histogram(bins = 20) +
  theme_minimal()

ggplot(analysis_df, aes(x = TrainingReadiness)) +
  geom_histogram(bins = 20) +
  theme_minimal()

# 3. Scatterplots
ggplot(analysis_df, aes(x = AcuteLoad, y = Fatigue)) +
  geom_point(alpha = 0.4) +
  geom_smooth(method = "lm", se = TRUE) +
  theme_minimal()

ggplot(analysis_df, aes(x = AcuteChronicRatio, y = TrainingReadiness)) +
  geom_point(alpha = 0.4) +
  geom_smooth(method = "lm", se = TRUE) +
  theme_minimal()

# 4. Compare game days vs non-game days
ggplot(analysis_df, aes(x = factor(GameDay), y = Fatigue)) +
  geom_boxplot() +
  labs(x = "Game day", y = "Fatigue") +
  theme_minimal()

ggplot(analysis_df, aes(x = factor(GameDay), y = TrainingReadiness)) +
  geom_boxplot() +
  labs(x = "Game day", y = "Training Readiness") +
  theme_minimal()