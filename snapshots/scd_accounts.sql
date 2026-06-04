{% snapshot scd_accounts %}

{{
    config(
        target_schema='snapshots',
        unique_key='account_id',
        strategy='check',
        check_cols=['status', 'balance']
    )
}}

select
    account_id,
    customer_id,
    branch_id,
    account_number,
    account_type,
    currency,
    balance,
    status,
    opened_date,
    created_at
from {{ source('bank_raw', 'accounts') }}

{% endsnapshot %}