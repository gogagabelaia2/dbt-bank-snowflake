with transactions as(
        select
            transaction_date,
            amount
        from   {{ ref('stg_transactions') }}       
),

agg_transactions as(
    select
        date_trunc('month',transaction_date) as month,
        sum(amount) as total_volume
    from transactions
    group by 1
)
select * from agg_transactions

