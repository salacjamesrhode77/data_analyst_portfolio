{{ config(materialized='table') }}

SELECT
    PRODUCT_SKU,
    PRODUCT_NAME,
    PRODUCT_DESCRIPTION,
    PRODUCT_CATEGORY,
    VENDOR,
    UNIT_PRICE,
    IMAGE_SRC
FROM {{ ref('int_products') }}