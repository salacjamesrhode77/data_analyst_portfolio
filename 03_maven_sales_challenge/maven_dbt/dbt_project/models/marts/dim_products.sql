{{ config(materialized='table') }}

with stg_products as (
    select
        product,
        series,
        sales_price
    from {{ ref('stg_products') }}
)

select
    {{ dbt_utils.generate_surrogate_key(['product']) }} as product_id,
    product,
    series,
    sales_price
from stg_products
