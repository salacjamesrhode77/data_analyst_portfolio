{{ config(materialized='table') }}

SELECT
    SUBSTRING(MD5(CAST(id AS VARCHAR)), 1, 8)                                               AS listing_hash_id,
    CAST(id AS BIGINT)                                                                      AS listing_id,
    CAST(name AS VARCHAR)                                                                   AS listing_name,
    CAST(description AS VARCHAR)                                                            AS listing_description,
    CAST(host_id AS BIGINT)                                                                 AS host_id,
    CAST(host_name AS VARCHAR)                                                              AS host_name,
    CAST(host_since AS DATE)                                                                AS host_since,
    CAST(host_response_time AS VARCHAR)                                                     AS host_response_time,
    ROUND(CAST(NULLIF(REPLACE(host_response_rate, '%', ''),'N/A') AS NUMERIC) / 100, 2)     AS host_response_rate,
    CAST(host_is_superhost AS BOOLEAN)                                                      AS host_is_superhost,
    CAST(neighbourhood_cleansed AS VARCHAR)                                                 AS listing_location,
    CAST(latitude AS NUMERIC)                                                               AS latitude,
    CAST(longitude AS NUMERIC)                                                              AS longitude,
    CAST(property_type AS VARCHAR)                                                          AS property_type,
    CAST(room_type AS VARCHAR)                                                              AS room_type,
    CAST(accommodates AS INTEGER)                                                           AS accommodates,
    CAST(bedrooms AS INTEGER)                                                               AS bedrooms,
    CAST(beds AS INTEGER)                                                                   AS beds,
    CASE
        WHEN bathrooms_text ILIKE 'Private half-bath' THEN 0.5
        WHEN bathrooms_text ILIKE 'Shared half-bath' THEN 0.5
        WHEN bathrooms_text ILIKE 'Half-bath' THEN 0.5
        ELSE CAST(SPLIT_PART(bathrooms_text, ' ', 1) AS NUMERIC)
    END AS bathrooms,
    CASE
        WHEN bathrooms_text ILIKE 'Private half-bath' THEN 'private'
        WHEN bathrooms_text ILIKE 'Shared half-bath' THEN 'shared'
        WHEN bathrooms_text ILIKE 'Half-bath' THEN NULL
        WHEN SPLIT_PART(bathrooms_text, ' ', 2) IN ('private', 'shared')
            THEN SPLIT_PART(bathrooms_text, ' ', 2)
        ELSE NULL
    END AS bathroom_type,
    CAST(amenities AS VARCHAR)                                                              AS amenities,
    CAST(REPLACE(REPLACE(price, '$', ''), ',', '') AS NUMERIC)                              AS price,
    CAST(minimum_nights AS INTEGER)                                                         AS minimum_nights,
    CAST(number_of_reviews AS INTEGER)                                                      AS number_of_reviews,
    CAST(first_review AS DATE)                                                              AS first_review,
    CAST(last_review AS DATE)                                                               AS last_review,
    CAST(review_scores_rating AS NUMERIC)                                                   AS review_scores_rating,
    CAST(review_scores_cleanliness AS NUMERIC)                                              AS review_scores_cleanliness,
    CAST(review_scores_accuracy AS NUMERIC)                                                 AS review_scores_accuracy,
    CAST(review_scores_checkin AS NUMERIC)                                                  AS review_scores_checkin,
    CAST(review_scores_communication AS NUMERIC)                                            AS review_scores_communication,
    CAST(review_scores_location AS NUMERIC)                                                 AS review_scores_location,
    CAST(review_scores_value AS NUMERIC)                                                    AS review_scores_value
FROM {{ source('raw_data', 'listings') }}
WHERE price IS NOT NULL

-- READ THIS !
-- Missing columns that could be added in the future:
-- Nearby Attractions
-- Host Total Reviews
-- Host Ratings