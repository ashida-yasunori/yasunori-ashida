{% macro get_table_name(trend, time_unit) %}
{% set db_suffix = '_stg' if target.name == 'stg' else '' %}

{% if trend in ['temp', 'humi', 'lux', 'co2', 'outside', 'trend_pressure', 'pressure_outside'] %}
    {% if time_unit == 1 %}
        {% set result = 'db_raw' ~ db_suffix ~ '.public.tbl_raw_' ~ trend %}
    {% elif time_unit == 10 or time_unit == 30 or time_unit == 60 %}
        {% set result = 'db_lake' ~ db_suffix ~ '.public.tbl_lake_' ~ trend ~ '_' ~ time_unit ~ 'min' %}
    {% endif %}
{% elif trend in ['ocs', 'trend_energy_ac', 'energy_ac', 'statuslog', 'switchlog'] %}
    {% if time_unit == 10 %}
        {% set result = 'db_lake' ~ db_suffix ~ '.public.tbl_lake_' ~ trend %}
    {% else %}
        {% set result = 'db_lake' ~ db_suffix ~ '.public.tbl_lake_' ~ trend ~'_' ~ time_unit ~ 'min' %}
    {% endif %}
{% elif trend == 'energy_pv' %}
    {% if time_unit == 1 %}
        {% set result = 'db_raw' ~ db_suffix ~ '.public.tbl_raw_' ~ trend %}
    {% else %}
        {% set result = 'db_lake' ~ db_suffix ~ '.public.tbl_lake_' ~ trend ~ '_' ~ time_unit ~ 'min' %}
    {% endif %}
{% endif%}
{{ return(result) }}
{% endmacro %}