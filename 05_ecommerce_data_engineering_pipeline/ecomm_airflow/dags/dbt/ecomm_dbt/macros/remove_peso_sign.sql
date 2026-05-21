{% macro remove_peso_sign(currency_col) %}
    regexp_replace({{ currency_col }}, '₱', '')
{% endmacro %}
