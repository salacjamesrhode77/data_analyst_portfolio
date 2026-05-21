{{ config(materialized='table') }}

SELECT
    transaction_id,
    datetime_id,
    timestamp,
    customer_id,
    destination_id,
    payment_method,
    gateway,
    amount,
    amount_bin,
    transaction_status,
    failure_reason,
    transaction_fee,
    gateway_cost,
    fee_revenue,
    processing_time_seconds,
    country,
    device_type,
    is_fraud,
    fraud_flag,
    risk_score,
    conf_matrix_category,
    chargeback_flag,
    fraud_loss
FROM {{ ref('int_transactions') }}