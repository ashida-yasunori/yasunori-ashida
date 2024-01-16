{# tbl_mst_trend_group_pointからポイント情報の一覧を取得するマクロ #}
{% macro get_trend_points(store_id) %}
{% set db_suffix = '_stg' if target.name == 'stg' else '' %}
{% set query %}
select
    replace(lower(group_name), 'trend.'), log_id, item_index, point
from 
    db_common{{db_suffix}}.public.tbl_mst_trend_group_point
where
    store_id = {{ store_id }}
order by log_id, item_index
{% endset %}
{% set results = run_query(query) %}

{{ return(results) }}
{% endmacro %}