{{ config(materialized='table') }}


WITH reviews AS (
    SELECT
        listing_id,
        reviewer_name,
        comments,
        -- Cleaned version
        REGEXP_REPLACE(
            REGEXP_REPLACE(
                REGEXP_REPLACE(
                    LOWER(TRIM(comments)),
                    '<br\s*/?>', ' ', 'gi'  -- replace <br> with space
                ),
                '[^a-z0-9\s]', ' ', 'g'   -- remove non-alphanumeric
            ),
            '\s+', ' ', 'g'              -- collapse multiple spaces
        ) AS comments_cleaned
    FROM {{ ref('stg_reviews') }}
),

listings AS (
    SELECT
        listing_hash_id,
        listing_id
    FROM {{ ref('stg_listings') }}
)

SELECT
    l.listing_hash_id as listing_id,
    r.reviewer_name,
    r.comments,
    r.comments_cleaned
FROM reviews r
LEFT JOIN listings l
ON r.listing_id = l.listing_id
WHERE CHAR_LENGTH(comments_cleaned) > 20