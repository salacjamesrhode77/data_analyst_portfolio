{{ config(materialized='table') }}

SELECT
    listing_id,
    comments,
    comments_cleaned
FROM {{ ref('int_reviews') }}

/*
Limit rows to 100 for test/development runs only
Delete or comment out for production
*/

-- {% if var('is_test_run', default=true) %}

--   limit 120

-- {% endif %}
