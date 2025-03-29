{{
  config(
    materialized = 'table'
    )
}}
select
    flight_id,
    flight_no,
    scheduled_departure,
    scheduled_arrival,
    departure_airport as departure_airport_id,
    arrival_airport as arrival_airport_id,
    status,
    aircraft_code as aircraft_id,
    actual_departure,
    actual_arrival,
    current_date as load_date,
    {{ concat_columns(['flight_id', 'flight_no']) -}} as flight_info
from
    {{ ref('stg_flights__flights') }}


{% for status_value in dbt_utils.get_column_values(table = this, column ='status') %}
    --{{ status_value }}
{% endfor %}


