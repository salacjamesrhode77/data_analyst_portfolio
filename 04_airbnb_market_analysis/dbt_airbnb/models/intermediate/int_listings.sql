{{ config(materialized='table') }}

WITH price_stats AS (
    SELECT
        PERCENTILE_CONT(0.25) WITHIN GROUP (ORDER BY price) AS q1,
        PERCENTILE_CONT(0.75) WITHIN GROUP (ORDER BY price) AS q3
    FROM {{ ref('stg_listings') }}
),

filtered_listings AS (
    SELECT
        l.listing_hash_id AS listing_id,
        l.property_type,
        l.room_type,
        l.accommodates,
        CASE 
            WHEN (l.bedrooms = 0 OR l.bedrooms IS NULL) 
                 AND l.room_type NOT IN ('Private room', 'Shared room') THEN 1
            WHEN l.bedrooms = 0 THEN 0
            WHEN l.bedrooms IS NULL THEN 0
            ELSE l.bedrooms
        END AS bedrooms,
        CASE 
            WHEN l.beds = 0 OR l.beds IS NULL THEN 1
            ELSE l.beds
        END AS beds,
        CASE 
            WHEN l.bathrooms = 0 OR l.bathrooms IS NULL THEN 1
            ELSE l.bathrooms
        END AS bathrooms,
        CASE
            WHEN l.bathroom_type IS NULL THEN 'standard'
            ELSE l.bathroom_type
        END AS bathroom_type,
        l.price,
        l.minimum_nights,
        l.number_of_reviews
    FROM {{ ref('stg_listings') }} l
    CROSS JOIN price_stats ps
    WHERE l.price BETWEEN (ps.q1 - 1.5 * (ps.q3 - ps.q1))
                      AND (ps.q3 + 1.5 * (ps.q3 - ps.q1))
)

SELECT *
FROM filtered_listings