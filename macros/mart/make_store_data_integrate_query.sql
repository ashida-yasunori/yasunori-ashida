{# 店舗の全統合データ作成用クエリの作成マクロ #}
{% macro make_store_data_integrate_query(store_id) %}
{% set db_suffix = '_stg' if target.name == 'stg' else '' %}
{% set query %}

{%- set groups = get_trend_group_names(store_id) -%}
{%- set store_name = get_store_name(store_id) %}

with integration as (
{%- if groups | length != 0 -%}
    {%- for group in groups %}
        {% set time_units = get_time_units(group[0]) %}
        {%- for time in time_units %}
            (select t1.store_id, t1.log_id, t1.item_index, to_varchar(t1.value) as value, t1.value_at, {{ time }} as time 
            {%- set tbl_name = get_table_name(group[0], time) %}
            from {{ tbl_name }} t1
            inner join (select store_id, log_last_min_at, log_last_max_at
                        from db_common{{db_suffix}}.public.tbl_sync_log) t2 on (
                        ( t2.store_id = t1.store_id and (t2.log_last_min_at <= t1.value_at and t1.value_at <= t2.log_last_max_at)))
            where t1.store_id = {{ store_id }})
            {%- if not loop.last %}
            union 
            {%- endif %}
        {%- endfor %}
        {%- if not loop.last %}
            union 
        {%- endif -%}
    {%- endfor %}
{%- else -%}
    select to_timestamp('2024-01-01 0:00:00') as value_at
{%- endif -%}
)

select 
    value_at
    {%- set points = get_trend_points(store_id) -%}
    {%- if  points | length != 0 %}, {%- endif %}
    {%- for p in points %}
        {%- set time_units = get_time_units(p[0]) -%}
        {%- for time in time_units %}
    max(CASE WHEN log_id = {{p[1]}} and item_index = {{p[2]}} and time = {{time}} THEN {{cast_type}}value ELSE NULL END) AS "{{p[3]}}_{{time}}min_{{store_name}}"
            {%- if not loop.last %}, 
            {%- endif %}
        {%- endfor %}
        {%- if not loop.last %},
        {%- endif -%}
    {%- endfor %}
FROM integration
GROUP BY value_at
ORDER BY value_at
{% endset %}

{{ return(query) }}
{% endmacro %}