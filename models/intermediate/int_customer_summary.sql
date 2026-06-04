with loans as(
    select
        loan_id,
        customer_id,
        loan_type,
        outstanding_balance,
        days_past_due,
        classification
    from {{ ref('stg_loans') }}
),
logic as(
    select 
        loan_id,
        customer_id,
        loan_type,
        outstanding_balance,
        days_past_due,
        classification,
        {{get_dpd_band('days_past_due')}} as dpd_band,
        (case when days_past_due> 90 then true else false end) as is_npl,
        (case when classification in ('Watch','Substandard') then true else false end) as is_watchlist,
        {{get_provision_rate('days_past_due')}} as provision_rate,
        (outstanding_balance * {{get_provision_rate('days_past_due')}}) as provision_amount
    from loans
)
select * from logic
