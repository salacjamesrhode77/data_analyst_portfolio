{{ config(materialized='table') }}

SELECT
    *
FROM {{ ref('stg_extra_guest_premium') }}