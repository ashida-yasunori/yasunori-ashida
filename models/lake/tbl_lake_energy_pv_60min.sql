{{-
    config(
        materialized='incremental',
        unique_key = ['store_id', 'log_id', 'item_index', 'value_at']
    )
-}}
{#- 電力の時間集約用クエリを作成 -#}
{{- make_energy_ocs_aggregate_query('energy_pv', 60) -}}