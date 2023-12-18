{#- 10分単位積算値トレンドログ（電力、ドア開閉）の差分計算クエリの作成 -#}
{% macro make_energy_ocs_query(trend, time_unit) %}

{% set query %}
with query1 as (
select
     t1.store_id,
     t1.log_id,
     t1.item_index,
     t1.value,
     t1.value_at
from 
     {{ 'db_raw.public.tbl_raw_' ~ trend ~ ' t1' }}
{{ make_inner_join_sync_log(time_unit) -}}
where
     t1.value_at <> (select min(value_at) from {{ 'db_raw.public.tbl_raw_' ~ trend }})
),

query2 as (

select
     t1.store_id,
     t1.log_id,
     t1.item_index,
     (t1.value - ifnull(t2.value, t1.value)) as value,
     t1.value_at
from 
     query1 t1
left join {{ 'db_raw.public.tbl_raw_' ~ trend }} t2 on (
     t2.store_id = t1.store_id and 
     t2.log_id = t1.log_id and 
     t2.item_index = t1.item_index and
     t2.value_at = (select max(value_at) 
                    from {{ 'db_raw.public.tbl_raw_' ~ trend }}
                    where store_id = t1.store_id and 
                          log_id = t1.log_id and
                          item_index = t1.item_index and 
                          value_at < t1.value_at
                   )
     )
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