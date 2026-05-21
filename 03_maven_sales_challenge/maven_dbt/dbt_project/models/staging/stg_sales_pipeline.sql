{{ config(materialized='view') }}

select
    {{ dbt_utils.generate_surrogate_key(['opportunity_id']) }}  as opportunity_id,
    cast(sales_agent as text)   as sales_agent,
    cast({{ clean_product('product') }} as text)   as product,
    cast(account as text)   as account,
    cast(deal_stage as text)    as deal_stage,
    cast(engage_date as date)   as engage_date,
    cast(close_date as date)    as close_date,
    cast(close_value as numeric(12,2))  as close_value
from {{ source('public', 'sales_pipeline') }}
where account is not null
    and sales_agent is not null
    and product is not null

