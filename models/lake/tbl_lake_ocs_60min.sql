-- depends_on: {{ ref('tbl_lake_ocs_10min') }}
{{-
    config(
        materialized='incremental',
        unique_key = ['store_id', 'log_id', 'item_index', 'value_at']
    )
-}}
{#- ドア開閉回数・開時間の時間集約用クエリを作成 -#}
{{- make_energy_ocs_aggregate_query('ocs', 60) -}}