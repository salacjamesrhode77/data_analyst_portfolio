{{ config(materialized='table') }}

with stg_accounts as (
    select
        account,
        sector
    from {{ ref('stg_accounts') }}
)

select
    {{ dbt_utils.generate_surrogate_key(['account']) }} as account_id,
    account,
    sector
from stg_accounts