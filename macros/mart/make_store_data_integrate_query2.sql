{# 店舗の全統合データ作成用クエリの作成マクロ #}
{% macro make_store_data_integrate_query2(store_id) %}
{% set db_suffix = '_stg' if target.name == 'stg' else '' %}
{% set query %}

{%- set groups = get_trend_group_names(store_id) -%}
{%- set store_name = get_store_name(store_id) %}

with integration as (
{%- if groups | length != 0 -%}
    {%- for group in groups -%}
        {% set time_units = get_time_units(group[0]) %}
        {%- for time in time_units %}
            (select t1.value, t1.value_at, t4.point || '_{{ time }}min_' || t3.store_name as colname
            {%- set tbl_name = get_table_name(group[0], time) %}
            from {{ source(tbl_name[0] ~ db_suffix, tbl_name[1]) }} t1
            inner join (select store_id, log_last_min_at, log_last_max_at
                        from {{ source('common' ~ db_suffix, 'tbl_sync_log') }}) t2 on (
                        ( t2.store_id = t1.store_id and (t2.log_last_min_at <= t1.value_at and t1.value_at <= t2.log_last_max_at)))
            inner join {{ source('common' ~ db_suffix, 'tbl_mst_store') }} t3 on (
                t1.store_id = t3.store_id
            )
            inner join {{ source('common' ~ db_suffix, 'tbl_mst_trend_group_point') }} t4 on (
                t1.store_id = t4.store_id and
                t1.log_id = t4.log_id and
                t1.item_index = t4.item_index
            )
            where t1.store_id = '{{ store_id }}')
            {%- if not loop.last %}
            union 
            {%- endif -%}
        {%- endfor %}
        {%- if not loop.last %}
            union 
        {%- endif -%}
    {%- endfor %}
{%- else -%}
    select to_timestamp('2024-01-01 0:00:00') as value_at
{%- endif -%}
)

select * FROM integration
    PIVOT(sum(value) FOR colname IN (
    {%- set points = get_trend_points(store_id) -%}
    {%- for p in points %}
        {%- if p[0] in ['statuslog', 'switchlog'] -%}
            {% set cast_type = 'to_number(' %}
        {%- else -%}
            {% set cast_type = 'to_double(' %}
        {%- endif -%}
        {%- set time_units = get_time_units(p[0]) -%}
        {%- for time in time_units %}
        '{{p[3]}}_{{time}}min_{{store_name}}'
            {%- if not loop.last %}, 
            {%- endif %}
        {%- endfor %}
        {%- if not loop.last %},{%- endif -%}
    {%- endfor %}
    )) as p
ORDER BY value_at
{% endset %}

{{ return(query) }}
{% endmacro %}