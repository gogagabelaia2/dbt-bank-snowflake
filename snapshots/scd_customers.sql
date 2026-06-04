{% snapshot scd_customers %}

{{
    config(
        target_schema='snapshots',
        unique_key='customer_id',
        strategy='check',
        check_cols=['customer_type', 'city', 'country_code']
    )
}}

select
    customer_id,
    customer_type,
    first_name,
    last_name,
    email,
    gender,
    country_code,
    country_name,
    city,
    onboarding_date,
    created_at
from {{ source('bank_raw', 'customers') }}

{% endsnapshot %}