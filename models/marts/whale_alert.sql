WITH WHALE AS (


SELECT

output_address,
SUM(output_value) AS total_sent,
COUNT(*) as tx_count

From
{{ref('stg_btc_transactions') }} 
where 
output_value > 10
group by output_address
order by total_sent desc
)

SELECT 

output_address,
total_sent,
tx_count,
{{ convert_to_usd('total_sent') }} AS total_sent_usd

from WHALE 
ORDER BY total_sent DESC

