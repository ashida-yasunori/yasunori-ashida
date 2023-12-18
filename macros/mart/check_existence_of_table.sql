{# 現在実行中モデル名のテーブルの存在確認マクロ #}
{% macro check_existence_of_table() %}

{% set query %}
select
    count(table_name) as cnt
from 
    db_mart.information_schema.tables
where
    table_schema = 'PUBLIC' and
    lower(table_name) like '{{ model.name }}'
{% endset %}
{{ log('モデル名=' ~ model.name, info=True) }}

{% set results = run_query(query) %}
{%- if execute -%}
    {% set r = results.columns[0].values() %}
    {% if r | length == 0 %}
        {% do print('Query `' ~ query ~ '` returned no rows. Using the default value: ' ~ default) %}
        {% set sql_result = 0 %}
    {% else %}
        {% set sql_result = r[0] %}
    {% endif %}
{%- else -%}
    {% set sql_result = '' %}
{%- endif -%}
{% do return(sql_result) %}

{% endmacro %}