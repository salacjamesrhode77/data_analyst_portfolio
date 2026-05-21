{{ config(materialized='table') }}

with stg_sales_teams as (
    select
        sales_agent,
        manager
    from {{ ref('stg_sales_teams') }}
)

select
    {{ dbt_utils.generate_surrogate_key(['sales_agent']) }} as sales_agent_id,
    sales_agent,
    manager
from stg_sales_teams
