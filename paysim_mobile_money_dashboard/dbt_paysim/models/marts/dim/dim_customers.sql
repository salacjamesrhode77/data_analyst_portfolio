{{ config(materialized='table') }}

SELECT DISTINCT
    customer_id,
    home_country as home_country_code,
    CASE
		WHEN home_country = 'PH' THEN 'Philippines'
		WHEN home_country = 'SG' THEN 'Singapore'
		WHEN home_country = 'MY' THEN 'Malaysia'
		WHEN home_country = 'ID' THEN 'Indonesia'
		ELSE 'Unknown'
	END AS home_country,
    primary_device,
    customer_signup_date
FROM {{ ref('stg_customers') }}
