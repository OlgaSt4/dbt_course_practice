select distinct
    timezone
from
    {{ ref('stg_flights__airports') }}