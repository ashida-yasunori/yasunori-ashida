{% macro snowflake__alter_relation_add_remove_columns(relation, add_columns, remove_columns) %}

  {% if add_columns is none %}
    {% set add_columns = [] %}
  {% endif %}
  {% if remove_columns is none %}
    {% set remove_columns = [] %}
  {% endif %}

  {% set sql -%}

     alter {{ relation.type }} {{ relation }}
            {%- if add_columns | length != 0 %}add column {% endif %}
            {% for column in add_columns %}
               "{{ column.name }}" {{ column.data_type }}{{ ',' if not loop.last }}
            {% endfor -%}{{ ',' if add_columns and remove_columns }}

            {%- if remove_columns | length != 0 %}
                drop column 
            {% endif %}
            {% for column in remove_columns %}
                "{{ column.name }}"{{ ',' if not loop.last }}
            {% endfor -%}
  {%- endset -%}

  {% do run_query(sql) %}

{% endmacro %}