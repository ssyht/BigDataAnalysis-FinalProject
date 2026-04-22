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
# 2. Create model dataset
# ----------------------------
model_df <- analysis_df %>%
  filter(
    !is.na(Fatigue),
    !is.na(MonitoringScore),
    !is.na(TrainingReadiness)
  )

cat("Rows in model dataset:", nrow(model_df), "\n")
cat("Columns in model dataset:", ncol(model_df), "\n\n")

# ----------------------------
# 3. Fit models
# ----------------------------
m1 <- lm(
  Fatigue ~ AcuteLoad + ChronicLoad + AcuteChronicRatio + GameDay + factor(PlayerID),
  data = model_df
)

m2 <- lm(
  MonitoringScore ~ AcuteLoad + ChronicLoad + AcuteChronicRatio + GameDay + factor(PlayerID),
  data = model_df
)

m3 <- lm(
  TrainingReadiness ~ AcuteLoad + ChronicLoad + AcuteChronicRatio + GameDay + factor(PlayerID),
  data = model_df
)

# ----------------------------
# 4. Print summaries
# ----------------------------
cat("========== MODEL 1: FATIGUE ==========\n")
summary_m1 <- summary(m1)
print(summary_m1)

cat("\n========== MODEL 2: MONITORING SCORE ==========\n")
summary_m2 <- summary(m2)
print(summary_m2)

cat("\n========== MODEL 3: TRAINING READINESS ==========\n")
summary_m3 <- summary(m3)
print(summary_m3)

# ----------------------------
# 5. Save model coefficient tables
# ----------------------------
coef_m1 <- as.data.frame(summary_m1$coefficients)
coef_m1$Term <- rownames(coef_m1)
rownames(coef_m1) <- NULL
write_csv(coef_m1, file.path(tables_path, "model1_fatigue_coefficients.csv"))

coef_m2 <- as.data.frame(summary_m2$coefficients)
coef_m2$Term <- rownames(coef_m2)
rownames(coef_m2) <- NULL
write_csv(coef_m2, file.path(tables_path, "model2_monitoringscore_coefficients.csv"))

coef_m3 <- as.data.frame(summary_m3$coefficients)
coef_m3$Term <- rownames(coef_m3)
rownames(coef_m3) <- NULL
write_csv(coef_m3, file.path(tables_path, "model3_trainingreadiness_coefficients.csv"))

# ----------------------------
# 6. Save model fit summary table
# ----------------------------
model_fit_table <- tibble(
  Model = c("Fatigue", "MonitoringScore", "TrainingReadiness"),
  R_Squared = c(summary_m1$r.squared, summary_m2$r.squared, summary_m3$r.squared),
  Adjusted_R_Squared = c(summary_m1$adj.r.squared, summary_m2$adj.r.squared, summary_m3$adj.r.squared),
  Residual_SE = c(summary_m1$sigma, summary_m2$sigma, summary_m3$sigma),
  N = c(length(m1$fitted.values), length(m2$fitted.values), length(m3$fitted.values))
)

print(model_fit_table)
write_csv(model_fit_table, file.path(tables_path, "model_fit_summary.csv"))

# ----------------------------
# 7. Optional diagnostic plots
# ----------------------------
png(file.path(figures_path, "model1_fatigue_residuals.png"), width = 800, height = 600)
plot(m1, which = 1)
dev.off()

png(file.path(figures_path, "model2_monitoringscore_residuals.png"), width = 800, height = 600)
plot(m2, which = 1)
dev.off()

png(file.path(figures_path, "model3_trainingreadiness_residuals.png"), width = 800, height = 600)
plot(m3, which = 1)
dev.off()

# ----------------------------
# 8. Confirmation
# ----------------------------
cat("\nModel tables saved to:\n", tables_path, "\n\n")
cat("Model diagnostic figures saved to:\n", figures_path, "\n")