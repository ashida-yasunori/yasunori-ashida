{#- 10分単位積算値トレンドログ（電力、ドア開閉）の差分計算クエリの作成 -#}
{% macro make_diff_query(trend, time_unit) %}
{% set db_suffix = '_stg' if target.name == 'stg' else '' %}
{% set query %}
with query1 as (
select
     t1.store_id,
     t1.log_id,
     t1.item_index,
     t1.value - LAG(t1.value, 1, t1.value) OVER (PARTITION BY t1.store_id, t1.log_id, t1.item_index ORDER BY t1.value_at) AS value,
     t1.value_at
from 
     db_raw{{db_suffix}}.public.tbl_raw_{{trend}} t1
{{ make_inner_join_sync_log(time_unit, -120) -}}
),

query2 as (
select 
     t1.store_id,
     t1.log_id,
     t1.item_index,
     t1.value,
     t1.value_at
from
    query1 t1
{{ make_inner_join_sync_log(time_unit) -}}
where
     t1.value_at != (select min(value_at) 
                     from db_raw{{db_suffix}}.public.tbl_raw_{{trend}}
                     where store_id = t1.store_id and
                           log_id = t1.log_id and 
                           item_index = t1.item_index)
)

select 
  store_id,
  log_id,
  item_index,
  value,
  to_timestamp(value_at) as value_at,
  to_timestamp(CURRENT_TIMESTAMP()) as last_updated_at
from 
  query2
order by 
  store_id, log_id, item_index, value_at

{% endset %}
{{ return(query) }}
{% endmacro %}