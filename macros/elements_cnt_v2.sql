{% macro elements_cnt_v2() %}

{% if execute %}

{% set models_cnt = 0 %}
{% set seeds_cnt = 0 %}
{% set snapshots_cnt = 0 %}
   
{% for node in graph.nodes.values() %}
    {% if node.resource_type == 'model' %}
        {% do log(1, True)%}
        {% set models_cnt = models_cnt + 1 %}
    {#% elif node.resource_type == 'seed' %}
        {% set seeds_cnt = seeds_cnt  + 1 %}
    {% elif node.resource_type == 'snapshot' %}
        {% set snapshots_cnt = snapshots_cnt + 1 % #}
    {% endif %}
{% endfor %}


{% set result %}
    Всего в проекте:
    - {{ models_cnt }} моделей
    - {{ seeds_cnt }} seed
    - {{ snapshots_cnt }} snapshot
{% endset %}

{% do log(result, True)%}

{% endif %}
{% endmacro %}