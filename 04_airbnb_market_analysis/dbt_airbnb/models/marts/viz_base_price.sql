{{ config(materialized='table') }}

SELECT
    *
FROM {{ ref('stg_base_price') }}