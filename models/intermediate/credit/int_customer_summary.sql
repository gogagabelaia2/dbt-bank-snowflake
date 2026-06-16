with customers as(
    select
        customer_id,
        first_name ||' '|| last_name as full_name
    from {{ref('stg_customers')}}
),
loans as(
    select
        loan_id,
        customer_id,
        outstanding_balance,
        original_amount,
        days_past_due
    from {{ref('stg_loans')}}
),
deposits as(
    select
        deposit_id,
        customer_id,
        principal_amount
    from {{ref('stg_deposits')}}
),
loans_agg as (
    select
        customer_id,
        count(loan_id)                    as total_loans,
        sum(outstanding_balance)          as total_outstanding,
        max(case when days_past_due > 90 
            then 1 else 0 end)            as has_npl,
        sum(case when days_past_due > 90 
            then outstanding_balance 
            else 0 end)                   as npl_balance
    from loans
    group by customer_id
),
deposits_agg as (
    select
        customer_id,
        sum(principal_amount) as total_deposits
    from deposits
    group by customer_id
),
   
final as(
    select 
        c.customer_id,
        c.full_name,
        coalesce(l.total_loans, 0)       as total_loans,
        coalesce(l.total_outstanding, 0) as total_outstanding,
        coalesce(l.has_npl, 0)           as has_npl,
        coalesce(l.npl_balance, 0)       as npl_balance,
        coalesce(d.total_deposits, 0)    as total_deposits,
        coalesce(l.total_outstanding, 0) 
            - coalesce(d.total_deposits, 0) as net_exposure
    from customers c
    left join loans_agg l    on c.customer_id = l.customer_id
    left join deposits_agg d on c.customer_id = d.customer_id

)select * from final