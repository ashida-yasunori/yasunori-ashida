{% set db_name = get_lake_db_name() %}
{{-
    config(
        database=db_name,
        materialized='incremental',
        unique_key = ['store_id', 'log_id', 'item_index', 'value_at']
    )
-}}
{#- 電力の時間集約用クエリを作成 -#}
{{- make_aggregate_max_query('energy_pv', 10) -}}