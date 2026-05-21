## Project Overview

![Project Overview](https://raw.githubusercontent.com/salacjamesrhode77/portfolio_assets/refs/heads/main/images/paysim_mobile_money_dashboard/paysim_thumbnail.jpg)

## Problem Statement

Mobile money platforms have significantly improved the speed and accessibility of financial transactions. However, this growth has also made it more complex to monitor daily transaction activity, assess overall business performance, and detect fraudulent behavior in a timely and accurate manner.

Different stakeholders require different levels of visibility. Financial Operations teams need real-time monitoring of transaction health to ensure smooth daily operations. Executives require a high-level overview of business performance to support strategic decision-making. Meanwhile, Fraud and Data Science teams need to continuously evaluate and improve the effectiveness of fraud detection systems to better identify suspicious transactions.

This project aims to develop an integrated analytics solution that includes a Power BI dashboard tailored to each stakeholder’s needs and a machine learning–based fraud detection system to replace existing rule-based logic and improve fraud detection performance.


## The Dataset

Due to the inherently private nature of financial transactions, publicly available datasets are typically synthetic. One widely used dataset is the PaySim Synthetic Mobile Money Dataset, which simulates 31 days of mobile money transactions and is commonly used for fraud detection research.

However, PaySim is limited to basic transactional fields and does not fully reflect real-world mobile payment systems. To better represent production-like environments (e.g., Stripe-style transactions), the dataset was enriched with additional features to improve realism and support both monitoring and executive-level decision-making use cases.


## Tasks

### Task 1: Financial Performance Dashboard (Executives)
Develop a Power BI executive dashboard that summarizes key business metrics and visualizes financial performance to support strategic decision-making.

### Task 2: Transaction Monitoring Dashboard (Financial Operations)
Develop a Power BI KPI dashboard to monitor daily transaction activity, simulating real-time tracking of transaction status, volume, and disputes to support operational decision-making.

### Task 3: Fraud Detection System (Data Science Team)
Replace the existing rule-based fraud detection logic with a machine learning model and evaluate its performance in identifying fraudulent transactions using key metrics such as recall, precision, and ROC-AUC.


## Methodology / Approach

To execute the following tasks, the workflow is being implemented:

![Machine Learning and Analytics Pipeline](https://github.com/salacjamesrhode77/portfolio_assets/blob/main/images/paysim_mobile_money_dashboard/writeup/fraud_detection_and_data_enrichment_pipeline.jpg)

The workflow follows an end-to-end ML and analytics pipeline, where:

- A portion of the dataset is used to train and evaluate multiple fraud detection models  
- The remaining data is treated as unseen “production-like” data, where the trained model is tested and scored via batch inference  
- The scored dataset is further enriched with synthetic data to reflect real-world mobile payment transactions  
- Results are consumed in Power BI dashboards for operational monitoring, executive decision-making, as well as fraud detection performance evaluation  


### Machine Learning Model

The machine learning model is set to replace the existing logic from the original dataset, which is based on a rule that any attempt to transfer more than 200,000 in a single transaction is flagged as an illegal attempt. With this, two machine learning models are trained and optimized remotely via Vertex AI.

**Random Forest Model**
The Random Forest model is an ensemble method that builds multiple decision trees and combines their results for the final prediction. Each tree is trained using different samples of the data and features, which improves overall accuracy and reduces overfitting.

**XGBoost Model**
The XGBoost model is a gradient boosting algorithm that builds decision trees sequentially. Each new tree focuses on correcting the errors of the previous ones, resulting in improved performance.

Both models were evaluated using ROC-AUC, selecting the more accurate model. The selected model’s threshold is then tuned to maximize recall to identify as many actual fraud cases as possible while ensuring precision is at least 20% to avoid an excessive number of false positives, balancing strong fraud capture with a manageable level of false alarms.

### Apply ML Model (Batch Inference)

The validated model is then applied to a set of unseen data all at once, generating fraud predictions for each transaction. The predictions replace the fraud flag column, creating the final scored dataset.

### Enrich Dataset

While the scored dataset simulates realistic transaction flows and fraud patterns, it lacks important business and operational context needed for real-world analytics. Because of these gaps, the dataset cannot fully support business-focused analysis such as operational monitoring or executive reporting.

To address this, synthetic data enrichment is applied to extend the dataset into a more realistic payment ecosystem, enabling both fraud detection and business intelligence analysis within a single framework.

Note: The logic behind these synthetic datasets may not simulate actual behavior of real transactions. The only purpose is to create a Power BI template for Financial Performance and Operations Monitoring.

### SQL/dbt Transformation

![Transformed Dataset](https://github.com/salacjamesrhode77/portfolio_assets/blob/main/images/paysim_mobile_money_dashboard/writeup/paysim_database.png)

Data transformation was implemented using dbt/SQL CTE queries on a PostgreSQL database, moving from raw synthetic dataset to:
- Staging layer (clean and standardized)
- Intermediate layer (business logic and feature engineering)
- Marts layer (analytics-ready dataset for Power BI visualization)

<b>Sample SQL query using dbt to transform raw data within the database:</b><br>
<img src="https://github.com/salacjamesrhode77/portfolio_assets/blob/main/images/maven_sales_challenge/paysim_sql_queries.png" width="800"><br>

You can see more SQL queries/dbt models used in data transformation by [clicking here](https://github.com/salacjamesrhode77/data_analyst_portfolio/tree/main/paysim_mobile_money_dashboard/dbt_paysim/models)

### Data Modeling (Power BI)

![Paysim Data Model](https://github.com/salacjamesrhode77/portfolio_assets/blob/main/images/paysim_mobile_money_dashboard/writeup/data_model_paysim.png)

The data model follows a hybrid (partially snowflaked) schema, with multiple dimension tables connected to a central fact table. Additionally, an auxiliary table is included, primarily used for sorting values in reports. The tables are designed with one-to-many relationships to optimize performance and enable efficient filtering across dashboards.

There are also tables that are independent of relationships, used for specific purposes such as organizing measures, disconnected slicers, parameter tables, helper tables, and improving UI and UX.

- Fact Table: fact_transactions <br>
- Dimension Tables: dim_calendar, dim_customer, dim_merchants <br>
- Sorting Tables: sort_day, sort_time, sort_bin, sort_cfmatrix_columns, and sort_cfmatrix_rows <br>
- Independent Tables: viz_waterfall_category, viz_waterfall_breakdown, viz_switch_KPIs, viz_switch_time_fields, viz_feature_importance

### DAX Measures

DAX measures are used not only to aggregate values but also to create dynamic calculations, implement conditional logic, perform time intelligence analysis, handle text formatting, and even generate calculated tables.

Below are sample DAX implementations for each use case:

<b>Key business metrics created using DAX:</b><br><br>
<img src="https://github.com/salacjamesrhode77/portfolio_assets/blob/main/images/paysim_mobile_money_dashboard/writeup/paysim_DAX_KPI.png" width="800"><br><br>

<b>Sample DAX for dynamic calculations:</b><br><br>
<img src="https://github.com/salacjamesrhode77/portfolio_assets/blob/main/images/paysim_mobile_money_dashboard/writeup/paysim_DAX_dynamic_calculation.png" width="800"><br><br>

<b>Sample DAX for conditional logic:</b><br><br>
<img src="https://github.com/salacjamesrhode77/portfolio_assets/blob/main/images/paysim_mobile_money_dashboard/writeup/paysim_DAX_conditional_logic.png" width="800"><br><br>

<b>Sample DAX for time intelligence:</b><br><br>
<img src="https://github.com/salacjamesrhode77/portfolio_assets/blob/main/images/paysim_mobile_money_dashboard/writeup/paysim_DAX_time_intelligence.png" width="800"><br><br>

<b>Sample DAX for text formatting:</b><br><br>
<img src="https://github.com/salacjamesrhode77/portfolio_assets/blob/main/images/paysim_mobile_money_dashboard/writeup/paysim_DAX_text_formatting.png" width="800"><br><br>

<b>Sample DAX for calculated tables:</b><br><br>
<img src="https://github.com/salacjamesrhode77/portfolio_assets/blob/main/images/paysim_mobile_money_dashboard/writeup/paysim_DAX_calculated_table.png" width="800">

To explore even more of the DAX calculations and data model used, you may download the PBIX file [here](https://drive.google.com/drive/folders/1ttnH9vZmOAxkaBFNIVyDF8Y63GQvIbt4)


## Power BI Dashboard

The transformed dataset is visualized across 3 dashboards designed to support different stakeholders. As the dashboard is interactive, usability was also prioritized for users who may not be familiar with Power BI. For this reason, a help button was added covering basic dashboard functionality such as navigation and filters (if applicable).

### Page 1 — Executive Overview

![Paysim Dashboard Page 1](https://github.com/salacjamesrhode77/portfolio_assets/blob/main/images/paysim_mobile_money_dashboard/writeup/paysim_page1.png)

The dashboard provides a high-level view of business performance, focusing on how transaction activity translates into profitability. It is designed to help executives quickly assess whether the business is growing, identify key profit drivers, and detect cost inefficiencies across different segments.

**KPI Selection** <br>
The selected KPIs reflect the full financial reporting pipeline:

- Transaction Volume & Value – measure the scale of business operations  
- Transaction Fees – represents revenue generation  
- Total Cost – captures gateway-related costs plus fraud loss  
- Net Profit – evaluates overall business performance  

This set of KPIs enables a clear trace from revenue generation to overall profitability, allowing users to easily identify where value is created or lost.

**Data Visuals** <br>
As for more detailed descriptive reporting, the data visuals are designed to answer the key questions executives want to understand immediately upon viewing the dashboard:

- Are costs growing faster or slower than revenue?  
- Which measure has the biggest impact on net profit?  
- Are there any gateways where we are overpaying but generating low profit?  
- What are the main performance drivers of the business and their contribution to overall performance? Compare it across Payment Type, Country, and Merchants?  

Given the data available is for one month only, no time-based filters were added. Instead, a KPI parameter switch was implemented to dynamically shift the analytical view across key performance dimensions such as Payment Type, Country, and Merchants. This approach maintains simplicity while allowing focused comparison of performance drivers without introducing unnecessary filter complexity.

### Page 2: Financial Operations Monitoring (KPI Dashboard)

![Paysim Dashboard Page 2](https://github.com/salacjamesrhode77/portfolio_assets/blob/main/images/paysim_mobile_money_dashboard/writeup/paysim_page2.png)

This dashboard focuses on day-to-day financial operations, with the main objective of helping operations teams detect issues before they impact customers or result in financial loss. Ideally, this dashboard should stream data in real-time for monitoring; however, for this project, a static dataset is used, so real-time behavior is simulated.

**Features:** <br>

Operations teams can see at a glance whether each KPI is meeting its Service Level Agreement (SLA) or deviating from the expected performance baseline (overall average). This allows for quick identification of underperforming or high-risk areas.

Intraday KPI performance is visualized with a line chart showing hourly trends across a 24-hour period. This enables the identification of patterns such as spikes in transaction volume, which can support resource scaling decisions (e.g., computing capacity during peak hours).

Comparison of performance across Payment Methods is provided, with drill-down capability to Payment Gateway level. This allows identification of the best and worst performing segments for each KPI within the day.

In addition to KPI monitoring, the dashboard also supports early detection of SLA breaches for failed transactions. It enables diagnosis of the main reasons for transaction failures and provides detailed visibility into the most recent failed transactions to support operational troubleshooting and root cause identification.

### Page 3: Fraud Detection Model Evaluation

![Paysim Dashboard Page 3](https://github.com/salacjamesrhode77/portfolio_assets/blob/main/images/paysim_mobile_money_dashboard/writeup/paysim_page3.png)

This dashboard provides the evaluation results of a machine learning model used for fraud detection. The results are based on the same evaluation outputs generated during model development in the Jupyter Notebook but are translated into Power BI to support data storytelling and model observability for data science teams.

The KPIs selected mainly answer key model evaluation questions such as how reliable the model is, measured through fraud detection outcomes, precision, and recall, as well as the business impact of fraud through fraud loss and fraud rate.

The visuals include a confusion matrix showing the total number of true positives, true negatives, false positives, and false negatives, which provides an overview of how accurately the model classifies transactions and where it makes classification errors.

Fraud transactions vary in size, so it is important to evaluate model performance across different transaction sizes. This helps identify which transaction segments have higher rates of missed fraud detection and which segments are being over-flagged. This analysis supports identifying transaction sizes where model recall should be maximized and where flagging should be more lenient to avoid customer friction.

Feature importance is also included to identify the key drivers influencing the model’s fraud predictions, expressed as percentage impact. This helps improve model interpretability by showing which variables most strongly influence classification decisions.

Lastly, the dashboard supports case-level inspection by enabling diagnosis of recently detected fraud cases. It provides detailed visibility into individual flagged transactions to support validation and further model refinement.

## Results

Developed a Power BI executive dashboard providing a high-level view of overall business performance for a simulated fintech company’s financial transactions.

Developed a Power BI KPI Monitoring dashboard simulating real-time tracking and performance monitoring of a payment system, ensuring adherence to Service Level Agreements (SLA) and detecting issues before they impact customers or result in financial loss.

Developed a machine learning model using XGBoost classification algorithm with 66.49% recall and 20% precision in flagging potential fraud transactions.

Translated evaluated results from the machine learning model into Power BI to support better data storytelling and model observability for data science teams.