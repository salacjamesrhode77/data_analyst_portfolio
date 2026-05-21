### Project Overview
![Data Architecture](https://github.com/salacjamesrhode77/portfolio_assets/blob/main/images/ecommerce_data_engineering_pipeline/data_architecture.png?raw=true)

## E-commerce Data Engineering Pipeline

**Role:** Data Engineer <br>
**Tools Used:** Airflow, Docker, Google Cloud Platform (Cloud Storage, Compute Engine, CloudSQL), Snowflake <br>
                SQL-based transformation (dbt), Python scripts and DAGs

### 🔍 Problem
Modern retail operations generate vast amounts of transactional, customer, and product data across multiple channels. Managing and analyzing this data efficiently is a complex challenge that demands robust data engineering solutions. This project demonstrates a practical approach to tackling these challenges in an omnichannel retail environment.

Scenario: <br>
A company has accumulated over 10 years of historical sales data stored in Parquet files.

As the business expanded into both online and physical retail, it began storing online store transactions in a PostgreSQL database, while each physical branch store stores transactions in its own POS database.

Occasionally, network or software issues can make a store’s primary database temporarily unavailable. In such situations, order confirmation emails—automatically sent for every completed in-store purchase—serve as a reliable backup source of transaction data, enabling the company to track and validate sales even when the main system is offline.

In addition, product and customer master data are accessible via REST APIs, providing another layer of source diversity and ensuring comprehensive data coverage across the organization.

### 🎯 Objectives
- Design and implement a robust data engineering pipeline that ingests data from diverse sources, including Parquet files, relational databases, order confirmation emails, and REST APIs.
- Transform and consolidate these data streams into unified, analytics-ready tables to support reporting, operational monitoring, and data-driven decision-making across both online and in-store channels.
- Build a reproducible, containerized environment for the pipeline using Docker to streamline collaboration, monitoring, and deployment.


### ⚙️ Solution Approach
**Datasets:** <br>
This project extracts and unifies data from multiple sources into a centralized data warehouse. Since no single public dataset fully meets the requirements, custom synthetic datasets were created using the Faker library.

Python scripts developed to simulate realistic data sources:

**Dimension data sources:** A Flask-based RESTful API loads customer and product data from CSV files and exposes endpoints for querying the data.

**Transaction data sources:** Multiple scripts generate synthetic order data from different sources:
- **Database source:** Generates daily orders ingested into a Cloud SQL PostgreSQL database, simulating online transactions.
- **Email source:** Generates daily order confirmation emails simulating transactions for individual branch stores.
- **Static source:** Generates over 10 years of historical sales data stored as Parquet files.

**Docker:** <br>
To ensure the pipeline works consistently across environments, making it scalable and easier to collaborate on, Docker containers were used.Two groups of services were provisioned for this project:

**Fake Data Generator Services:** Uses a lightweight Docker setup to avoid port mapping conflicts. This group of containers runs the Python scripts and DAGs that create synthetic data sources, including database transactions, email orders, historical orders, and a mock API using Flask.

**Ecommerce Airflow Services:** Scaffolded using Astro CLI for simplified management of Apache Airflow workflows. This group of containers runs the main orchestration layer, handling extraction from data sources, ingestion to Google Cloud Storage, loading into the Snowflake data warehouse, and performing in-warehouse transformations.


**Data Ingestion** <br>
To avoid creating duplicate records during ingestion from **dynamic data sources**, the scripts are implemented following the principles of idempotency.
- **API data ingestion:** Fetches customer and product data from a REST API, converts JSON responses to CSV files, and overwrites the files on each run to maintain idempotency.
- **Email data ingestion:** Incrementally extracts order details by tracking the last processed email timestamp, fetching only new order confirmations and parsing them into structured CSV files.
- **PostgreSQL data ingestion:** Incrementally extracts new order records from a Cloud SQL PostgreSQL database by tracking the last processed row ID in Cloud Storage, fetching only unseen rows and converting them into structured CSV files.

All processed data is uploaded to a Google Cloud Storage (GCS) bucket and loaded into tables in the Snowflake data warehouse.

For the **static data source**, Parquet files are uploaded directly to Google Cloud Storage (GCS) and loaded into Snowflake without additional transformation.


**Snowflake Setup** <br>
Before loading data into Snowflake:
1. Create a database and schema as the destination.
2. Configure an external stage pointing to the GCS bucket using a storage integration.
3. Create target tables and inspect the staged datasets to determine correct column types.
4. Load static files directly via SQL queries; dynamic files are loaded via Airflow DAGs.

**dbt Transformation** <br>
dbt is used for in-warehouse transformations, converting raw data into analytics-ready datasets. Data flows through three layers:

- **Staging:** Cleans and standardizes raw source data (typically one-to-one with raw tables).
- **Intermediate:** Performs complex transformations, deduplications, calculations, and combines multiple staging models via joins or unions.
- **Marts:** Produces business-focused, aggregated models (facts and dimensions) optimized for BI tools and analysts.

The dbt project exists in the repository root for development testing. A duplicate copy is included in the Airflow DAGs directory to be executed as part of the ELT pipeline.

**Data Serving (Next Plans)** <br>
Transformed datasets support downstream use cases, including:

- **Business Intelligence:** Data marts can be visualized in tools like Power BI or Tableau to enable self-service analytics and dashboards for Business Users, BI analysts, and Data analysts.
- **Data Science and Machine Learning** Processed datasets can be used by Data Scientists and Machine Learning Engineers for training machine learning and AI models.

### 📈 Key Results

✅ Built a scalable ELT pipeline to collect and centralize 6 million rows of synthetic data from APIs, emails, database and parquet files into Snowflake data warehouse.  <br>
✅ Automated data ingestion and processing using Python scripts and SQL/dbt models, transforming raw datasets into analytics-ready tables for business users, BI analysts, and data analysts or data science applications. <br>

![Fake Data Generation](https://github.com/salacjamesrhode77/portfolio_assets/blob/main/images/ecommerce_data_engineering_pipeline/fake_data_orchestrator.jpg?raw=true)<br>_Figure 1: Fake Data Generation Workflow Orhcestration_

![Main Workflow](https://github.com/salacjamesrhode77/portfolio_assets/blob/main/images/ecommerce_data_engineering_pipeline/elt_pipeline_orchestrator.jpg?raw=true)<br>_Figure 2: Main Workflow Orhcestration_

**Acknowledgements/References:** <br  >
This project was inspired by the following resources: <br>
Build an End-to-End Data Engineering Pipeline for eCommerce with the Modern Data-Stack by sclauguico <br>
Data Engineering Zoomcamp Guided Project: NY Taxi Data End‑to‑End Data Engineering Pipeline by DataTalks.Club
