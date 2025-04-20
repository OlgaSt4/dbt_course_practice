{{
  config(
    materialized = 'view',
    )
}}
select
    flight_no as "Номер полета",
    tickets as "Количество купленных билетов"
from
    {{ ref('tickets_per_flights') }}