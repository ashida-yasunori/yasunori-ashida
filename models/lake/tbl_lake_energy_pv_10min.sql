{{-
    config(
        materialized='incremental',
        unique_key = ['store_id', 'log_id', 'item_index', 'value_at']
    )
-}}
{#- 電力の積算値差分計算用クエリを作成 -#}
{{- make_energy_ocs_query('energy_pv', 10) -}}