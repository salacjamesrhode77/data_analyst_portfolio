### Project Overview
[![Watch the demo](https://img.youtube.com/vi/suQ2LIrzfYU/hqdefault.jpg)](https://www.youtube.com/watch?v=suQ2LIrzfYU)

## Maven Sales Challenge

**Role:** Data Analyst | BI Developer <br>
**Tools Used:** Power BI (DAX, Visualization), PostgreSQL, SQL-based tranformation (dbt) <br>
                Airflow (Workflow Orchestration), Docker 

### 🔍 Problem
In an effort to become a data-driven organization, MavenTech, a company that specializes in selling computer hardware to large businesses, aims to create an interactive dashboard that allows sales managers to monitor their team’s quarterly performance and identify areas for improvement. The company has been using a new CRM system to track sales opportunities but currently lacks visibility into the data outside the platform.

### 🎯 Objectives  
- Create an interactive dashboard for sales manager to track their team and agents quarterly performance.
- Highlight key focus areas to help sales managers maximize opportunities and improve team performance.
- Support sales managers in understanding how well their team is performing against other teams and business averages.

### ⚙️ Solution Approach

**Datasets:** <br>
In real-world application, datasets are continuously updated. However, this challenge gives a static source of data (CSV files). To simulate a dynamic, real-time data source, all csv files were uploaded to Google Sheets and converted into a public CSV export link. This approach allowed Airflow to pull updated data automatically, mimicking a live production scenario.

**Docker:** <br>
Two Docker Compose projects were provisioned for this project: [Airflow services Docker Compose](https://github.com/salacjamesrhode77/data_analyst_portfolio/blob/main/maven_sales_challenge/maven_airflow/docker-compose.yml) and [dbt + PostgreSQL + pgAdmin setup](https://github.com/salacjamesrhode77/data_analyst_portfolio/blob/main/maven_sales_challenge/maven_dbt/docker-compose.yml). Both Docker Compose projects are connected via an external Docker network, enabling communication and shared volumes so Airflow services can execute dbt commands.<br>



**Data Pipeline** <br>

![Data Architecture](https://github.com/salacjamesrhode77/portfolio_assets/blob/main/images/paysim_mobile_money_dashboard/writeup/data_architecture.png?raw=true)

- Public CSV files were prepared as data sources and stored in a structured format for processing
- The data was loaded into a PostgreSQL database as tables
- Temporary files used during loading were removed after successful import
- dbt was used to clean and transform the raw data inside PostgreSQL
- Final transformed datasets were produced and used for dashboard development

**Data Modeling (Power BI)** <br>

![Data Model](https://github.com/salacjamesrhode77/portfolio_assets/blob/main/images/paysim_mobile_money_dashboard/writeup/mavensales_data_model.png?raw=true)

The data model follows a simple star schema, with multiple dimension tables connected to a central fact table. The tables are designed with one-to-many relationships to optimize performance and enable efficient filtering across the dashboards.

There are also tables that are independent of relationships for specific UX purposes (disconnected slicers).

Fact Table: fact_salespipeline <br>
Dimension Tables: dim_accounts, dim_calendar, dim_products, dim_salesteams <br>
Independent Tables: viz_price_deviation, viz_selection_manager

**DAX Measures** <br>

DAX measures are used not only to aggregate values but also to create dynamic calculations, implement conditional logic, perform time intelligence analysis, handle text formatting, color formatting, calculated columns, etc.

Below are sample DAX implementations for each use case:

<b>Key business metrics created using DAX:</b><br><br>
<img src="https://github.com/salacjamesrhode77/portfolio_assets/blob/main/images/paysim_mobile_money_dashboard/writeup/mavensales_DAX_KPI.png" width="800"><br><br>

<b>Sample DAX for dynamic calculations:</b><br><br>
<img src="https://github.com/salacjamesrhode77/portfolio_assets/blob/main/images/paysim_mobile_money_dashboard/writeup/mavensales_DAX_dynamic_calculation.png" width="800"><br><br>

<b>Sample DAX for conditional logic:</b><br><br>
<img src="https://github.com/salacjamesrhode77/portfolio_assets/blob/main/images/paysim_mobile_money_dashboard/writeup/mavensales_DAX_conditional_logic.png" width="800"><br><br>

<b>Sample DAX for time intelligence:</b><br><br>
<img src="https://github.com/salacjamesrhode77/portfolio_assets/blob/main/images/paysim_mobile_money_dashboard/writeup/mavensales_DAX_time_intelligence.png" width="800"><br><br>

<b>Sample DAX for text formatting:</b><br><br>
<img src="https://github.com/salacjamesrhode77/portfolio_assets/blob/main/images/paysim_mobile_money_dashboard/writeup/mavensales_DAX_text_formatting.png" width="800"><br><br>

<b>Sample DAX for color formatting:</b><br><br>
<img src="https://github.com/salacjamesrhode77/portfolio_assets/blob/main/images/paysim_mobile_money_dashboard/writeup/mavensales_DAX_color_formatting.png" width="800"><br><br>

<b>Sample DAX for calculated columns:</b><br><br>
<img src="https://github.com/salacjamesrhode77/portfolio_assets/blob/main/images/paysim_mobile_money_dashboard/writeup/mavensales_DAX_calculated_columns.png" width="800"><br><br>
**PowerBI dashboard** <br>
The interactive Power BI dashboard is divided into three sections aligned with the project objectives: <br>

![Maven Sales Page 1](https://github.com/salacjamesrhode77/portfolio_assets/blob/main/images/paysim_mobile_money_dashboard/writeup/mavensales_dashboard_page1.png?raw=true)
- **First Page (Landing Page):** Focuses on visuals that provide managers with instant insights into how their teams are tracking against KPIs and how individual agents are performing. <br>


![Maven Sales Page 1](https://github.com/salacjamesrhode77/portfolio_assets/blob/main/images/paysim_mobile_money_dashboard/writeup/mavensales_dashboard_page2.png?raw=true)
- **Second Page:** Highlights the products, sectors, and accounts the team should focus on, as they contribute the most to sales. It also provides suggested markup percentages for the strategic selling of products. <br>


![Maven Sales Page 1](https://github.com/salacjamesrhode77/portfolio_assets/blob/main/images/paysim_mobile_money_dashboard/writeup/mavensales_dashboard_page3.png?raw=true)
- **Third Page:** Highlights the team’s performance compared to other sales teams across various metrics.Managers can see how their teams rank within the overall business and whether they are performing above or below average.

### 📈 Key Results

✅ Highlighted underperforming sales agents and tracked team performance against KPIs. <br>
✅ Identified top products, sectors, and accounts driving 80% of sales and determined optimal markup strategies. <br>
✅ Enabled Sales Managers to benchmark team performance against other sales teams and overall business averages. <br>


**Acknowledgements/References:** <br  >

This dashboard was inspired by the insights and design recommendations shared during the **Maven Sales Challenge – Winner Selection Voting**.

In particular, I’d like to acknowledge the work of:
- **Kerryn Gresswell**
- **Gerard Duggan**
- **Vince McSkimmings**

Their dashboards influenced the analytical focus, KPI selection, and storytelling approach used in this project.  
All implementation, data modeling, and visual design decisions are my own.



