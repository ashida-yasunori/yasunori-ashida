-- depends_on: {{ ref('tbl_lake_co2_10min') }}
-- depends_on: {{ ref('tbl_lake_co2_30min') }}
-- depends_on: {{ ref('tbl_lake_co2_60min') }}
-- depends_on: {{ ref('tbl_lake_energy_ac_30min') }}
-- depends_on: {{ ref('tbl_lake_energy_ac_60min') }}
-- depends_on: {{ ref('tbl_lake_energy_pv_30min') }}
-- depends_on: {{ ref('tbl_lake_energy_pv_60min') }}
-- depends_on: {{ ref('tbl_lake_humi_10min') }}
-- depends_on: {{ ref('tbl_lake_humi_30min') }}
-- depends_on: {{ ref('tbl_lake_humi_60min') }}
-- depends_on: {{ ref('tbl_lake_lux_10min') }}
-- depends_on: {{ ref('tbl_lake_lux_30min') }}
-- depends_on: {{ ref('tbl_lake_lux_60min') }}
-- depends_on: {{ ref('tbl_lake_ocs_30min') }}
-- depends_on: {{ ref('tbl_lake_ocs_60min') }}
-- depends_on: {{ ref('tbl_lake_outside_10min') }}
-- depends_on: {{ ref('tbl_lake_outside_30min') }}
-- depends_on: {{ ref('tbl_lake_outside_60min') }}
-- depends_on: {{ ref('tbl_lake_pressure_outside_10min') }}
-- depends_on: {{ ref('tbl_lake_pressure_outside_30min') }}
-- depends_on: {{ ref('tbl_lake_pressure_outside_60min') }}
-- depends_on: {{ ref('tbl_lake_statuslog_1min') }}
-- depends_on: {{ ref('tbl_lake_switchlog_1min') }}
-- depends_on: {{ ref('tbl_lake_temp_10min') }}
-- depends_on: {{ ref('tbl_lake_temp_30min') }}
-- depends_on: {{ ref('tbl_lake_temp_60min') }}
-- depends_on: {{ ref('tbl_lake_trend_energy_ac_30min') }}
-- depends_on: {{ ref('tbl_lake_trend_energy_ac_60min') }}
-- depends_on: {{ ref('tbl_lake_trend_pressure_10min') }}
-- depends_on: {{ ref('tbl_lake_trend_pressure_30min') }}
-- depends_on: {{ ref('tbl_lake_trend_pressure_60min') }}

{%- set store_id = 57964 -%}
{%- set r = check_existence_of_table() -%}
{%- set del_query = make_delete_store_integrate_data_query(store_id) -%}
{%- set del_query2 = make_delete_synclog_query(store_id) -%}
{% if r == 0 %}
{{-
    config(
        database='db_mart',
        materialized='incremental',
        post_hook=['{{ make_delete_synclog_query(24679) }}' ]
    )
}}
{% else %}
{{-
    config(
        database='db_mart',
        materialized='incremental',
        pre_hook=['{{ del_query }}' ],
        post_hook=['{{ del_query2 }}' ]
    )
}}
{% endif %}
{{ make_store_data_integrate_query(store_id) }}