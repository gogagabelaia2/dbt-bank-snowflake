with final as(
    select 
        branch_id,
        branch_name,
        total_loans,
        total_portfolio,
        npl_count,
        npl_balance,
        total_deposits,
        npl_ratio,
        net_position
    from {{ref('int_branch_summary')}}
)
select * from final