
{%- set db_name = 'db_mart_stg' if target.name == 'stg' else 'db_mart' -%}
{{-
    config(
        database=db_name,
        materialized="incremental",
        unique_key = ['store_id', 'log_id', 'item_index', 'value_at']
    )
-}}

(select
	t1.store_id, t1.log_id, t1.item_index, t1.unit, t1.aggregation_mode, t1.value, t1.value_at, to_timestamp(CURRENT_TIMESTAMP()) as created_at
from {{ source('raw' ~ db_suffix, 'tbl_raw_' ~ 'co2') }} t1
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
	(t4.min_value > t1.value OR t1.value > t4.max_value) and
	value_at between t2.log_last_min_at and t2.log_last_max_at
order by store_id, log_id, item_index, value_at
)
union
(select
	t1.store_id, t1.log_id, t1.item_index, t1.unit, t1.aggregation_mode, t1.value, t1.value_at, to_timestamp(CURRENT_TIMESTAMP()) as created_at
from {{ source('raw' ~ db_suffix, 'tbl_raw_' ~ 'energy_ac') }} t1
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
	(t4.min_value > t1.value OR t1.value > t4.max_value) and
	value_at between t2.log_last_min_at and t2.log_last_max_at
order by store_id, log_id, item_index, value_at
)
union
(select
	t1.store_id, t1.log_id, t1.item_index, t1.unit, t1.aggregation_mode, t1.value, t1.value_at, to_timestamp(CURRENT_TIMESTAMP()) as created_at
from {{ source('raw' ~ db_suffix, 'tbl_raw_' ~ 'energy_pv') }} t1
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
	(t4.min_value > t1.value OR t1.value > t4.max_value) and
	value_at between t2.log_last_min_at and t2.log_last_max_at
order by store_id, log_id, item_index, value_at
)
union
(select
	t1.store_id, t1.log_id, t1.item_index, t1.unit, t1.aggregation_mode, t1.value, t1.value_at, to_timestamp(CURRENT_TIMESTAMP()) as created_at
from {{ source('raw' ~ db_suffix, 'tbl_raw_' ~ 'humi') }} t1
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
	(t4.min_value > t1.value OR t1.value > t4.max_value) and
	value_at between t2.log_last_min_at and t2.log_last_max_at
order by store_id, log_id, item_index, value_at
)
union
(select
	t1.store_id, t1.log_id, t1.item_index, t1.unit, t1.aggregation_mode, t1.value, t1.value_at, to_timestamp(CURRENT_TIMESTAMP()) as created_at
from {{ source('raw' ~ db_suffix, 'tbl_raw_' ~ 'lux') }} t1
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
	(t4.min_value > t1.value OR t1.value > t4.max_value) and
	value_at between t2.log_last_min_at and t2.log_last_max_at
order by store_id, log_id, item_index, value_at
)
union
(select
	t1.store_id, t1.log_id, t1.item_index, t1.unit, t1.aggregation_mode, t1.value, t1.value_at, to_timestamp(CURRENT_TIMESTAMP()) as created_at
from {{ source('raw' ~ db_suffix, 'tbl_raw_' ~ 'ocs') }} t1
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
	(t4.min_value > t1.value OR t1.value > t4.max_value) and
	value_at between t2.log_last_min_at and t2.log_last_max_at
order by store_id, log_id, item_index, value_at
)
union
(select
	t1.store_id, t1.log_id, t1.item_index, t1.unit, t1.aggregation_mode, t1.value, t1.value_at, to_timestamp(CURRENT_TIMESTAMP()) as created_at
from {{ source('raw' ~ db_suffix, 'tbl_raw_' ~ 'outside') }} t1
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
	(t4.min_value > t1.value OR t1.value > t4.max_value) and
	value_at between t2.log_last_min_at and t2.log_last_max_at
order by store_id, log_id, item_index, value_at
)
union
(select
	t1.store_id, t1.log_id, t1.item_index, t1.unit, t1.aggregation_mode, t1.value, t1.value_at, to_timestamp(CURRENT_TIMESTAMP()) as created_at
from {{ source('raw' ~ db_suffix, 'tbl_raw_' ~ 'pressure_outside') }} t1
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
	(t4.min_value > t1.value OR t1.value > t4.max_value) and
	value_at between t2.log_last_min_at and t2.log_last_max_at
order by store_id, log_id, item_index, value_at
)
union
(select
	t1.store_id, t1.log_id, t1.item_index, t1.unit, t1.aggregation_mode, t1.value, t1.value_at, to_timestamp(CURRENT_TIMESTAMP()) as created_at
from {{ source('raw' ~ db_suffix, 'tbl_raw_' ~ 'statuslog') }} t1
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
	(t4.min_value > t1.value OR t1.value > t4.max_value) and
	value_at between t2.log_last_min_at and t2.log_last_max_at
order by store_id, log_id, item_index, value_at
)
union
(select
	t1.store_id, t1.log_id, t1.item_index, t1.unit, t1.aggregation_mode, t1.value, t1.value_at, to_timestamp(CURRENT_TIMESTAMP()) as created_at
from {{ source('raw' ~ db_suffix, 'tbl_raw_' ~ 'switchlog') }} t1
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
	(t4.min_value > t1.value OR t1.value > t4.max_value) and
	value_at between t2.log_last_min_at and t2.log_last_max_at
order by store_id, log_id, item_index, value_at
)
union
(select
	t1.store_id, t1.log_id, t1.item_index, t1.unit, t1.aggregation_mode, t1.value, t1.value_at, to_timestamp(CURRENT_TIMESTAMP()) as created_at
from {{ source('raw' ~ db_suffix, 'tbl_raw_' ~ 'temp') }} t1
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
	(t4.min_value > t1.value OR t1.value > t4.max_value) and
	value_at between t2.log_last_min_at and t2.log_last_max_at
order by store_id, log_id, item_index, value_at
)
union
(select
	t1.store_id, t1.log_id, t1.item_index, t1.unit, t1.aggregation_mode, t1.value, t1.value_at, to_timestamp(CURRENT_TIMESTAMP()) as created_at
from {{ source('raw' ~ db_suffix, 'tbl_raw_' ~ 'trend_energy_ac') }} t1
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
	(t4.min_value > t1.value OR t1.value > t4.max_value) and
	value_at between t2.log_last_min_at and t2.log_last_max_at
order by store_id, log_id, item_index, value_at
)
union
(select
	t1.store_id, t1.log_id, t1.item_index, t1.unit, t1.aggregation_mode, t1.value, t1.value_at, to_timestamp(CURRENT_TIMESTAMP()) as created_at
from {{ source('raw' ~ db_suffix, 'tbl_raw_' ~ 'trend_pressure') }} t1
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
	(t4.min_value > t1.value OR t1.value > t4.max_value) and
	value_at between t2.log_last_min_at and t2.log_last_max_at
order by store_id, log_id, item_index, value_at
)