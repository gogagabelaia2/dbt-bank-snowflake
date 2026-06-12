with customers as (
    select * from {{ ref('int_customer_summary') }}
),
final as (
    select
        customer_id,
        full_name,
        total_outstanding,
        rank() over (order by total_outstanding desc)           as outstanding_rank,
        ntile(100) over (order by total_outstanding desc)       as risk_percentile,
        sum(total_outstanding) over (order by total_outstanding desc )   as cumulative_portfolio
    from customers
)
select * from final
