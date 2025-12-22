# =========================
# Load libraries
# =========================
library(dplyr)
library(MASS)    # polr pour severity binaire ordonnée (ici juste glm)
library(nnet)    # multinom pour MACE
library(readr)

# =========================
# Load training data
# =========================
train <- read.csv("~/CardiHack/train.csv")

# SNP sets
priority_snps <- paste0("SNP", 1:75)
optional_snps <- paste0("SNP", 76:288)
all_snps <- c(priority_snps, optional_snps)

# =========================
# Prepare training data for SEVERITY (binaire)
# =========================
severity_snps <- all_snps  # all SNPs allowed
train_sev <- train %>%
  select(Age_Baseline, Genre, Variant.Pathogene, OUTCOME.SEVERITY, all_of(severity_snps))

# Ensure outcome is factor
train_sev$OUTCOME.SEVERITY <- factor(train$OUTCOME.SEVERITY, levels = c(0,1))

# Logistic regression
formula_sev <- as.formula(
  paste("OUTCOME.SEVERITY ~ Age_Baseline + Genre + Variant.Pathogene +", 
        paste(severity_snps, collapse = " + "))
)
model_sev <- glm(formula_sev, data = train_sev, family = binomial())
summary(model_sev)

# =========================
# Prepare training data for MACE (multinomial 0/1/2)
# =========================
# Keep priority SNPs + optional SNPs up to max 100
selected_snps_mace <- c(priority_snps, optional_snps[1:(100 - length(priority_snps))])

train_mace <- train %>%
  select(Age_Baseline, Genre, all_of(selected_snps_mace), OUTCOME.MACE)

# Ensure outcome is factor
train_mace$OUTCOME.MACE <- factor(train_mace$OUTCOME.MACE, levels = c(0,1,2))

# Multinomial logistic regression
formula_mace <- as.formula(
  paste("OUTCOME.MACE ~ Age_Baseline + Genre +", paste(selected_snps_mace, collapse = " + "))
)
model_mace <- multinom(formula_mace, data = train_mace, MaxNWts = 5000)
summary(model_mace)

# =========================
# Load test data
# =========================
test <- read.csv("~/CardiHack/test.csv")

# Ensure all columns exist
for(snp in c(severity_snps, selected_snps_mace)){
  if(!snp %in% colnames(test)) test[[snp]] <- 0
}

# =========================
# Predict SEVERITY
# =========================
pred_prob_sev <- predict(model_sev, newdata = test, type = "response")
pred_class_sev <- ifelse(pred_prob_sev > 0.5, 1, 0)

# =========================
# Predict MACE
# =========================
pred_class_mace <- predict(model_mace, newdata = test)

# =========================
# Save combined predictions
# =========================
submission <- data.frame(
  trustii_id = test$trustii_id,
  OUTCOME.SEVERITY = pred_class_sev,
  OUTCOME.MACE = pred_class_mace
)

write.csv(submission, "~/CardiHack/predictions_full_pipeline.csv", row.names = FALSE)
print(head(submission))
