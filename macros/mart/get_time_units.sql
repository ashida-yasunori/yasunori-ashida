{# トレンドグループ毎の集約時間単位を取得マクロ #}
{% macro get_time_units(trend) %}

{% if trend in ['temp', 'humi', 'lux', 'co2', 'outside', 'trend_pressure', 'pressure_outside'] %}
    {% set results = [1, 10, 30, 60] %}
{% elif trend in ['ocs', 'trend_energy_ac', 'energy_ac', 'energy_pv'] %}
    {% set results = [10, 30, 60] %}
{% elif trend in ['statuslog', 'switchlog'] %}
    {% set results = [1] %}
{% endif %}
{{ return(results) }}
{% endmacro %}