{# tbl_mst_trend_group_pointからポイント情報の一覧を取得するマクロ #}
{% macro get_trend_points(store_id) %}

{% set query %}
select
    replace(lower(group_name), 'trend.'), log_id, item_index, point
from 
    db_common.public.tbl_mst_trend_group_point
where
    store_id = {{ store_id }}
order by log_id, item_index
{% endset %}
{% set results = run_query(query) %}
{{ log(results, info=True) }}
{{ return(results) }}
{% endmacro %}