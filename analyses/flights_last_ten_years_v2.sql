{% set current_date = run_started_at|string|truncate(10, True, "") %}
SELECT 
    SUM(CASE WHEN date(ff.scheduled_departure) between (date('{{current_date}}') - interval '10 years')
     AND date('{{current_date}}')  THEN 1 ELSE 0 END) as cnt_scheduled_dep
FROM
    {{ ref('fct_flights') }} ff




{%- set source_relation = api.Relation.create(
    database = "dwh_flight",
    schema = "intermediate",
    identifier = "fct_bookings",
    type = "table"
) %}

{% set columns = adapter.get_columns_in_relation(source_relation)%}

{% for column in columns%}
    {{ 'Columns: ' ~column -}}
{% endfor %}

--получение колонок stg_flights__flights
{%- set source_relation2 = load_relation( ref("stg_flights__flights") ) %}
{% set columns2 = adapter.get_columns_in_relation(source_relation2)%}
{% for column in columns2%}
    {{ 'Columns: ' ~column -}}
{% endfor %}

--получение колонок stg_flights__flights v2
{%- set source_relation_flights = load_relation( ref("stg_flights__flights") ) %}
{% for column in adapter.get_columns_in_relation(source_relation_flights)%}
    {{ 'Columns: ' ~column -}}
{% endfor %}