{{ config(materialized='table') }}

with sp as (
    select
        *
    from {{ ref('stg_sales_pipeline') }}
),
dst as (
    select
        sales_agent_id,
        sales_agent
    from {{ ref('dim_sales_teams') }}
),
dp as (
    select
        product_id,
        product,
        sales_price
    from {{ ref('dim_products') }}
),
da as (
    select
        account_id,
        account
    from {{ ref('dim_accounts') }}
)

select
    sp.opportunity_id,
    dst.sales_agent_id,
    dp.product_id,
    da.account_id,
    deal_stage,
    engage_date,
    close_date,
    cast((close_date - engage_date) as int) as days_closed,
    close_value,
    sales_price,
    case
        when deal_stage != 'Won' then null
        else cast(round(((close_value - sales_price)/sales_price)/0.05)*0.05 as float)
    end as percent_markup
from sp
left join dst on sp.sales_agent = dst.sales_agent
left join dp on sp.product = dp.product
left join da on sp.account = da.account
where sp.deal_stage in ('Won', 'Lost')