{{
  config(
    materialized = 'table'
    )
}}
with ticket_flights_purchased as 
(
	SELECT 
		flight_id,
		count(ticket_no) as cnt_ticket,
        sum(amount) as amount_ticket
	FROM {{ ref('fct_ticket_flights') }} ftf 
	group by flight_id
),
boarding_passes_issued as
(
    SELECT
        flight_id,
        count(ticket_no) as cnt_boarding_pass
    from {{ ref('stg_flights__boarding_passes') }}
    group by flight_id
),
count_seats as
(
    SELECT
        aircraft_code,
        count(seat_no) as seat_cnt
    from {{ ref('stg_flights__seats') }}
    group by aircraft_code
)

select
    ff.departure_airport_id as Departure_Airport_Code,
    sf_airports.airport_name as Departure_Airport_Name,
    sf_airports.city as Departure_Airport_City,
    sf_airports.coordinates as Departure_Airport_Coordinates,
    ff.arrival_airport_id as Arrival_Airport_Code,
    sf_airports_a.airport_name as Arrival_Airport_Name,
    sf_airports_a.city as Arrival_Airport_City,
    sf_airports_a.coordinates as Arrival_Airport_Coordinates,
    ff.status as Flight_status,
    ff.aircraft_id as Aircraft_code,
    sf_aircrafts.model as Aircraft_model,
    sf_seats.fare_conditions as Fare_conditions,
    ff.scheduled_departure::date as Scheduled_departure_date,
    ff.flight_no as Flight_no,
    ff.flight_id as Flight_id,
    case 
		when tfp.cnt_ticket is null then 0
		else tfp.cnt_ticket
	end as Ticket_flights_purchased,
    case 
		when bpi.cnt_boarding_pass is null then 0
		else bpi.cnt_boarding_pass
	end as Boarding_passes_issued,
    case 
		when tfp.amount_ticket is null then 0
		else tfp.amount_ticket
	end as Ticket_flights_amount,
    cs.seat_cnt -
        case 
            when tfp.cnt_ticket is null then 0
            else tfp.cnt_ticket
        end as Ticket_flights_no_sold
from
    {{ ref('fct_flights') }} ff
    left join {{ ref('stg_flights__airports') }} sf_airports on ff.departure_airport_id = sf_airports.airport_code
    left join {{ ref('stg_flights__airports') }} sf_airports_a on ff.arrival_airport_id = sf_airports_a.airport_code
    left join {{ ref('stg_flights__aircrafts') }} sf_aircrafts on ff.aircraft_id = sf_aircrafts.aircraft_code
    left join {{ ref('stg_flights__seats') }} sf_seats on ff.aircraft_id = sf_seats.aircraft_code
    left join ticket_flights_purchased tfp on ff.flight_id = tfp.flight_id
    left join boarding_passes_issued bpi on ff.flight_id = bpi.flight_id
    left join count_seats cs on ff.aircraft_id = cs.aircraft_code