{% macro clean_product(product_col) %}
    case
        when lower(trim({{ product_col }})) = 'gtxpro' then 'GTX Pro'
        else {{ product_col }}
    end
{% endmacro %}