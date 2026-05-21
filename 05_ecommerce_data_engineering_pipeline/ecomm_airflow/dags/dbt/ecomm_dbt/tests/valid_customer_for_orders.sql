SELECT *
FROM {{ ref('int_orders') }} O
LEFT JOIN {{ ref('dim_customers') }} C
ON O.CUSTOMER_ID = C.CUSTOMER_ID
WHERE C.CUSTOMER_ID IS NULL