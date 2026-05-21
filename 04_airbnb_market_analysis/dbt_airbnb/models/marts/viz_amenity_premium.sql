{{ config(materialized='table') }}

SELECT
    0 as target_customer_id,
    amenity,
    price_adjustment
FROM {{ ref('stg_amenity_premium1') }}

UNION ALL

SELECT
    1 as target_customer_id,
    amenity,
    price_adjustment
FROM {{ ref('stg_amenity_premium2') }}