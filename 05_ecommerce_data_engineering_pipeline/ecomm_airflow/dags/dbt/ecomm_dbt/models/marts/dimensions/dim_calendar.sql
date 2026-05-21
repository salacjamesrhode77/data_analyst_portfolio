{{ config(materialized='table') }}

WITH RECURSIVE CALENDAR(DATE) AS (
    SELECT DATE(
        SELECT MIN(DATE(ORDER_DATE)) FROM {{ ref('int_orders') }}
        )
    
    UNION ALL
    
    SELECT DATEADD(DAY, 1, DATE)
    FROM CALENDAR
    WHERE DATE < DATE(
        SELECT MAX(DATE(ORDER_DATE)) FROM {{ ref('int_orders') }}
        )
)
SELECT  DATE,

        CASE DAYOFWEEK(DATE)
            WHEN 0 THEN 'SUN'
            WHEN 1 THEN 'MON'
            WHEN 2 THEN 'TUE'
            WHEN 3 THEN 'WED'
            WHEN 4 THEN 'THU'
            WHEN 5 THEN 'FRI'
            WHEN 6 THEN 'SAT'
        ELSE NULL
        END AS DAY,

        CASE MONTH(DATE)
            WHEN 1 THEN 'JAN'
            WHEN 2 THEN 'FEB'
            WHEN 3 THEN 'MAR'
            WHEN 4 THEN 'APR'
            WHEN 5 THEN 'MAY'
            WHEN 6 THEN 'JUN'
            WHEN 7 THEN 'JUL'
            WHEN 8 THEN 'AUG'
            WHEN 9 THEN 'SEP'
            WHEN 10 THEN 'OCT'
            WHEN 11 THEN 'NOV'
            WHEN 12 THEN 'DEC'
        ELSE NULL
        END AS MONTH,

        CONCAT('Q',QUARTER(DATE)) AS QUARTER,
        YEAR(DATE) AS YEAR
FROM    CALENDAR