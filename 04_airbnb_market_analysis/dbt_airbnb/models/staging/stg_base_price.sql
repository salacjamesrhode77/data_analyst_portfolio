{{ config(materialized='table') }}

SELECT
    CASE
        WHEN segment = 'Home Comfort Seekers' THEN 0
        WHEN segment = 'Local Transit Explorers' THEN 1
    ELSE NULL
    END AS target_customer_id,
    CAST(mode AS FLOAT)                     AS base_price
FROM {{ source('raw_data', 'viz_base_price') }}