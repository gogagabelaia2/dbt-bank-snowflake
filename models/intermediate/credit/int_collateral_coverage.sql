with loans as (
    select
        loan_id,
        customer_id,
        loan_type,
        outstanding_balance,
        days_past_due,
        classification
    from {{ ref('stg_loans') }}
),

collateral as (
    select
        collateral_id,
        loan_id,
        collateral_type,
        current_value
    from {{ ref('stg_collateral') }}
),

table_joins as (
    select
        l.loan_id,
        l.customer_id,
        l.loan_type,
        l.outstanding_balance,
        l.days_past_due,
        l.classification,
        co.collateral_id,
        co.collateral_type,
        co.current_value
    from loans as l
    left join collateral as co on co.loan_id = l.loan_id
),

calculations as (
    select
        loan_id,
        customer_id,
        loan_type,
        outstanding_balance,
        days_past_due,
        classification,
        collateral_id,
        collateral_type,
        current_value,
        {{ safe_divide('outstanding_balance * 100', 'current_value') }} as ltv_pct,
        {{ safe_divide('current_value', 'outstanding_balance') }}       as coverage_ratio,
        (outstanding_balance - current_value)                           as collateral_gap
    from table_joins
),

final as (
    select
        *,
        case
            when coverage_ratio < 1.2 then true
            else false
        end as is_undercollateralized
    from calculations
)

select * from final