with transactions as(
    select 
        transaction_id,
        customer_id,
        amount
    from {{ ref('stg_transactions') }}
),
agg_transactions as(
    select 
        customer_id,
        count(transaction_id) as count_transactions,
        sum(amount) as total_transaction_value
    from transactions
    group by 1
),
final as(
    select 
        customer_id,
        count_transactions,
        total_transaction_value,
        ntile(10)over(order by total_transaction_value desc ) as clv_decile
    from agg_transactions
)
select * from final