SELECT *
FROM {{ ref('int_orders') }} O
LEFT JOIN {{ ref('dim_products') }} P
ON O.PRODUCT_SKU = P.PRODUCT_SKU
WHERE P.PRODUCT_SKU IS NULL