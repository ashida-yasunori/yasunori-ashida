{#- トレンドログ毎平均計算時有効少数桁数の取得 -#}
{% macro get_significant_digits(trend) %}

{% if trend == 'temp' %}
    {% set result = 2 %}
{% elif trend == 'humi' %}
    {% set result = 2 %}
{% elif trend == 'lux' %}
    {% set result = 1 %}
{% elif trend == 'co2' %}
    {% set result = 1 %}
{% elif trend == 'outside' %}
    {% set result = 1 %}
{% elif trend == 'trend_pressure' %}
    {% set result = 1 %}
{% elif trend == 'pressure_outside' %}
    {% set result = 1 %}
{% else %}
    {% set result = 1 %}
{% endif %}

{{ return(result) }}
{% endmacro %}