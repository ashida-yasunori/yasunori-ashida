{{-
    config(
        materialized='incremental',
        unique_key = ['store_id', 'log_id', 'item_index', 'value_at']
    )
-}}
{#- 外気圧の時間集約用クエリを作成 -#}
{{- make_trendlog_aggregate_query('pressure_outside', 30) -}}