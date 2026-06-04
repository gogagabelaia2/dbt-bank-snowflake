{% snapshot scd_loans %}

{{
    config(
        target_schema='snapshots',
        unique_key='loan_id',
        strategy='check',
        check_cols=['outstanding_balance', 'days_past_due', 'classification']
    )
}}

select
    loan_id,
    customer_id,
    account_id,
    loan_type,
    original_amount,
    outstanding_balance,
    days_past_due,
    classification,
    created_at
from {{ source('bank_raw', 'loans') }}

{% endsnapshot %}