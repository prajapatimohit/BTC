{{  config(materialized='incremental',
    incremental_strategy='delete+insert',
    unique_key='HASH_KEY')
}}

SELECT
    *
FROM
    {{ source('btc', 'btc') }}

{% if is_incremental() %}
WHERE
    BLOCK_TIMESTAMP > (SELECT MAX(BLOCK_TIMESTAMP) FROM {{ this }})
{% endif %} 