{# process_kbn <> 0 以外の店舗の同期ログ削除用クエリ作成マクロ #}
{% macro make_delete_synclog_query(store_id) %}
{% set db_suffix = '_stg' if target.name == 'stg' else '' %}
{% set query %}
delete from {{ source('common' ~ db_suffix, 'tbl_sync_log') }}
-- db_common{{db_suffix}}.public.tbl_sync_log 
where store_id = {{ store_id }} and process_kbn <> 0
{% endset %}
{{ return(query) }}
{% endmacro %}