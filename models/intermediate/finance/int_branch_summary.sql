with branches as(
    select 
        branch_id,
        branch_name
    from {{ ref('stg_branches') }}
),
loans as(
    select 
        loan_id,
        account_id,
        outstanding_balance,
        days_past_due
    from {{ ref('stg_loans') }}
),
accounts as(
    select 
        account_id,
        branch_id
    from {{ ref('stg_accounts') }}
),
deposits as(
    select 
        deposit_id,
        account_id,
        principal_amount
    from {{ ref('stg_deposits') }}
),
loans_agg as (
    select
        a.branch_id,
        count(l.loan_id)                                        as total_loans,
        sum(l.outstanding_balance)                              as total_portfolio,
        count(case when l.days_past_due > 90 then 1 end)       as npl_count,
        sum(case when l.days_past_due > 90 
            then l.outstanding_balance else 0 end)             as npl_balance
    from loans as l
    inner join accounts as a on l.account_id = a.account_id
    group by a.branch_id
),
deposits_agg as (
    select
        a.branch_id,
        sum(d.principal_amount) as total_deposits
    from deposits as d
    inner join accounts as a on d.account_id = a.account_id
    group by a.branch_id
),
final as(
    select 
        b.branch_id,
        b.branch_name,
        coalesce(l.total_loans, 0)    as total_loans,
        coalesce(l.total_portfolio, 0) as total_portfolio,
        coalesce(l.npl_count, 0)      as npl_count,
        coalesce(l.npl_balance, 0)    as npl_balance,
        coalesce(d.total_deposits, 0) as total_deposits,
        round(coalesce(l.npl_balance, 0) * 100.0 
            / nullif(coalesce(l.total_portfolio, 0), 0), 2) as npl_ratio,
        coalesce(d.total_deposits, 0) 
            - coalesce(l.total_portfolio, 0) as net_position
    from branches as b
    left join loans_agg as l    on b.branch_id = l.branch_id
    left join deposits_agg as d on b.branch_id = d.branch_id
)
select * from final