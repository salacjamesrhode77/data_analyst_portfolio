{{ config(materialized='table') }}

WITH PRODUCTS AS (
    SELECT  
        PRODUCT_SKU,
        PRODUCT_NAME,
        PRODUCT_DESCRIPTION,
        PRODUCT_CATEGORY,
        VENDOR,
        UNIT_PRICE,
        IMAGE_SRC
    FROM {{ ref('stg_products') }}
)

SELECT * FROM PRODUCTS
WHERE PRODUCT_SKU NOT IN (SELECT DISTINCT SKU FROM {{ ref('stg_deduped_skus')}})
