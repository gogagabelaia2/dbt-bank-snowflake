with branches as(
    select 
        branch_id,
        branch_name
    from {{ref('stg_branches')}}
),
loans as(
    select 
        loan_id,
        account_id,
        outstanding_balance,
        days_past_due
    from {{ref('stg_loans')}}
),
accounts as(
    select 
        account_id,
        branch_id
    from {{ref('stg_accounts')}}
),
deposits as(
    select 
        deposit_id,
        account_id,
        principal_amount
    from {{ref('stg_deposits')}}
),
loans_agg as (
    select
        a.branch_id,
        count(l.loan_id)                                        as total_loans,
        sum(l.outstanding_balance)                              as total_portfolio,
        count(case when l.days_past_due > 90 then 1 end)       as npl_count,
        sum(case when l.days_past_due > 90 
            then l.outstanding_balance else 0 end)             as npl_balance
    from loans l
    join accounts a on l.account_id = a.account_id
    group by a.branch_id
),
deposits_agg as (
    select
        a.branch_id,
        sum(d.principal_amount) as total_deposits
    from deposits d
    join accounts a on d.account_id = a.account_id
    group by a.branch_id
),
final as(
    select 
        b.branch_id,
        b.branch_name,
        l.total_loans,
        l.total_portfolio,
        l.npl_count,
        l.npl_balance,
        d.total_deposits,
        round(l.npl_balance * 100.0 / nullif(l.total_portfolio, 0), 2) as npl_ratio,
        coalesce(d.total_deposits, 0) - l.total_portfolio               as net_position
    from loans_agg l
    left join deposits_agg d on l.branch_id=d.branch_id
    left join branches b on l.branch_id = b.branch_id
)
select * from final