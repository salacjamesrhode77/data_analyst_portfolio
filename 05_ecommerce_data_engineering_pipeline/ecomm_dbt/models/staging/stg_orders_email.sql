{{ config(materialized='view') }}

WITH deduped_email_orders AS (
    SELECT DISTINCT
        ORDER_DATE,
        CUSTOMER,
        PRODUCT,
        QTY,
        SKU,
        PRICE,
        LINE_TOTAL,
        TOTAL_AMOUNT,
        PAYMENT_DATE,
        EMAIL_TIMESTAMP,
        PAYMENT_METHOD,
        PAYMENT_REFERENCE
    FROM {{ source('raw_data', 'email_orders') }}
)

SELECT
    -- Order Identifier
    CAST(UPPER(SUBSTR(MD5(ORDER_DATE || CUSTOMER || PRODUCT || PAYMENT_DATE || QTY), 1, 12)) AS STRING) AS TRANSACTION_ID,
    CAST(CONCAT('#',UPPER(SUBSTR(MD5(ORDER_DATE || CUSTOMER), 1, 12))) AS STRING) AS ORDER_NUMBER,
    -- Customer Information
    CAST(CUSTOMER AS STRING) AS CUSTOMER_NAME,
    -- Product Information
    CAST(PRODUCT AS STRING) AS PRODUCT_NAME,
    CAST(QTY AS INTEGER) AS QUANTITY,
    CAST(SKU AS STRING) AS PRODUCT_SKU,
    CAST(PRICE AS STRING) AS UNIT_PRICE, 
    CAST(LINE_TOTAL AS STRING) AS LINE_TOTAL,
    CAST(TOTAL_AMOUNT AS STRING) AS TOTAL_AMOUNT,
    -- Transaction Dates
    CAST(ORDER_DATE AS TIMESTAMP_NTZ) AS ORDER_DATE,
    CAST(PAYMENT_DATE AS TIMESTAMP_NTZ) AS PAYMENT_DATE,
    CAST(EMAIL_TIMESTAMP AS TIMESTAMP_NTZ) AS EMAIL_TIMESTAMP,
    -- Payment Information
    CAST(PAYMENT_METHOD AS STRING) AS PAYMENT_METHOD,
    CAST(PAYMENT_REFERENCE AS STRING) AS PAYMENT_REFERENCE
FROM deduped_email_orders

/*
Limit rows to 100 for test/development runs only
Delete or comment out for production
*/

-- {% if var('is_test_run', default=true) %}

--   limit 100

-- {% endif %}