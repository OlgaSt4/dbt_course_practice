{% macro check_dependencies(model_name) %}
{% if execute %}

{% set dep_obj = {} %}
{% for node in graph.nodes.values() %}
    {% if node.name == model_name %}
        {% do dep_obj.update(node.depends_on) %}
    {% endif %}
{% endfor %}

{% set obj_keys = dep_obj.keys() | list %}

{% set cnt_in_obj = [] %}
{% for key in obj_keys %}
    {% do cnt_in_obj.append(dep_obj[key] | length ) %}
{% endfor %}


{% set obj_cnt = cnt_in_obj | sum %}

{% set result %}
{% if obj_cnt > 1 %}
    Модель {{ model_name }} зависит от {{ obj_cnt }} объектов! 
{% endif %}
{% endset %}

{% do log(result, True)%}

{% endif %}
{% endmacro %}

