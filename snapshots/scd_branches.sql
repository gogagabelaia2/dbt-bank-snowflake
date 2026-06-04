{% snapshot scd_branches %}
{{
    config(
        target_shcema='snapshot',
        unique_key='branch_id',
        strategy='check',
        check_cols=['city','country_code','country_name']
    )
}}

select
    branch_id,
    branch_code,
    branch_name,
    country_code,
    country_name,
    city,
    latitude,
    longitude,
    created_at
from {{ source('bank_raw', 'branches') }}

{% endsnapshot %}