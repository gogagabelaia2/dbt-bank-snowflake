with final as(
    select 
        customer_id,
        full_name,
        total_loans,
        total_outstanding,
        has_npl,
        npl_balance,
        total_deposits,
        net_exposure
    from {{ref('int_customer_summary')}}
)
select * from final