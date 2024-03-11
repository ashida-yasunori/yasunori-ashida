-- depends_on: {{ ref('tbl_lake_co2_10min') }}
-- depends_on: {{ ref('tbl_lake_co2_30min') }}
-- depends_on: {{ ref('tbl_lake_co2_60min') }}
-- depends_on: {{ ref('tbl_lake_energy_ac_30min') }}
-- depends_on: {{ ref('tbl_lake_energy_ac_60min') }}
-- depends_on: {{ ref('tbl_lake_energy_pv_10min') }}
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
{%- set db_name = 'db_mart_stg' if target.name == 'stg' else 'db_mart' -%}
{%- set store_id = '970000' -%}
{{-
    config(
        database=db_name,
        materialized='incremental',
        pre_hook=['{{ make_delete_store_integrate_data_query("970000") }}' ],
        post_hook=['{{ make_delete_synclog_query("970000") }}' ]
    )
}}

{{ make_store_data_integrate_query(store_id) }}