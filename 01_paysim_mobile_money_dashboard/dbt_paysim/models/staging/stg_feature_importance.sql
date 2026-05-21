{{ config(materialized='table') }}

SELECT
    CAST(feature AS VARCHAR(20))                AS feature,
    CAST(importance AS DOUBLE PRECISION)        AS importance
FROM {{ source('raw_data', 'feature_importance') }}  