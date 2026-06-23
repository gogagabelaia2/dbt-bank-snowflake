with monthly_volume as(
    select 
        month,
        total_volume,
        lag(total_volume) over (order by month ) as prev_month_volume
    from {{ ref('int_transactions_monthly') }}
),
growth_pct as(
    select
        month,
        total_volume,
        prev_month_volume,
        round((total_volume - prev_month_volume)/nullif(prev_month_volume,0) * 100 , 2) as volume_growth_pct
    from monthly_volume 
)
select * from growth_pct