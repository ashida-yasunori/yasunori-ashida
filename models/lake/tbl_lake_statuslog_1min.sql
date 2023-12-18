{{-
    config(
        materialized='incremental',
        unique_key = ['store_id', 'log_id', 'item_index', 'value_at']
    )
-}}
{#- 状態用クエリを作成 -#}
{{- make_statuslog_switchlog_query('statuslog') -}}