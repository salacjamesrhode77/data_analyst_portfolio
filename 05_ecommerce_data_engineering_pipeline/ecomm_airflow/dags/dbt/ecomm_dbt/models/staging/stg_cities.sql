{{ config(materialized='view') }}

SELECT
    CAST(CITY AS STRING) AS CITY,
    CAST(LATITUDE AS DECIMAL(10,2)) AS LATITUDE,
    CAST(LONGITUDE AS DECIMAL(10,2)) AS LONGITUDE
FROM {{ source('raw_data', 'cities') }}
