with transactions as(
    select 
        transaction_id,
        account_id,
        transaction_date
    from {{ref('stg_transactions')}}
),
accounts as(
    select
        account_id,
        opened_date
    from {{ref('stg_accounts')}}
),
joins as(
    select
        t.transaction_id,
        t.transaction_date,
        ac.account_id,
        ac.opened_date 
    from transactions t 
    left join accounts ac on t.account_id=ac.account_id
),
final as(
    select 
        transaction_id,
        account_id,
        datediff('day',opened_date,transaction_date) as days_since_activation
    from joins
)
select * from final