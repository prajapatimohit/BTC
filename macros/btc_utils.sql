{% macro convert_to_usd(x) %}
  {{ x }} * (
    SELECT price
    FROM {{ ref('btc_usd_max') }}
    WHERE to_date(REPLACE(snapped_at, ' UTC','')) = current_date()
  )
{% endmacro %}