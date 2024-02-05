{#- 1分単位トレンドログ（温度、湿度、照度など）の時間単位集約クエリの作成 -#}
{% macro make_aggregate_average_query(trend, time_unit) %}
{% set db_suffix = '_stg' if target.name == 'stg' else '' %}
{% set query %}
with query1 as (
select
    t1.store_id,
    t1.log_id,
    t1.item_index,
    t1.value,
    t1.value_at,
    DATEADD(minute, -1, t1.value_at) as value_at_past_1min
from 
    {{ source('raw' ~ db_suffix, 'tbl_raw_' ~ trend) }}
    --db_raw{{db_suffix}}.public.tbl_raw_{{trend}} t1
{{ make_inner_join_sync_log(time_unit) -}}
),

query2 as (
select
    store_id,
    log_id,
    item_index,
    value,
    value_at,
    year(value_at_past_1min) as value_at_year,
    month(value_at_past_1min) as value_at_month,
    day(value_at_past_1min) as value_at_day,
    hour(value_at_past_1min) as value_at_hour,
    minute(value_at_past_1min) as value_at_min
from 
    query1
)

select 
    store_id,
    log_id,
    item_index,
    round(avg(value)::NUMBER(15,5), {{ get_significant_digits(trend) }}, 'HALF_AWAY_FROM_ZERO') as value,
    TIMESTAMP_FROM_PARTS(
       value_at_year, 
       value_at_month, 
       value_at_day, 
       {% if time_unit in [10, 30] -%}
       value_at_hour, 
       (TRUNC(value_at_min / {{ time_unit }}, 0) + 1) * {{ time_unit }},
       {%- elif time_unit == 60 -%}
       value_at_hour + 1,
       0,
       {%- endif -%}
       0
    ) as value_at,
    to_timestamp(CURRENT_TIMESTAMP()) as last_updated_at
from
    query2
group by
    {% if time_unit in [10, 30] -%}
    store_id, log_id, item_index, value_at_year, value_at_month, value_at_day, value_at_hour, TRUNC(value_at_min / {{ time_unit }}, 0)
    {% elif time_unit == 60 -%}
    store_id, log_id, item_index, value_at_year, value_at_month, value_at_day, value_at_hour
    {%- endif %}
order by store_id, log_id, item_index, value_at
{% endset %}

{{ return(query) }}
{% endmacro %}