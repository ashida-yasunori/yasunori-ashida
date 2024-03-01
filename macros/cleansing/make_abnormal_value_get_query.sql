{# RAWテーブル異常値データ取得用クエリの作成 #}
{% macro make_abnormal_value_get_query() %}
{%- set db_name = 'db_mart_stg' if target.name == 'stg' else 'db_mart' -%}
{% set query %}
{%- set trend_points = get_trend_group_names() -%}
{%- for trend_point in trend_points -%}
(
select
    t1.store_id, t1.log_id, t1.item_index, t1.unit, t1.aggregation_mode, t1.value, t1.value_at, t1.created_at
from {{ source('raw' ~ db_suffix, 'tbl_raw_' ~ trend_point[0]) }} t1
{{ make_inner_join_sync_log(0) -}}
inner join {{ source('common' ~ db_suffix, 'tbl_mst_trend_group_point') }} t3 on (
    t1.store_id = t3.store_id and
    t1.log_id = t3.log_id and
    t1.item_index = t3.item_index
)
inner join {{ source('common' ~ db_suffix, 'tbl_mst_value_range') }} t4 on (
    t3.value_type = t4.value_type
)
where (t4.min_value > t1.value OR t1.value > t4.max_value)
order by store_id, log_id, item_index, value_at
)
{%- if not loop.last %}
union 
{% endif -%}
{%- endfor %}
{% endset %}
{{ return(query) }}
{% endmacro %}