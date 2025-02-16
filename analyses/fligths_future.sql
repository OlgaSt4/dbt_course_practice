select
    date(scheduled_departure) as date,
    count(*)
from
    {{ ref('fct_flights') }}
WHERE
    date(scheduled_departure) >= date('{{ run_started_at|string|truncate(10, True, "") }}')
GROUP BY
    date(scheduled_departure)