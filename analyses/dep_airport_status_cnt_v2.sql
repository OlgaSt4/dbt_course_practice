{% set status_values = dbt_utils.get_column_values(
    table=ref('fct_flights'),
    column='status'
) %}

SELECT 
    departure_airport_id,
    {% for val in status_values %}
        SUM(CASE WHEN status = '{{ val }}' THEN 1 ELSE 0 END) as {{ dbt_utils.slugify(val)}}
        {%- if not loop['last'] %},{% endif %}
    {% endfor %}
FROM
    {{ ref('fct_flights') }}
GROUP BY departure_airport_id


 