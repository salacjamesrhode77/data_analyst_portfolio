{{ config(materialized='table') }}

SELECT
    CASE 
        WHEN amenity = 'air_conditioning' THEN 'Air conditioning'
        WHEN amenity = 'wifi' THEN 'Wifi'
        WHEN amenity = 'safety_features' THEN 'Safety features'
        WHEN amenity = 'washer_dryer' THEN 'Washer/Dryer'
        WHEN amenity = 'tv' THEN 'TV'
        WHEN amenity = 'storage' THEN 'Storage'
        WHEN amenity = 'kitchen' THEN 'Kitchen'
        WHEN amenity = 'hot_water' THEN 'Hot water'
        WHEN amenity = 'toiletries' THEN 'Toiletries'
        WHEN amenity = 'refrigerator' THEN 'Refrigerator'
        WHEN amenity = 'essentials' THEN 'Essentials'
        WHEN amenity = 'other' THEN 'Other'
        WHEN amenity = 'dining_area' THEN 'Dining area'
        WHEN amenity = 'basic_cooking' THEN 'Basic cooking'
        WHEN amenity = 'self_check_in' THEN 'Self check in'
        WHEN amenity = 'bathroom_fixtures' THEN 'Bathroom fixtures'
        WHEN amenity = 'flexible_stays' THEN 'Flexible stays'
        WHEN amenity = 'beddings' THEN 'Beddings'
        WHEN amenity = 'parking' THEN 'Parking'
        WHEN amenity = 'elevator' THEN 'Elevator'
        WHEN amenity = 'pool' THEN 'Pool'
        WHEN amenity = 'exercise' THEN 'Exercise'
        WHEN amenity = 'basic_comfort' THEN 'Basic comfort'
        WHEN amenity = 'luxury_services' THEN 'Luxury services'
        WHEN amenity = 'cleaning' THEN 'Cleaning supplies'
        WHEN amenity = 'breakfast' THEN 'Breakfast'
        WHEN amenity = 'view' THEN 'View'
        WHEN amenity = 'housekeeping' THEN 'Housekeeping'
        WHEN amenity = 'child_friendly' THEN 'Child friendly'
        WHEN amenity = 'outdoor_recreation' THEN 'Outdoor recreation'
        WHEN amenity = 'entertainment_leisure' THEN 'Entertainment leisure'
        WHEN amenity = 'ev_support' THEN 'EV support'
        WHEN amenity = 'pet_friendly' THEN 'Pet friendly'
        WHEN amenity = 'sound_system' THEN 'Sound system'
    END AS amenity,
    CAST(count AS FLOAT)   AS running_contribution
FROM {{ source('raw_data', 'viz_parreto_customer1') }}
WHERE count < 82