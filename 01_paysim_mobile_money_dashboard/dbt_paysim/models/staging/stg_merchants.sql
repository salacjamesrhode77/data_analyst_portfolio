{{ config(materialized='table') }}

SELECT
    CAST(merchant_id AS CHAR(11))                   AS merchant_id,
    CAST(merchant_country AS CHAR(2))               AS merchant_country,
    CAST(merchant_category AS VARCHAR(15))          AS merchant_category,
    CAST(merchant_onboarding_date AS DATE)          AS merchant_onboarding_date
FROM {{ source('raw_data', 'merchants') }}