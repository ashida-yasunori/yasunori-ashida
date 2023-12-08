-- depends_on: {{ ref('tbl_lake_energy_ac_10min') }}
{{-
    config(
        materialized='incremental',
        unique_key = ['store_id', 'log_id', 'item_index', 'value_at']
    )
-}}
{#- 受電電力量の時間集約用クエリを作成 -#}
{{- make_energy_ocs_aggregate_query('energy_ac', 60) -}}