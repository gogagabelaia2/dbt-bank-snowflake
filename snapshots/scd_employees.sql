{% snapshot scd_employees %}

{{
    config(
        target_schema='snapshots',
        unique_key='employee_id',
        strategy='check',
        check_cols=['department', 'branch_id', 'salary']
    )
}}

select
    employee_id,
    employee_code,
    first_name,
    last_name,
    branch_id,
    department,
    salary,
    created_at
from {{ source('bank_raw', 'employees') }}

{% endsnapshot %}