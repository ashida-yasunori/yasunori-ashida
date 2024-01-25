{# process_kbn <> 0 以外の日時帯の店舗別統合データ削除用クエリ作成マクロ #}
{% macro make_delete_store_integrate_data_query(store_id) %}
{% set db_suffix = '_stg' if target.name == 'stg' else '' %}
{% set r = check_existence_of_table() %}

{% set query %}
{% if r != 0 %}
delete from db_mart{{db_suffix}}.public.{{model.name}} t1 
using (
    select distinct 
        log_last_min_at,
        log_last_max_at
    from 
        db_common{{db_suffix}}.public.tbl_sync_log
    where 
        store_id = {{ store_id }}
    ) as t2 
where 
    t2.log_last_min_at <= t1.value_at and t1.value_at <= t2.log_last_max_at
{% else %}
select 0 as col1
{% endif %}
{% endset %}
{{ return(query) }}
{% endmacro %}