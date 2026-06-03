{% macro create_audit_log() %}
    create table if not exists {{ target.database }}.AUDIT.dbt_audit_log (
        model_name  varchar,
        run_started timestamp,
        target_env  varchar
    )
{% endmacro %}