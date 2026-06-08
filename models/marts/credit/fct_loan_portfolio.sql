with loans as(
    select * from {{ref('int_loan_classification_metrics')}}
)
select 
    loan_type,
    
    count(loan_id) as total_loans,

    sum(outstanding_balance) as total_portfolio,

    count(case when is_npl = true then 1 end ) as npl_count,

    sum(case when is_npl then outstanding_balance end) as npl_balance,

    sum(case when is_npl = true then outstanding_balance end ) * 100.0
    / nullif(sum(outstanding_balance), 0) as npl_ratio,

    count(case when is_watchlist = true then 1 end ) as watchlist_count,

    count(case when is_watchlist = true then 1 end ) * 100.0 
        / NULLIF(count(loan_id), 0)    as watchlist_ratio,

    sum(provision_amount) * 100.0 
        / NULLIF(sum(outstanding_balance), 0)   as cost_of_risk_pct
from loans 
group by loan_type
