{{ config(materialized='table') }}

SELECT
    CASE
        WHEN segment = 'Home Comfort Seekers' THEN 0
        WHEN segment = 'Local Transit Explorers' THEN 1
    ELSE NULL
    END AS target_customer_id,
    CAST(slope AS FLOAT)                    AS extra_guest_premium
FROM {{ source('raw_data', 'viz_median_price') }}