{% set current_date = '{{ run_started_at|string|truncate(10, True, "") }}' %}
SELECT 
    SUM(CASE WHEN date(ff.scheduled_departure) between (date(current_date)
            - interval '10 years') AND date(current_date)  THEN 1 ELSE 0 END) as cnt_scheduled_dep
FROM
    {{ ref('fct_flights') }} ff

