with collateral as(
    select * from {{ ref('int_collateral_coverage') }}
)
select 
    loan_type,

    round(avg(ltv_pct), 2) as avg_ltv_pct,

    round(avg(coverage_ratio),2) as avg_coverage_ratio,

    count(case when is_undercollateralized = true then 1 end) as undercollateralized_count,

    round(
        (count(case when is_undercollateralized = true then 1 end )* 100
            /nullif(count(loan_id),0) 
        ), 2 )as undercollateralized_pct,

    round(avg(collateral_gap), 2) as avg_collateral_gap
from collateral
group by loan_type
