{{ config(materialized='table') }}

WITH listings AS (
    SELECT
        listing_id,
        property_type,
        room_type,
        accommodates,
        bedrooms,
        beds,
        bathrooms,
        bathroom_type,
        price,
        minimum_nights
    FROM {{ ref('int_listings') }}
),

amenities  AS (
    SELECT
        listing_id,
        air_conditioning,
        basic_comfort,
        basic_cooking,
        bathroom_fixtures,
        beddings,
        breakfast,
        child_friendly,
        cleaning,
        dining_area,
        elevator,
        entertainment_leisure,
        essentials,
        ev_support,
        exercise,
        flexible_stays,
        hot_water,
        housekeeping,
        kitchen,
        luxury_services,
        other,
        outdoor_recreation,
        parking,
        pet_friendly,
        pool,
        refrigerator,
        safety_features,
        self_check_in,
        sound_system,
        storage,
        toiletries,
        tv,
        view,
        washer_dryer,
        wifi
    FROM {{ ref('int_amenities') }}
)

SELECT
    l.listing_id,
    l.property_type,
    l.room_type,
    l.accommodates,
    l.bedrooms,
    l.beds,
    l.bathrooms,
    l.bathroom_type,
    l.price,
    l.minimum_nights,
    a.air_conditioning,
    a.basic_comfort,
    a.basic_cooking,
    a.bathroom_fixtures,
    a.beddings,
    a.breakfast,
    a.child_friendly,
    a.cleaning,
    a.dining_area,
    a.elevator,
    a.entertainment_leisure,
    a.essentials,
    a.ev_support,
    a.exercise,
    a.flexible_stays,
    a.hot_water,
    a.housekeeping,
    a.kitchen,
    a.luxury_services,
    a.other,
    a.outdoor_recreation,
    a.parking,
    a.pet_friendly,
    a.pool,
    a.refrigerator,
    a.safety_features,
    a.self_check_in,
    a.sound_system,
    a.storage,
    a.toiletries,
    a.tv,
    a.view,
    a.washer_dryer,
    a.wifi
FROM listings l
INNER JOIN amenities a ON l.listing_id = a.listing_id

/*
Limit rows to 100 for test/development runs only
Delete or comment out for production
*/

-- {% if var('is_test_run', default=true) %}

--   limit 20

-- {% endif %}
