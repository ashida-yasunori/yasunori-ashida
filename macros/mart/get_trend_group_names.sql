{# tbl_mst_trend_group_pointからグループ名の一覧を取得するマクロ #}
{% macro get_trend_group_names(store_id='') %}
{% set db_suffix = '_stg' if target.name == 'stg' else '' %}
{% set query %}
select distinct
    replace(lower(group_name), 'trend.')
from 
    {{ source('common' ~ db_suffix, 'tbl_mst_trend_group_point') }}
{% if store_id != '' -%}
where
    store_id = '{{ store_id }}'
{%- endif %}
order by 1
{% endset %}
{% set results = run_query(query) %}
{{ return(results) }}
{% endmacro %}