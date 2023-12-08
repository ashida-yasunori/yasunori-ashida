{{-
    config(
        materialized='incremental',
        unique_key = ['store_id', 'log_id', 'item_index', 'value_at']
    )
-}}
{#- 外気の時間集約用クエリを作成 -#}
{{- make_trendlog_aggregate_query('outside', 10) -}}