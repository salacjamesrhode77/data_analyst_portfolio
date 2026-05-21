{{ config(materialized='table') }}

SELECT
    CAST(id AS BIGINT)                                                                      AS review_id,
    CAST(listing_id AS BIGINT)                                                              AS listing_id,
    CAST(date AS DATE)                                                                      AS review_date,
    CAST(reviewer_id AS BIGINT)                                                             AS reviewer_id,
    CAST(reviewer_name AS VARCHAR)                                                          AS reviewer_name,
    CAST(comments AS VARCHAR)                                                               AS comments
FROM {{ source('raw_data', 'reviews') }}