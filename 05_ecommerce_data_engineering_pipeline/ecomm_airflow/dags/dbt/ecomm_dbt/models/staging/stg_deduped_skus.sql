{{ config(materialized='view') }}

WITH DUPLICATES AS (
    SELECT  P.TITLE, P.PRODUCT_SKU
    FROM    {{ source('raw_data', 'products') }} P
    INNER JOIN  (
                    SELECT  TITLE
                    FROM    {{ source('raw_data', 'products') }}
                    GROUP BY    TITLE
                    HAVING COUNT(*) > 1
                ) AS DP
    ON DP.TITLE = P.TITLE
)


SELECT  TITLE,
        MAX(CASE WHEN ROW_NUM = 1 THEN PRODUCT_SKU END) AS SKU,
        MAX(CASE WHEN ROW_NUM = 2 THEN PRODUCT_SKU END) AS SKU_UPDATED
FROM (
        SELECT  TITLE,
                PRODUCT_SKU,
                ROW_NUMBER() OVER (PARTITION BY TITLE ORDER BY PRODUCT_SKU) AS ROW_NUM
        FROM DUPLICATES
     ) t
GROUP BY TITLE