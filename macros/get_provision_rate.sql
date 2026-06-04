-- macros/get_provision_rate.sql
{% macro get_provision_rate(days_past_due) %}
    CASE
        WHEN {{ days_past_due }} = 0                       THEN 0.01
        WHEN {{ days_past_due }} BETWEEN 1  AND 30         THEN 0.05
        WHEN {{ days_past_due }} BETWEEN 31 AND 90         THEN 0.20
        WHEN {{ days_past_due }} > 90                      THEN 0.50
        ELSE 0.01
    END
{% endmacro %}