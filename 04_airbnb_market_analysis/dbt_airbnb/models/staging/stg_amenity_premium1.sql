{{ config(materialized='table') }}

SELECT
    CASE 
        WHEN amenity = 'child_friendly' THEN 'Child friendly'
        WHEN amenity = 'pool' THEN 'Pool'
        WHEN amenity = 'breakfast' THEN 'Breakfast'
        WHEN amenity = 'ev_support' THEN 'EV support'
        WHEN amenity = 'exercise' THEN 'Exercise'
        WHEN amenity = 'sound_system' THEN 'Sound system'
        WHEN amenity = 'housekeeping' THEN 'Housekeeping'
        WHEN amenity = 'luxury_services' THEN 'Luxury services'
        WHEN amenity = 'outdoor_recreation' THEN 'Outdoor recreation'
    END AS amenity,
    CAST(percent_impact/100 AS FLOAT)   AS price_adjustment
FROM {{ source('raw_data', 'viz_amenity_premium1') }}