{# tbl_mst_trend_group_pointからグループ名の一覧を取得するマクロ #}
{% macro get_trend_group_names(store_id) %}

{% set query %}
select distinct
    replace(lower(group_name), 'trend.')
from 
    db_common.public.tbl_mst_trend_group_point
where
    store_id = {{ store_id }}
order by 1
{% endset %}
{% set results = run_query(query) %}

{{ return(results) }}
{% endmacro %}