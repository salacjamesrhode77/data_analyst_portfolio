{{ config(materialized='table') }}

SELECT
    transaction_id,
	CAST(TO_CHAR(timestamp, 'YYYYMMDDHH24') AS BIGINT) AS datetime_id,
    timestamp,
    customer_id,
    destination_id,
    payment_method,
    gateway,
    amount,
	CASE
        WHEN amount < 100 THEN '0-100'
        WHEN amount < 1000 THEN '100-1K'
        WHEN amount < 10000 THEN '1K-10K'
        WHEN amount < 100000 THEN '10K-100K'
        WHEN amount < 1000000 THEN '100K-1M'
        ELSE '1M+'
	END AS amount_bin,
    transaction_status,
    failure_reason,
    transaction_fee*1.5 AS transaction_fee,
    gateway_cost*0.5 as gateway_cost,
    (transaction_fee - gateway_cost) AS fee_revenue,
    processing_time_seconds,
    CASE
		WHEN country = 'PH' THEN 'Philippines'
		WHEN country = 'SG' THEN 'Singapore'
		WHEN country = 'MY' THEN 'Malaysia'
		WHEN country = 'ID' THEN 'Indonesia'
		ELSE 'Unknown'
	END AS country,
    device_type,
    is_fraud,
    fraud_flag,
    risk_score,
    CASE
        WHEN is_fraud = TRUE AND fraud_flag = TRUE THEN 'True Positive'
        WHEN is_fraud = FALSE AND fraud_flag = TRUE THEN 'False Positive'
        WHEN is_fraud = FALSE AND fraud_flag = FALSE THEN 'True Negative'
        WHEN is_fraud = TRUE AND fraud_flag = FALSE THEN 'False Negative'
    END AS conf_matrix_category,
    chargeback_flag,
    CASE
        WHEN transaction_status = 'Completed' AND fraud_flag = TRUE AND chargeback_flag = FALSE THEN gateway_cost
        WHEN transaction_Status = 'Completed' AND fraud_flag = TRUE AND chargeback_flag = TRUE THEN (gateway_cost + transaction_fee)
        ELSE 0
    END AS fraud_loss
FROM {{ ref('stg_transactions') }}