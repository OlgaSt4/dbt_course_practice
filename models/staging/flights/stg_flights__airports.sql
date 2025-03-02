{{
    config(
        materialized = 'table',
        post_hook = '
            {% set beckup_relation = api.Relation.create(
                    database = this.database,
                    schema = this.schema,
                    identifier = this.identifier ~ "_dbt_backup_new",
                    type = "table"
                )
            %}
            {% do adapter.drop_relation(beckup_relation) %}
            {% do adapter.rename_relation(this, beckup_relation) %}
        '
    )
}}
select
    airport_code,
    airport_name,
    city,
    coordinates,
    timezone
from 
    {{ source('demo_src', 'airports') }}