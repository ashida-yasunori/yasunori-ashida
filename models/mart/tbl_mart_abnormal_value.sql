{# RAWテーブル異常値データ取得用クエリの作成 #}
{%- set db_name = 'db_mart_stg' if target.name == 'stg' else 'db_mart' -%}
{{-
    config(
        database=db_name,
        materialized="incremental",
        unique_key = ['store_id', 'log_id', 'item_index', 'value_at']
    )
-}}

{#- CO2のクエリを作成 -#}
{{- make_abnormal_value_get_query() -}}