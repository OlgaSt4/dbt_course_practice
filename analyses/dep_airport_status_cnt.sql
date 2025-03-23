select
    departure_airport_id,
    {{ dbt_utils.pivot(
      'status',
      dbt_utils.get_column_values(ref('fct_flights'), 'status'),
      quote_identifiers=False
  ) }}
from 
    {{ ref('fct_flights') }}
group by departure_airport_id

{# при quote_identifiers=False и alias=True (по умолчанию) для названия столбцов используется выражение:
"as {{ dbt_utils.slugify(prefix ~ value ~ suffix) }}" #}






