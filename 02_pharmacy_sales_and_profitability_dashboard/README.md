### Project Overview
[![Dashboard Preview](https://raw.githubusercontent.com/salacjamesrhode77/portfolio_assets/main/images/pharmacy_sales_and_profitability_dashboard/onyx_data_challenge_thumbnail_1.png)](https://app.powerbi.com/view?r=eyJrIjoiOWM2NDQzNDAtOTE0Yi00MjI4LTg4OGUtMzc1ODFiN2FiNTM2IiwidCI6IjQ2NTRiNmYxLTBlNDctNDU3OS1hOGExLTAyZmU5ZDk0M2M3YiIsImMiOjl9)



## Pharmacy Sales and Profitability Dashboard

**Role:** Data Analyst | BI Developer <br>
**Tools Used:** Power BI Service, Dataflow, DAX 

### 🔍 Problem
This project analyzes a dataset representing a European pharmacy chain distributor operating across multiple European countries. The dataset includes daily sales transactions by pharmacy and product, with supporting dimensions for time, geography, and product hierarchy.

### 🎯 Objectives <br>
The task is to build a Power BI report that helps stakeholders understand:  
- How sales and profitability vary across countries, regions, and individual pharmacies.
- How different product categories and brands perform in different locations.
- How regional performance contributes to overall business results.

Additionally, this project is guided by key business questions and analytical challenges, which are detailed [in this document](https://docs.google.com/document/d/1T973twFhLPFYHE2yWMfu1OIrpF6c2j1j/edit?usp=sharing).

### ⚙️ Methodology / Approach

**Data Modeling** <br>
![Data Model](https://github.com/salacjamesrhode77/portfolio_assets/blob/main/images/pharmacy_sales_and_profitability_dashboard/data_model_pharmacy.png)

The data model follows a hybrid (partially snowflaked) schema, with multiple dimension tables connected to a central fact table. Some dimensions are further normalized into related tables to reduce redundancy and support hierarchical relationships. Additionally, an auxiliary table is included, primarily used for sorting values in reports. The tables are designed with one-to-many relationships to optimize performance and enable efficient filtering across dashboards.

There are also tables that are independent of relationships, used for specific purposes such as organizing measures, disconnected slicers, parameter tables, helper tables, and improving UI and UX.

- Fact Table: fact_Sales <br>
- Dimension Tables: dim_Pharmacy, dim_Product, dim_ProductDiscontinued, dim_Date, dim_Product_PromoFlag<br>
- Sort Tables: sort_StoreSize, sort_ProductCategory <br>
- Independent Tables: measures, viz_selectKPI, viz_ProductClassification, viz_ScatterPlotMeasures, viz_IconTrend, vizRepeatingProducts

**DAX Measures** <br>
DAX measures are used not only to aggregate values but also to create dynamic calculations, implement conditional logic, handle text formatting, custom conditional formatting, calculated tables, etc.

Below are sample DAX implementations for each use case:

<b>Key business metrics created using DAX:</b><br><br>
<img src="https://github.com/salacjamesrhode77/portfolio_assets/blob/main/images/pharmacy_sales_and_profitability_dashboard/pharmacy_dashboard_DAX_KPI.png" width="800"><br><br>

<b>Sample DAX for dynamic calculations:</b><br><br>
<img src="https://github.com/salacjamesrhode77/portfolio_assets/blob/main/images/pharmacy_sales_and_profitability_dashboard/pharmacy_dashboard_dynamic_calculations.png" width="800"><br><br>

<b>Sample DAX for conditional logic:</b><br><br>
<img src="https://github.com/salacjamesrhode77/portfolio_assets/blob/main/images/pharmacy_sales_and_profitability_dashboard/pharmacy_dashboard_DAX_conditional_logic.png" width="800"><br><br>

<b>Sample DAX for text formatting:</b><br><br>
<img src="https://github.com/salacjamesrhode77/portfolio_assets/blob/main/images/pharmacy_sales_and_profitability_dashboard/pharmacy_dashboard_DAX_text_formatting.png" width="800"><br><br>

<b>Sample DAX for custom conditional formatting:</b><br><br>
<img src="https://github.com/salacjamesrhode77/portfolio_assets/blob/main/images/pharmacy_sales_and_profitability_dashboard/pharmacy_dashboard_DAX_custom_conditional_formatting.png" width="800"><br><br>
<b>Sample DAX for custom conditional formatting:</b><br><br>
<img src="https://github.com/salacjamesrhode77/portfolio_assets/blob/main/images/pharmacy_sales_and_profitability_dashboard/pharmacy_dashboard_DAX_calculated_tables.png" width="800"><br><br>

To explore even more of the DAX calculations and data model used, you may download the PBIX file [here](https://drive.google.com/drive/folders/1ttnH9vZmOAxkaBFNIVyDF8Y63GQvIbt4)



**Power BI Dashboard** <br>

The approach for this challenge is straightforward: address all key questions and analytical challenges by focusing on three critical areas—**Geography, Trends, and Products**—resulting in a three-page report.

**Filters:**  
On the first two pages, filters allow users to select which products to include and whether to include high-volume, low-margin items or exclude them to avoid distorting the performance report. On the third page, users can choose to include or exclude discontinued products.

Additional filters vary depending on the page focus:

- **Geography page:** filters for date and products are available.  
- **Trends page:** filters for location and products are available.  
- **Products page:** filters for location and date can be applied.

All filters are accessible via a bookmark button in the upper-right corner, along with a reset button and report guide.

**KPI Cards:**  
KPI cards (Revenue, Cost, Margin, Units Sold) are optimized not just to display key metrics but also to act as interactive filters for the entire report.


### Page 1: Geography

From an executive or manager perspective, it is important to see how countries and regions perform across different KPIs, be able to drill down from country to region, and view the top-ranked pharmacies based on selected KPIs. To support this:

- A **drill down bar chart with Pareto analysis** highlights top-performing countries and regions and their contribution to overall results, complemented by a **map** to show geographic patterns.  
- A **matrix table** displays pharmacy-level details, including pharmacy count and KPI contribution by type and size.  
- A **decomposition chart** allows stakeholders to explore KPIs by product categories, brands, and individual products.


### Page 2: Trends

Trend analysis can be overwhelming and noisy if done at the individual product level. To simplify:

- Visualizations focus on **product categories**, with tooltips showing top brands and products when hovering over line charts.  
- Charts compare **current-year vs previous-year performance**, highlight overall trend direction, and identify peak and low points.


### Page 3: Product Analysis

This page visualizes products classified into four quadrants:

- **Q1:** Low Volume, Low Margin  
- **Q2:** Low Volume, High Margin  
- **Q3:** High Volume, High Margin  
- **Q4:** High Volume, Low Margin  

KPI cards show the number of products in each quadrant, their percentage contribution to total profit, and normalized values for profit and volume for easier comparison.

Supporting visuals include:

- **Units Sold vs Profit Margin scatterplot:** Color gradients indicate promotional effectiveness and highlight which promotions drive volume.  
- **Promoted vs Non-Promoted Sales bar charts:** Show trade-offs between profit per unit and transaction volume.  
- **Promotion comparison YoY:** Displays whether an increase in promotions correlates with changes in profit margin.

### 📈 Key Insights (Executive Focus)

- The top three countries (Germany, France, Italy) contribute 50% of overall business performance.<br>
- Prescription Drugs generate the highest revenue, cost, and margin, while OTC products lead in units sold.<br>
- Current-year trends show performance improvements across all product categories except Medical Devices.<br>
- For all product categories, performance typically dips in the first four months of the year (January–April).<br>
- 28 high-volume, low-margin products were identified as reducing profitability and distorting performance reporting.<br>
- After excluding discontinued products, items cluster into: Specialized Medical Devices (expensive, low-frequency), Prescription Drugs (slow-moving, regulated), and FMCG (OTC, Personal Care, Wellness).<br>
- 99 high-volume, high-margin products were identified as primary profit drivers that support revenue growth and overall margin expansion.



### Acknowledgement/References

This dashboard was inspired by design and work of:
- **Tiffanny Effinger** Maven Northwind Challenge Dashboard
- **Gerard Duggan** Maven Churn Challenge