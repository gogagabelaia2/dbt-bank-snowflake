with customers as(
    select * from {{ ref('int_customer_summary') }}
),
final as(
    select 
        customer_id,
        full_name,
        total_loans,
        total_outstanding,
        has_npl,
        npl_balance,
        total_deposits,
        net_exposure,
        rank() over (order by total_outstanding desc) as risk_rank,
        ntile(4) over (order by total_outstanding desc) as risk_quartile,
        case 
            when has_npl = 1 then 'High Risk'
            when net_exposure > 0 then 'At Risk'
            else 'Healthy'
        end as risk_segment
    from customers
)
select * from final