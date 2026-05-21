{{ config(materialized='table') }}

SELECT
    CASE 
        WHEN feature = 'is_repeating_amount' THEN 'Repeated Amount'
        WHEN feature = 'amount' THEN 'Transaction Value'
        WHEN feature = 'hour_of_day' THEN 'Transaction Time'
        WHEN feature = 'type_TRANSFER' THEN 'Transfers'
        WHEN feature = 'type_PAYMENT' THEN 'Payments'
        WHEN feature = 'type_CASH_OUT' THEN 'Withdrawals'
        WHEN feature = 'type_CASH_IN' THEN 'Deposits'
        WHEN feature = 'day_of_week' THEN 'Day of Week'
        WHEN feature = 'type_DEBIT' THEN 'Debit'
        ELSE feature
    END AS feature_name,
    CAST(importance as NUMERIC(10,4)) AS importance
FROM {{ ref('stg_feature_importance') }}