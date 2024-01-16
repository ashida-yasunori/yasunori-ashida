-- depends_on: {{ ref('tbl_lake_trend_energy_ac') }}
{% set db_name = 'db_lake_stg' if target.name == 'stg' else 'db_lake' %}
{{-
    config(
        database=db_name,
        materialized='incremental',
        unique_key = ['store_id', 'log_id', 'item_index', 'value_at']
    )
-}}
{#- 電力量の時間集約用クエリを作成 -#}
{{- make_aggregate_sum_query('trend_energy_ac', 30) -}}