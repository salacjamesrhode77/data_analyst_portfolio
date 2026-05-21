{{ config(materialized='view') }}

select
    cast(account as text)   as account,
    cast(sector as text)    as sector,
    cast(revenue as numeric(12,2))  as revenue
from {{ source('public', 'accounts') }}
