{{ config(materialized='table') }}

with bounds as (
    select
        cast(min(engage_date) as date) as min_date,
        cast(max(close_date) as date) as max_date
    from {{ ref('stg_sales_pipeline') }}
),

calendar as (
    select
        cast(gs.date as date) as date,
        cast(extract(year from gs.date) as int) as year,
        cast(extract(quarter from gs.date) as int) as quarter,
        date_trunc('quarter', gs.date) as quarter_start_date
    from bounds
    cross join lateral generate_series(bounds.min_date, bounds.max_date, interval '1 day') as gs(date)
)

select
    date,
    year,
    quarter,
    floor(
        (date_part('doy', date) - date_part('doy', quarter_start_date)) / 7
    ) + 1 as week_of_quarter
from calendar
order by date
