{{ config(materialized='table') }}

SELECT
    CASE 
        WHEN amenity = 'pool' THEN 'Pool'
        WHEN amenity = 'child_friendly' THEN 'Child friendly'
        WHEN amenity = 'ev_support' THEN 'EV support'
        WHEN amenity = 'sound_system' THEN 'Sound system'
        WHEN amenity = 'breakfast' THEN 'Breakfast'
        WHEN amenity = 'housekeeping' THEN 'Housekeeping'
        WHEN amenity = 'cleaning' THEN 'Cleaning supplies'
        WHEN amenity = 'pet_friendly' THEN 'Pet Friendly'
        WHEN amenity = 'view' THEN 'View'
    END AS amenity,
    CAST(percent_impact/100 AS FLOAT)   AS price_adjustment
FROM {{ source('raw_data', 'viz_amenity_premium2') }}