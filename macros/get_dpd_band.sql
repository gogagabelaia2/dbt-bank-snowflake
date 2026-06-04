-- macros/get_dpd_band.sql
{% macro get_dpd_band(days_past_due) %}
    CASE
        WHEN {{ days_past_due }} = 0                       THEN 'Current'
        WHEN {{ days_past_due }} BETWEEN 1  AND 30         THEN 'DPD 1-30'
        WHEN {{ days_past_due }} BETWEEN 31 AND 90         THEN 'DPD 31-90'
        WHEN {{ days_past_due }} BETWEEN 91 AND 180        THEN 'DPD 91-180'
        WHEN {{ days_past_due }} > 180                     THEN 'DPD 180+'
        ELSE 'Unknown'
    END
{% endmacro %}