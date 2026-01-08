# Cardihack 

## Project Description
The project focuses on identifying genetic predispositions for two specific clinical outcomes using a dataset of 288 SNPs.
- **Target 1: OUTCOME MACE** (Major Adverse Cardiovascular Events)
- **Target 2: OUTCOME SEVERITY** (Disease progression level)
- **Data Split**: 75 Priority SNPs and 214 Optional SNPs.

## Constraints for both predictions
<img width="660" height="110" alt="image" src="https://github.com/user-attachments/assets/fc042afe-2661-49e9-9662-4813a5cec1b6" />
<img width="633" height="125" alt="image" src="https://github.com/user-attachments/assets/9a8123c8-088a-4cfe-9672-16f6d6e717ca" />  

## The Pipeline
### Small context...
The pipeline we submitted on the Trustii website is not the one we are going to defend in our poster. Indeed, we couldn't give our best model before the deadline...  However the pipeline was good enough to not overfit and to not predict false positives. None of the contraints for SEVERITY was taken into account in this pipeline. Hence why we won't defend this model, but a better one. Also both pipelines use Logistic Regression for MACE and GaussianNB for SEVERITY. The new pipeline gets its new strength from the preprocessing steps.

### The True Pipeline
The pipeline (`Cardihack.ipynb`) performs median imputation of clinical variables with missingness indicators, encodes categorical features, and standardizes continuous inputs. SNPs are filtered, standardized, clustered using hierarchical clustering, and selected per cluster via weighted logistic regression, with priority SNPs preserved. A polygenic risk score (PRS) for MACE is then constructed from the selected SNPs. Final models include a penalized logistic regression combining clinical variables, genetic status, and PRS for MACE prediction, and a Gaussian Naive Bayes model using age and genetic status for severity prediction. Predictions are exported for submission. 
