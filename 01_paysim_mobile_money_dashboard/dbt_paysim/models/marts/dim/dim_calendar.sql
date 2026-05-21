{{ config(materialized='table') }}

WITH bounds AS (
    SELECT
        DATE_TRUNC('hour', MIN(timestamp)) AS min_ts,
        DATE_TRUNC('hour', MAX(timestamp)) AS max_ts
    FROM {{ ref('int_transactions') }}
),

hour_spine AS (
    SELECT
        generate_series(
            (SELECT min_ts FROM bounds),
            (SELECT max_ts FROM bounds),
            INTERVAL '1 hour'
        ) AS ts_hour
)

SELECT
    CAST(TO_CHAR(ts_hour, 'YYYYMMDDHH24') AS BIGINT) AS datetime_id,
    CAST(ts_hour AS DATE)                            AS date,
    CAST(EXTRACT(HOUR FROM ts_hour) AS INT)          AS hour,
    CAST(EXTRACT(DAY FROM ts_hour) AS INT)           AS day,
    TO_CHAR(ts_hour, 'FMDy')                         AS day_name,
    CONCAT('Week ', EXTRACT(WEEK FROM ts_hour))      AS week
FROM hour_spine
ORDER BY datetime_id