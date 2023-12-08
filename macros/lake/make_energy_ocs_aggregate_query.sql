{#- 10分単位積算値トレンドログ（電力、ドア開閉）の時間集約クエリの作成 -#}
{% macro make_energy_ocs_aggregate_query(trend, time_unit) %}

{% set query %}
with query1 as (
 select
     t1.store_id,
     t1.log_id,
     t1.item_index,
     t1.value,
     t1.value_at,
     DATEADD(minute, -10, t1.value_at) as value_at_past_10min
 from 
     {{ ref('tbl_lake_' ~ trend ~ '_10min') }} t1
{{ make_inner_join_sync_log(time_unit) -}}
),

query2 as (
 select
     t1.store_id,
     t1.log_id,
     t1.item_index,
     t1.value,
     t1.value_at,
     year(t1.value_at_past_10min) as value_at_year,
     month(t1.value_at_past_10min) as value_at_month,
     day(t1.value_at_past_10min) as value_at_day,
     hour(t1.value_at_past_10min) as value_at_hour,
     minute(t1.value_at_past_10min) as value_at_min
 from 
     query1 t1
)

select 
    store_id,
    log_id,
    item_index,
    sum(value) as value,
    max(value_at) as value_at
from
    query2
group by
    {% if time_unit == 30 -%}
    store_id, log_id, item_index,value_at_year, value_at_month, value_at_day, value_at_hour, TRUNC(value_at_min / {{ time_unit }}, 0)
    {% elif time_unit == 60 -%}
    store_id, log_id, item_index, value_at_year, value_at_month, value_at_day, value_at_hour
    {%- endif %}
order by store_id, log_id, item_index, value_at

{% endset %}

{{ return(query) }}
{% endmacro %}