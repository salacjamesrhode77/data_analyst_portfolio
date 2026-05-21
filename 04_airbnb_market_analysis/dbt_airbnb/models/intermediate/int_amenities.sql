{{ config(materialized='table') }}

WITH amenities AS (
    SELECT 
        listing_hash_id AS listing_id,
        LOWER(
            TRIM(
                REGEXP_REPLACE(
                    REGEXP_REPLACE(
                        jsonb_array_elements_text(
                            CAST(REPLACE(amenities, '""', '"') AS jsonb)
                        ),
                        '[^a-zA-Z0-9\s+]', ' ', 'g'
                    ),
                    '\s+', ' ', 'g'
                )
            )
        ) AS amenity
    FROM {{ ref('stg_listings') }}
), 

categorized_amenities AS (
    SELECT
        listing_id,
        CASE
            WHEN amenity ILIKE ANY (ARRAY['%air conditioning%', '%ac%']) THEN 'air conditioning'
            WHEN amenity ILIKE ANY (ARRAY['%wifi%', '%connection%']) THEN 'wifi'
            WHEN amenity ILIKE ANY (ARRAY['%kitchen%', '%stove%', '%microwave%', '%oven%', '%grill%']) THEN 'kitchen'
            WHEN amenity ILIKE ANY (ARRAY['%refrigerator%', '%freezer%', '%mini fridge%']) THEN 'refrigerator'
            WHEN amenity ILIKE ANY (ARRAY['%pool%', '%resort%']) THEN 'pool'
            WHEN amenity ILIKE '%parking%' THEN 'parking'
            WHEN amenity ILIKE '%view%' THEN 'view'
            WHEN amenity ILIKE '%dedicated workspace%' THEN 'dedicated workspace'
            WHEN amenity ILIKE ANY (ARRAY['%washer%', '%dryer%', '%laundromat%']) THEN 'washer/dryer'
            WHEN amenity ILIKE ANY (ARRAY['%exercise%', '%gym%', '%weights%']) THEN 'exercise'
            WHEN amenity ILIKE ANY (ARRAY['%housekeeping%', '%cleaning available%']) THEN 'housekeeping'
            WHEN amenity ILIKE '%elevator%' THEN 'elevator'
            WHEN amenity ILIKE ANY (ARRAY['%tv%', '%hdtv%', '%netflix%']) THEN 'tv'
            WHEN amenity ILIKE ANY (ARRAY['%sound%', '%speaker%']) THEN 'sound system'
            WHEN amenity ILIKE ANY (ARRAY['%breakfast%', '%coffee%']) THEN 'breakfast'
            WHEN amenity ILIKE ANY (ARRAY['%hot water kettle%', '%rice maker%', '%rice cooker%', '%coffee maker%', '%toaster%', '%cooking%']) THEN 'basic cooking'
            WHEN amenity ILIKE ANY (ARRAY['%dishes and silverware%', '%utensils%', '%dining area%', '%glasses%', '%blender%', '%bread maker%', '%baking sheet%', '%dining table%']) THEN 'dining area'
            WHEN amenity ILIKE ANY (ARRAY['%shower%', '%bathtub%', '%bath%', '%bidet%', '%washlet%', '%toilet%']) THEN 'bathroom fixtures'
            WHEN amenity ILIKE ANY (ARRAY['%hair dryer%', '%mirror%', '%vanity%']) THEN 'grooming'
            WHEN amenity ILIKE ANY (ARRAY['%heating%', '%hot water%', '%hot tub%']) THEN 'hot water'
            WHEN amenity ILIKE ANY (ARRAY['%shampoo%', '%conditioner%', '%soap%', '%body wash%', '%toiletries%']) THEN 'toiletries'
            WHEN amenity ILIKE ANY (ARRAY['%linens%', '%pillows%', '%blankets%', '%bed sheets%', '%towels%']) THEN 'beddings'
            WHEN amenity ILIKE ANY (ARRAY['%hangers%', '%closet%', '%wardrobe%', '%rack%', '%dresser%', '%clothing storage%']) THEN 'storage'
            WHEN amenity ILIKE ANY (ARRAY['%cleaning%', '%cleaner%', '%disinfectant%', '%laundry%', '%washer%']) THEN 'cleaning'
            WHEN amenity ILIKE '%essentials%' THEN 'essentials'
            WHEN amenity ILIKE ANY (ARRAY['%baby%', '%crib%', '%changing table%', '%high chair%', '%booster seat%', '%children%', '%playroom%', '%outlet covers%', '%table corner guards%', '%window guards%']) THEN 'child friendly'
            WHEN amenity ILIKE ANY (ARRAY['%arcade%', '%board games%', '%game console%', '%game room%', '%ping pong%', '%piano%', '%record player%', '%movie theater%', '%laser tag%', '%life size games%', '%theme room%']) THEN 'entertainment/leisure'
            WHEN amenity ILIKE ANY (ARRAY['%bikes%', '%kayak%', '%batting cage%', '%bowling alley%', '%climbing wall%', '%skate ramp%', '%hammock%', '%outdoor playground%', '%fire pit%', '%mini golf%', '%sun loungers%', '%waterfront%', '%hockey%', '%ski%']) THEN 'outdoor/recreation'
            WHEN amenity ILIKE ANY (ARRAY['%alarm%', '%fire extinguisher%', '%camera%', '%first aid kit%', '%lock%', '%lockbox%', '%keypad%', '%smart lock%', '%security system%', '%noise decibel%', '%safe%']) THEN 'safety features'
            WHEN amenity ILIKE ANY (ARRAY['%chef%', '%airport transfer%', '%building staff%', '%property manager%', '%host greets you%', '%mini bar%', '%private sauna%', '%sauna%']) THEN 'luxury services'
            WHEN amenity ILIKE ANY (ARRAY['%private entrance%', '%self check%', '%lockbox%', '%smart lock%']) THEN 'self check-in'
            WHEN amenity ILIKE ANY (ARRAY['%long term stays%', '%luggage dropoff%', '%single level home%']) THEN 'flexible stays'
            WHEN amenity ILIKE ANY (ARRAY['%pets allowed%', '%pet friendly%', '%pet%']) THEN 'pet friendly'
            WHEN amenity ILIKE ANY (ARRAY['%ceiling fan%', '%portable fan%', '%portable heater%', '%room darkening shades%', '%mosquito net%']) THEN 'basic comfort'
            WHEN amenity ILIKE ANY (ARRAY['%ev charger%', '%garage%', '%carport%']) THEN 'ev support'
            ELSE 'other'
        END AS amenity
    FROM amenities
)

SELECT
    listing_id,
    MAX(air_conditioning) AS air_conditioning,
    MAX(basic_comfort) AS basic_comfort,
    MAX(basic_cooking) AS basic_cooking,
    MAX(bathroom_fixtures) AS bathroom_fixtures,
    MAX(beddings) AS beddings,
    MAX(breakfast) AS breakfast,
    MAX(child_friendly) AS child_friendly,
    MAX(cleaning) AS cleaning,
    MAX(dining_area) AS dining_area,
    MAX(elevator) AS elevator,
    MAX(entertainment_leisure) AS entertainment_leisure,
    MAX(essentials) AS essentials,
    MAX(ev_support) AS ev_support,
    MAX(exercise) AS exercise,
    MAX(flexible_stays) AS flexible_stays,
    MAX(hot_water) AS hot_water,
    MAX(housekeeping) AS housekeeping,
    MAX(kitchen) AS kitchen,
    MAX(luxury_services) AS luxury_services,
    MAX(other) AS other,
    MAX(outdoor_recreation) AS outdoor_recreation,
    MAX(parking) AS parking,
    MAX(pet_friendly) AS pet_friendly,
    MAX(pool) AS pool,
    MAX(refrigerator) AS refrigerator,
    MAX(safety_features) AS safety_features,
    MAX(self_check_in) AS self_check_in,
    MAX(sound_system) AS sound_system,
    MAX(storage) AS storage,
    MAX(toiletries) AS toiletries,
    MAX(tv) AS tv,
    MAX(view) AS view,
    MAX(washer_dryer) AS washer_dryer,
    MAX(wifi) AS wifi
FROM (
    SELECT
        listing_id,
        CASE WHEN amenity = 'air conditioning' THEN 1 ELSE 0 END AS air_conditioning,
        CASE WHEN amenity = 'basic comfort' THEN 1 ELSE 0 END AS basic_comfort,
        CASE WHEN amenity = 'basic cooking' THEN 1 ELSE 0 END AS basic_cooking,
        CASE WHEN amenity = 'bathroom fixtures' THEN 1 ELSE 0 END AS bathroom_fixtures,
        CASE WHEN amenity = 'beddings' THEN 1 ELSE 0 END AS beddings,
        CASE WHEN amenity = 'breakfast' THEN 1 ELSE 0 END AS breakfast,
        CASE WHEN amenity = 'child friendly' THEN 1 ELSE 0 END AS child_friendly,
        CASE WHEN amenity = 'cleaning' THEN 1 ELSE 0 END AS cleaning,
        CASE WHEN amenity = 'dining area' THEN 1 ELSE 0 END AS dining_area,
        CASE WHEN amenity = 'elevator' THEN 1 ELSE 0 END AS elevator,
        CASE WHEN amenity = 'entertainment/leisure' THEN 1 ELSE 0 END AS entertainment_leisure,
        CASE WHEN amenity = 'essentials' THEN 1 ELSE 0 END AS essentials,
        CASE WHEN amenity = 'ev support' THEN 1 ELSE 0 END AS ev_support,
        CASE WHEN amenity = 'exercise' THEN 1 ELSE 0 END AS exercise,
        CASE WHEN amenity = 'flexible stays' THEN 1 ELSE 0 END AS flexible_stays,
        CASE WHEN amenity = 'hot water' THEN 1 ELSE 0 END AS hot_water,
        CASE WHEN amenity = 'housekeeping' THEN 1 ELSE 0 END AS housekeeping,
        CASE WHEN amenity = 'kitchen' THEN 1 ELSE 0 END AS kitchen,
        CASE WHEN amenity = 'luxury services' THEN 1 ELSE 0 END AS luxury_services,
        CASE WHEN amenity = 'other' THEN 1 ELSE 0 END AS other,
        CASE WHEN amenity = 'outdoor/recreation' THEN 1 ELSE 0 END AS outdoor_recreation,
        CASE WHEN amenity = 'parking' THEN 1 ELSE 0 END AS parking,
        CASE WHEN amenity = 'pet friendly' THEN 1 ELSE 0 END AS pet_friendly,
        CASE WHEN amenity = 'pool' THEN 1 ELSE 0 END AS pool,
        CASE WHEN amenity = 'refrigerator' THEN 1 ELSE 0 END AS refrigerator,
        CASE WHEN amenity = 'safety features' THEN 1 ELSE 0 END AS safety_features,
        CASE WHEN amenity = 'self check-in' THEN 1 ELSE 0 END AS self_check_in,
        CASE WHEN amenity = 'sound system' THEN 1 ELSE 0 END AS sound_system,
        CASE WHEN amenity = 'storage' THEN 1 ELSE 0 END AS storage,
        CASE WHEN amenity = 'toiletries' THEN 1 ELSE 0 END AS toiletries,
        CASE WHEN amenity = 'tv' THEN 1 ELSE 0 END AS tv,
        CASE WHEN amenity = 'view' THEN 1 ELSE 0 END AS view,
        CASE WHEN amenity = 'washer/dryer' THEN 1 ELSE 0 END AS washer_dryer,
        CASE WHEN amenity = 'wifi' THEN 1 ELSE 0 END AS wifi
    FROM categorized_amenities
) AS one_hot
GROUP BY listing_id

/*
Limit rows to 100 for test/development runs only
Delete or comment out for production
*/

-- {% if var('is_test_run', default=true) %}

--   limit 20

-- {% endif %}
