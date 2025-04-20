select
    f.flight_no,
    count(ft.flight_id) as tickets
from
    {{ ref('fct_flights') }} f 
    left join {{ ref('fct_ticket_flights') }} ft
        on ft.flight_id = f.flight_id
    left join {{ ref('fct_tickets') }} t 
        on t.ticket_no = ft.ticket_no
group by f.flight_no