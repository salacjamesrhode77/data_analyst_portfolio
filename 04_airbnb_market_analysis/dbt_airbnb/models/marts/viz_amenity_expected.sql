{{ config(materialized='table') }}

SELECT
    *
FROM {{ ref('stg_amenity_expected') }}