{{ config(materialized='table') }}

SELECT
    CAST(customer_id AS CHAR(11))               AS customer_id,
    CAST(home_country AS CHAR(2))               AS home_country,
    CAST(primary_device AS VARCHAR(10))         AS primary_device,
    CAST(customer_signup_date AS DATE)          AS customer_signup_date
FROM {{ source('raw_data', 'customers') }}  