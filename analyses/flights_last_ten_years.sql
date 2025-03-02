{% set current_date = run_started_at|string|truncate(10, True, "") %}
SELECT 
    count(*) as {{ adapter.quote('cnt')}}
FROM
    {{ ref('fct_flights') }} ff
WHERE 
    date(ff.scheduled_departure) 
    between (date('{{current_date}}') - interval '10 years') 
    and (date('{{current_date}}'))


{% set fct_flights = api.Relation.create(
        database = 'dwh_flight',
        schema = 'intermediate',
        identifier = 'fct_flights',
        type = 'table'
    )
%}

{% set stg_flights__flights = api.Relation.create(
        database = 'dwh_flight',
        schema = 'intermediate',
        identifier = 'stg_flights__flights',
        type = 'table'
    )
%}

{% do adapter.expand_target_column_types(stg_flights__flights, fct_flights)%}

{% for column in adapter.get_columns_in_relation(stg_flights__flights)%}
    {{'Column:' ~column }}
{%- endfor %}

{% for column in adapter.get_columns_in_relation(fct_flights)%}
    {{'Column:' ~column }}
{%- endfor %}