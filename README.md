# Cardihack : SNP-Based Risk Prediction: MACE and Severity

## 📝 Project Description
The project focuses on identifying genetic predispositions for two specific clinical outcomes using a dataset of 288 SNPs.
- **Target 1: OUTCOME MACE** (Major Adverse Cardiovascular Events)
- **Target 2: OUTCOME SEVERITY** (Disease progression level)
- **Data Split**: 75 Priority SNPs and 214 Optional SNPs.

## ⚙️ Tested Workflows

The current implementation follows a structured pipeline to move from raw genomic data to clinical predictions:  
### A. Chi² + Random Forest

#### 1. Preprocessing
Missing Data were handled via `.fillna(0)`, assuming the absence of a recorded mutation for missing entries.
Then we used `MinMaxScaler` to normalize SNP values to a $[0, 1]$ range, ensuring compatibility with chi².

#### 2. Feature Selection
**Method**: Univariate Selection via **Chi-Square ($\chi^2$)**. By doing it, we can define the statistical independence between SNPs and the outcome.
We filter the top 50 most significant SNPs from the priority set for each target independently. As we want to reduce the dimension of the dataset.


#### 3. Machine Learning Algorithms
- **Model**: `Random Forest Classifier`.  
Indeed, Random Forest is highly effective at capturing **Epistasis** (interactions between different genes) which is common in SNP data.
- **Validation Strategy**: 80/20 Train-Test split with a fixed `random_state=42` to ensure experimental reproducibility.

#### 4. Postprocessing
The model generates a risk probability score ($0.0$ to $1.0$) for each patient, allowing for threshold adjustments in clinical sensitivity.

### B. Logistic Regression on both variables
We didn't use any Machine Learning Algorithms, but we tried to compute the prediction with R, by using Logistic Regression... 

### C. Logistic Regression + Naive Bayes
What if we use logistic regression only on severity and Naive Bayes on MACE...

## 🌲 Predictions scores (for now)...
Our main strategy with Chi² Test + Random Forest gave us the best score... However with only applying logistic regression (on both outcomes variables), we had the worst scores. 
<img width="1234" height="872" alt="image" src="https://github.com/user-attachments/assets/b4b7c3b4-1317-4123-b1da-b1efe229a7cb" />  
With our main strategy, we didn't take into account the following constraints :
<img width="660" height="110" alt="image" src="https://github.com/user-attachments/assets/fc042afe-2661-49e9-9662-4813a5cec1b6" />
<img width="633" height="125" alt="image" src="https://github.com/user-attachments/assets/9a8123c8-088a-4cfe-9672-16f6d6e717ca" />  

Therefore, the upcoming changes will correct this problem.

