{% snapshot scd_deposits %}

{{
    config(
        target_schema='snapshots',
        unique_key='deposit_id',
        strategy='check',
        check_cols=['status', 'principal_amount']
    )
}}

select
    deposit_id,
    customer_id,
    account_id,
    principal_amount,
    currency,
    status,
    created_at
from {{ source('bank_raw', 'deposits') }}

{% endsnapshot %}