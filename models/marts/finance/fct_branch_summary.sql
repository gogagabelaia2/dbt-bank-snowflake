with branches as(
    select * from {{ ref('int_branch_summary') }}
),
final as(
    select
        branch_id,
        branch_name,
        total_loans,
        total_portfolio,
        npl_count,
        npl_balance,
        total_deposits,
        npl_ratio,
        net_position,
        rank() over (order by total_portfolio desc)     as portfolio_rank,
        rank() over (order by npl_ratio desc)           as risk_rank,
        ntile(4) over (order by total_portfolio desc)   as portfolio_quartile
    from branches
)
select * from final