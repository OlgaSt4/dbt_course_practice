with ticket_flights_purchased as 
(
	SELECT 
		flight_id,
		count(ticket_no) as cnt_ticket
	FROM {{ ref('fct_ticket_flights') }} ftf 
	group by flight_id
)
SELECT 
	ff.flight_id, 
	ff.aircraft_id,
	case 
		when tfp.cnt_ticket is null then 0
		else tfp.cnt_ticket
	end as cnt_ticket,
	count(sfs.seat_no) as cnt_seats
FROM {{ ref('fct_flights') }} ff
	left join {{ ref('stg_flights__seats') }} sfs on ff.aircraft_id =sfs.aircraft_code 
	left join ticket_flights_purchased tfp on tfp.flight_id = ff.flight_id
group by 
	ff.flight_id, 
	ff.aircraft_id,
	tfp.cnt_ticket
