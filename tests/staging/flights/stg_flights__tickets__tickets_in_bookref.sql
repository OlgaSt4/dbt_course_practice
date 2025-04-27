{{
    config(
        severity = 'error',
        error_if = '>100',
        warn_if = '>=50'
    )
}}
SELECT
    book_ref,
    count(ticket_no) as ticket_cnt
FROM 
    {{ ref('stg_flights__tickets') }}
GROUP BY 
    book_ref
HAVING 
    count(ticket_no) >= 5