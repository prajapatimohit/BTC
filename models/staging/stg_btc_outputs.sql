{{  config(materialized='incremental',
    incremental_strategy= 'append')
}}

With flattened_outputs as (
SELECT
tx.hash_key,
tx.block_number,
tx.block_timestamp,
tx.is_coinbase,
f.value:address::string as Output_Address,
f.value:value::float as Output_Value


FROM
{{ ref('stg') }} tx, 
lateral flatten(input => outputs) as f

WHERE
f.value:address is not null

{% if is_incremental() %}
AND
    tx.BLOCK_TIMESTAMP > (SELECT MAX(tx.BLOCK_TIMESTAMP) FROM {{ this }})
{% endif %} 
)

SELECT
hash_key,
block_number,
block_timestamp,
is_coinbase,
Output_Address,
Output_Value
FROM
flattened_outputs