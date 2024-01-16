-- depends_on: {{ ref('tbl_lake_ocs') }}
{% set db_name = 'db_lake_stg' if target.name == 'stg' else 'db_lake' %}
{{-
    config(
        database=db_name,
        materialized='incremental',
        unique_key = ['store_id', 'log_id', 'item_index', 'value_at']
    )
-}}
{#- ドア開閉回数・開時間の時間集約用クエリを作成 -#}
{{- make_aggregate_sum_query('ocs', 30) -}}