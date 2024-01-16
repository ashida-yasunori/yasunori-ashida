{# tbl_mst_trend_group_pointからグループ名の一覧を取得するマクロ #}
{% macro get_trend_group_names(store_id) %}
{% set db_suffix = '_stg' if target.name == 'stg' else '' %}
{% set query %}
select distinct
    replace(lower(group_name), 'trend.')
from 
    db_common{{db_suffix}}.public.tbl_mst_trend_group_point
where
    store_id = {{ store_id }}
order by 1
{% endset %}
{% set results = run_query(query) %}

{{ return(results) }}
{% endmacro %}