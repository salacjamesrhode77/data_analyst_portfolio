{{ config(materialized='table') }}

SELECT
    CAST(transaction_id AS UUID)                        AS transaction_id,
    CAST(timestamp AS TIMESTAMP)                        AS timestamp,
    CAST(customer_id AS CHAR(11))                       AS customer_id,
    CAST(destination_id AS CHAR(11))                    AS destination_id,
    CAST(payment_method AS VARCHAR(10))                 AS payment_method,
    CAST(gateway AS VARCHAR(10))                        AS gateway,
    CAST(amount AS NUMERIC(14,2))                       AS amount,
    CAST(transaction_status AS VARCHAR(10))             AS transaction_status,
    CAST(failure_reason AS VARCHAR(30))                 AS failure_reason,
    CAST(transaction_fee AS NUMERIC(12,2))              AS transaction_fee,
    CAST(gateway_cost AS NUMERIC(12,2))                 AS gateway_cost,
    CAST(processing_time_seconds AS DOUBLE PRECISION)   AS processing_time_seconds,
    CAST(country AS CHAR(2))                            AS country,
    CAST(device_type AS VARCHAR(10))                    AS device_type,
    (is_fraud = 1)                                      AS is_fraud,
    CAST(risk_score as NUMERIC(5,2))                    AS risk_score,
    (fraud_flag = 1)                                    AS fraud_flag,
    (chargeback_flag = 1)                               AS chargeback_flag
FROM {{ source('raw_data', 'transactions') }}