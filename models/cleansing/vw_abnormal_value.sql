{# 異常値データ公開用のView作成クエリ #}
{%- set db_name = 'db_mart_stg' if target.name == 'stg' else 'db_mart' -%}
{{-
    config(
        database=db_name,
        materialized="view",
    )
-}}

select 
    t2.store_name as store_name,
    t3.point as point,
    t1.value as value,
    t1.value_at::timestamp_tz as value_at
from
    {{ source('raw' ~ db_suffix, 'tbl_raw_abnormal_value') }} t1
inner join {{ source('common' ~ db_suffix, 'tbl_mst_store') }} t2 on (
    t1.store_id = t2.store_id
)
inner join {{ source('common' ~ db_suffix, 'tbl_mst_trend_group_point') }} t3 on (
    t1.store_id = t3.store_id and
    t1.log_id = t3.log_id and
    t1.item_index = t3.item_index
)