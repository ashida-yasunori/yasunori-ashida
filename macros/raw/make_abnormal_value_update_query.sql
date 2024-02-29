{#- TBL_MST_VALUE_RANGEから異常値のデータを取得しnullに置き換えるクエリの作成 -#}
{% macro make_abnormal_value_update_query(trend) %}
{% set db_suffix = '_stg' if target.name == 'stg' else '' %}
{% set query %}
-- depends_on: {{ ref('tbl_mart_abnormal_value') }}
select
	t1.store_id, t1.log_id, t1.item_index, t1.unit, t1.aggregation_mode, null as value, t1.value_at, to_timestamp(CURRENT_TIMESTAMP()) as created_at
from {{ source('mart' ~ db_suffix, 'tbl_mart_abnormal_value') }} t1
{{ make_inner_join_sync_log(0) -}}
inner join {{ source('common' ~ db_suffix, 'tbl_mst_trend_group_point') }} t3 on (
	t1.store_id = t3.store_id and
	t1.log_id = t3.log_id and
	t1.item_index = t3.item_index
)
inner join {{ source('common' ~ db_suffix, 'tbl_mst_value_range') }} t4 on (
	t3.value_type = t4.value_type
)
where
    t3.group_name = 'Trend.{{ trend }}' and
	(t4.min_value > t1.value OR t1.value > t4.max_value) and
	value_at between t2.log_last_min_at and t2.log_last_max_at
order by store_id, log_id, item_index, value_at
{% endset %}

{{ return(query) }}
{% endmacro %}