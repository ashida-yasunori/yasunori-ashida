{# process_kbn <> 0 以外の日時帯の店舗別統合データ削除用クエリ作成マクロ #}
{% macro make_delete_store_integrate_data_query(store_id) %}
{% set query %}
delete from db_mart.public.{{model.name}} t1 
using (
    select 
        min(log_last_min_at) as log_last_min_at,
        max(log_last_max_at) as log_last_max_at
    from 
        db_common.public.tbl_sync_log
    where 
        store_id = {{ store_id }} and 
        process_kbn <> 0
    group by
        process_kbn, store_id
    ) as t2 
where 
    t2.log_last_min_at <= t1.value_at and t1.value_at <= t2.log_last_max_at
{% endset %}

{{ return(query) }}
{% endmacro %}