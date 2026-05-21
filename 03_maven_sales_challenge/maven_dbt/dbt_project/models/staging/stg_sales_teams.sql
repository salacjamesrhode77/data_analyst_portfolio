{{ config(materialized='view') }}

select
    cast(sales_agent as text)   as sales_agent,
    cast(manager as text)    as manager,
    cast(regional_office as text)  regional_office
from {{ source('public', 'sales_teams') }}

