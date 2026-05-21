{{ config(materialized='table') }}

WITH CUSTOMERS AS (
    SELECT
        CST.CUSTOMER_ID, CST.CUSTOMER_NAME, CST.FIRST_NAME,
        CST.LAST_NAME, CST.EMAIL, CST.STREET_ADDRESS,
        CST.CITY, CT.LATITUDE, CT.LONGITUDE,
        CST.PROVINCE, CST.ZIP, CST.PHONE
    FROM    {{ ref('stg_customers') }} CST
    LEFT JOIN   {{ ref('stg_cities') }} CT
    ON      CST.CITY = CT.CITY
)

SELECT * FROM CUSTOMERS

