{{ config(materialized='view') }}

select
    cast(product as text)   as product,
    cast(series as text)    as series,
    cast(sales_price as numeric(12,2))  as sales_price
from {{ source('public', 'products') }}

