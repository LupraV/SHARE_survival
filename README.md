# Too Sick for Working, or Sick of Working?  
## Impact of Acute Health Shocks on Early Labour Market Exits

### Abstract
This case study explores the impact of acute health shocks on early labour market exits among individuals aged 50 and above, leveraging the European SHARE dataset (waves 1-8). Using survival analysis methodologies, including Kaplan-Meier estimators and Cox proportional hazards models, the study examines the influence of acute health shocks and self-perceived health conditions, and other health and socioeconomic factors on early retirement decisions across 28 European countries and Israel. Findings highlight significant gender-specific patterns, with poorer health levels being key drivers of early exits. The results provide insights into policy interventions that may delay early retirements, promoting better health and economic outcomes.

Analysis conducted as coursework for course 125788 Big Data in Finance and Banking (2024, Massey University)

### Overview
This repository contains the Stata code and data preparation steps used to investigate the relationship between acute health shocks and early labour market exits among older adults (aged 50+). The study utilises data from the Survey of Health, Ageing, and Retirement in Europe (SHARE - https://share-eric.eu/) and applies survival analysis methods, including Kaplan-Meier estimators and Cox proportional hazards models.

### Key Objectives
1. Assess how acute health shocks influence the likelihood of early retirement.
2. Examine the role of acute health shocks, self-perceived health, and socioeconomic factors in labour market decisions.
3. Provide gender-specific insights to inform welfare policy and support interventions.

### Software
- **Stata/SE 17.0**

### Contents
- `Data_prep.do`: Data cleaning and transformation steps, including handling missing values and constructing variables.
- `Survival_prep.do` and `SurvivalAnalysis.do`: Kaplan-Meier and Cox Proportional Hazards model implementation.
- `Table_exports.xlsx`: Contains output tables of descriptive statistics, and Cox Proportional Hazards regression analysis.

### Data
- The study uses the SHARE dataset, covering 28 European countries and Israel. The dataset includes variables for waves 1~8.
- source: https://share-eric.eu/

### Key Findings
- Acute health shocks significantly increase the hazard of early labour market exits.
- Poorer self-perceived health and lower education levels are critical predictors of early retirement.
- Gender-specific patterns highlight the need for tailored policy interventions.


### Contact
For questions, please reach out to **Luis Vieira**.

