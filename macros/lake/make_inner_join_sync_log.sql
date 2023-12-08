{#- tbl_sync_logテーブルの内容で時間を絞るinner join句を作成する -#}
{% macro make_inner_join_sync_log(time_unit) %}
{% set join_query -%}
inner join db_common.public.tbl_sync_log t2 on (
    t2.store_id = t1.store_id and 
    t2.log_id = t1.log_id and 
    (t2.log_last_min_at <= t1.value_at and t1.value_at <= t2.log_last_max_at) and 
    case when t2.process_kbn = 0 then t2.item_index is null
         when t2.process_kbn = 1 and t2.item_index is not null then t2.item_index = t1.item_index 
         when t2.process_kbn = 1 and t2.item_index is null then t2.item_index is null 
         when t2.process_kbn = 2 then t2.aggregation_time_unit = {{ time_unit }} end
    )  
{% endset -%}
{{ return(join_query) }}
{% endmacro %}