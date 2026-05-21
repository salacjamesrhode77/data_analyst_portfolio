{{ config(materialized='table') }}

SELECT DISTINCT
    merchant_id,
    merchant_country as merchant_country_code,
    CASE
		WHEN merchant_country = 'PH' THEN 'Philippines'
		WHEN merchant_country = 'SG' THEN 'Singapore'
		WHEN merchant_country = 'MY' THEN 'Malaysia'
		WHEN merchant_country = 'ID' THEN 'Indonesia'
		ELSE 'Unknown'
	END AS merchant_country,
    merchant_category,
    merchant_onboarding_date
FROM {{ ref('stg_merchants') }}