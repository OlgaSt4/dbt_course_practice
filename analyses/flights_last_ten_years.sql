{% set current_date = '{{ run_started_at|string|truncate(10, True, "") }}' %}
SELECT 
    count(*)
FROM
    {{ ref('fct_flights') }} ff
WHERE 
    date(ff.scheduled_departure) 
    between 
        (
            date(current_date)
            - interval '10 years'
        ) 
    and 
        (
            date(current_date)
        )
