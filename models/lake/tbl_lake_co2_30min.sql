-- depends_on: {{ ref('tbl_raw_co2') }}
{% set db_name = 'db_lake_stg' if target.name == 'stg' else 'db_lake' %}
{{-
    config(
        database=db_name,
        materialized='incremental',
        unique_key = ['store_id', 'log_id', 'item_index', 'value_at']
    )
-}}
{#- CO2の時間集約用クエリを作成 -#}
{{- make_aggregate_average_query('co2', 30) -}}