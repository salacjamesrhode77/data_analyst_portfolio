{% macro test_values_in_another_model(model, column_name, ref_model, ref_column) %}

with lookup as (
    select distinct {{ column_name }} as val
    from {{ model }}
),
trans as (
    select distinct {{ ref_column }} as val
    from {{ ref_model }}
)

select lookup.val
from lookup
right join trans using (val)
where trans.val is null

{% endmacro %}


-- Use 'a' now as the lookup table and 'b' as the stg_sales_pipeline table and reverse the join logic
-- also the test is done in each lookup tables not in the sales pipeline
