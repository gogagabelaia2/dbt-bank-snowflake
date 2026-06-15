{{ config(severity='warn') }}

select loan_id
from {{ ref('stg_loans') }}
where days_past_due > 90
  and outstanding_balance <= 0