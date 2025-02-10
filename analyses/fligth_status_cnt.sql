{% set status_query %}
SELECT DISTINCT
    status
FROM
    {{ ref('stg_flights__flights') }}
{% endset %}

{% set status_query_result = run_query(status_query)%}
{% if execute %}
    {% set all_statuses = status_query_result.columns[0].values() %}
{% else %}
    {% set all_statuses = [] %}
{% endif %}

SELECT
    {% for status_name in all_statuses %}
    SUM(CASE WHEN status = '{{ status_name }}' THEN 1 ELSE 0 END) as status_{{status_name.replace(" ","_")}}
        {%- if not loop.last %},{% endif %}
    {%- endfor %}
FROM
    {{ ref('stg_flights__flights') }}