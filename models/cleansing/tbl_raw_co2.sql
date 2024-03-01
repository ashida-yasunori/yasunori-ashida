{%- set db_name = 'db_raw_stg' if target.name == 'stg' else 'db_raw' -%}
{{-
    config(
        database=db_name,
        materialized="incremental",
        unique_key = ['store_id', 'log_id', 'item_index', 'value_at'],
        merge_update_columns = ['value']
    )
-}}

{#- CO2のクエリを作成 -#}
{{- make_abnormal_value_update_query('co2') -}}