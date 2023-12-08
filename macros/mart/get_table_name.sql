{% macro get_table_name(trend, time_unit) %}

{% if trend in ['temp', 'humi', 'lux', 'co2', 'outside', 'trend_pressure', 'pressure_outside'] %}
    {% if time_unit == 1 %}
        {% set result = 'db_raw.public.tbl_raw_' ~ trend %}
    {% elif time_unit == 10 or time_unit == 30 or time_unit == 60 %}
        {% set result = 'db_lake.public.tbl_lake_' ~ trend ~ '_' ~ time_unit ~ 'min' %}
    {% endif %}
{% elif trend in ['ocs', 'trend_energy_ac', 'energy_ac', 'energy_pv', 'statuslog', 'switchlog'] %}
    {% set result = 'db_lake.public.tbl_lake_' ~ trend ~'_' ~ time_unit ~ 'min' %}
{% endif%}
{{ return(result) }}
{% endmacro %}