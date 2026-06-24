with transactions as(
    select 
        transaction_id,
        account_id,
        transaction_category,
        amount
from {{ ref('stg_transactions') }}
)
select 
    transaction_id,
    account_id,
    transaction_category,
    amount,
    percent_rank()over(partition by transaction_category order by amount) as percentile_rank
from transactions