{{-
    config(
        materialized='incremental',
        unique_key = ['store_id', 'log_id', 'item_index', 'value_at']
    )
-}}
{#- ドア開閉回数・開時間の積算値差分計算用クエリを作成 -#}
{{- make_energy_ocs_query('ocs', 10) -}}