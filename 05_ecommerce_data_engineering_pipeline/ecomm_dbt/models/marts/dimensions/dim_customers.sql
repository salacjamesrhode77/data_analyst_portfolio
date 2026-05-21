{{ config(materialized='table') }}

SELECT
    CUSTOMER_ID,
    CUSTOMER_NAME,
    FIRST_NAME,
    LAST_NAME,
    EMAIL,
    STREET_ADDRESS,
    CITY,
    LATITUDE,
    LONGITUDE,
    PROVINCE,
    ZIP,
    PHONE
FROM {{ ref('int_customers') }}