{# tbl_mst_storeから店舗名を取得するマクロ #}
{% macro get_store_name(store_id) %}
{% set db_suffix = '_stg' if target.name == 'stg' else '' %}
{% set query %}
select
    store_name
from 
    {{ source('common' ~ db_suffix, 'tbl_mst_store') }}
    -- db_common{{db_suffix}}.public.tbl_mst_store
where
    store_id = {{ store_id }}
{% endset %}

{% set results = run_query(query) %}
{%- if execute -%}
    {% set r = results.columns[0].values() %}
    {% if r | length == 0 %}
        {% do print('Query `' ~ query ~ '` returned no rows. Using the default value: ' ~ default) %}
        {% set sql_result = '' %}
    {% else %}
        {% set sql_result = r[0] %}
    {% endif %}
{%- else -%}
    {% set sql_result = '' %}
{%- endif -%}
{{ log('店舗名=' ~ sql_result, info=True) }}
{% do return(sql_result) %}

{% endmacro %}