{#- 設定変更時生成トレンドログ(statuslog, switchlog)の1分単位集約クエリの作成 -#}
{% macro make_statuslog_switchlog_query(trend) %}

{% set query %}
with query1 as (
select
     t1.store_id,
     t1.log_id,
     t1.item_index,
     t1.value,
     t1.value_at,
     year(DATEADD(second, 59, t1.value_at)) as value_at_year,
     month(DATEADD(second, 59, t1.value_at)) as value_at_month,
     day(DATEADD(second, 59, t1.value_at)) as value_at_day,
     hour(DATEADD(second, 59, t1.value_at)) as value_at_hour,
     minute(DATEADD(second, 59, t1.value_at)) as value_at_min
from 
     {{ 'db_raw.public.tbl_raw_' ~ trend ~ ' t1' }}
{{ make_inner_join_sync_log(1) -}}
),

query2 as (
select
     store_id,
     log_id,
     item_index,
     max(value_at) value_at_max
from 
     query1
group by 
     store_id, log_id, item_index, value_at_year, value_at_month, value_at_day, value_at_hour, value_at_min
)

select
    t1.store_id,
    t1.log_id,
    t1.item_index,
    t2.value,
    TIMESTAMP_FROM_PARTS(
       Year(value_at_max), 
       Month(value_at_max), 
       DAY(value_at_max), 
       Hour(value_at_max), 
       MINUTE(value_at_max),
       0
    ) as value_at
from 
    query2 t1
left join query1 t2 on 
(
  t1.store_id = t2.store_id and
  t1.log_id = t2.log_id and 
  t1.item_index = t2.item_index and
  t1.value_at_max = t2.value_at
)
order by store_id, log_id, item_index, value_at
{% endset %}

{{ return(query) }}
{% endmacro %}