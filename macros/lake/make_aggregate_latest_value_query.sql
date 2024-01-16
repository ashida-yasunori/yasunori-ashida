{#- 設定変更時生成トレンドログ(statuslog, switchlog)の1分単位集約クエリの作成 -#}
{% macro make_aggregate_latest_value_query(trend) %}
{% set db_suffix = '_stg' if target.name == 'stg' else '' %}
{% set query %}
with query1 as (
select
     t1.store_id,
     t1.log_id,
     t1.item_index,
     t1.value,
     t1.value_at,
     DATEADD(second, 59, t1.value_at) as value_at_add_59sec,
     year(DATEADD(second, 59, t1.value_at)) as value_at_year,
     month(DATEADD(second, 59, t1.value_at)) as value_at_month,
     day(DATEADD(second, 59, t1.value_at)) as value_at_day,
     hour(DATEADD(second, 59, t1.value_at)) as value_at_hour,
     minute(DATEADD(second, 59, t1.value_at)) as value_at_min
from 
     db_raw{{db_suffix}}.public.tbl_raw_{{trend}} t1
{{ make_inner_join_sync_log(1) -}}
),

query2 as (
select
     store_id,
     log_id,
     item_index,
     max_by(value, value_at) value,
     max(value_at_add_59sec) as value_at_add_59sec
from 
     query1
group by 
     store_id, log_id, item_index, value_at_year, value_at_month, value_at_day, value_at_hour, value_at_min
)

select
    t1.store_id,
    t1.log_id,
    t1.item_index,
    to_varchar(t1.value) as value,
    TIMESTAMP_FROM_PARTS(
       Year(t1.value_at_add_59sec), 
       Month(t1.value_at_add_59sec), 
       DAY(t1.value_at_add_59sec), 
       Hour(t1.value_at_add_59sec), 
       MINUTE(t1.value_at_add_59sec),
       0
    ) as value_at,
    to_timestamp(CURRENT_TIMESTAMP()) as last_updated_at
from 
    query2 t1
order by store_id, log_id, item_index, value_at
{% endset %}

{{ return(query) }}
{% endmacro %}