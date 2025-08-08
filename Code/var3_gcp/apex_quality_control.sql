-- some simple quality check for outliers, anomalies, empty fields
SELECT 
  min(month_invoice) as date_min,
  max(month_invoice) as date_max,
  min(packs) as packs_min,
  max(packs) as packs_max,
  min(price) as price_min,
  max(price) as price_max,
  min(total_price) as total_min,
  max(total_price) as total_max,
  countif(month_invoice is null) as month_invoice_na,
  countif(packs is null) as na_packs,
  countif(price is null) as na_price,
  countif(total_price is null) as total_price,
  count(*) as total_rows,
FROM `masteschool-gcp.apex_stage.invoices` as i
limit 10
;

-- compare in and outs across layers
select
	'stage' as layer,
	'in' as transaction_type,
	sum(packs) as PACKS ,
	sum(TOTAL_PRICE) as value
from masteschool-gcp.apex_stage.invoices -- ok
union all
select
	'stage' as layer,
	'out' as transaction_type,
	sum(v.MED_DOSAGE) as packs, 
	sum(v.MED_COST) as value
from masteschool-gcp.apex_stage.visits as v -- ???
union all
select
	'integration_visits_clean' as layer,
	'out' as transaction_type,
	sum(med_dosage) as PACKS ,
	sum(med_cost) as value
from masteschool-gcp.apex_integration.visits_clean -- ok
union all
select
	'integration_invoices_clean' as layer,
	'in' as transaction_type,
	sum(v.packs) as packs, 
	sum(v.total_price) as value
from masteschool-gcp.apex_integration.invoices_clean as v
union all
select
	'consumer' as layer,
	'in' as transaction_type,
	sum(v.total_packs) as packs, 
	sum(v.total_value) as value
from masteschool-gcp.apex_consumer.inventory as v
where transaction_type = 'stock_in'
union all
select
	'consumer' as layer,
	'out' as transaction_type,
	sum(v.total_packs) as packs, 
	sum(v.total_value) as value
from masteschool-gcp.apex_consumer.inventory as v
where transaction_type = 'stock_out'
order by layer, transaction_type
;

-- check diagnosis count across all three layers
WITH layer_counts AS (
  -- Your original query is used as a Common Table Expression (CTE)
  SELECT
    '01_stage' as layer,
    DIAGNOSIS,
    count(diagnosis) as count
  FROM
    `masteschool-gcp.apex_stage.visits`
  WHERE
    diagnosis IN ('Fleas', 'Arthritis', 'Ringworm')
  GROUP BY
    layer,
    diagnosis
  UNION ALL
  SELECT
    '02_integration' as layer,
    DIAGNOSIS,
    count(diagnosis) as count
  FROM
    `masteschool-gcp.apex_integration.visits_clean`
  WHERE
    diagnosis IN ('Fleas', 'Arthritis', 'Ringworm')
  GROUP BY
    layer,
    diagnosis
  UNION ALL
  SELECT
    '03_consumer' as layer,
    DIAGNOSIS,
    sum(disease_cnt) as count
  FROM
    `masteschool-gcp.apex_consumer.diseases`
  WHERE
    diagnosis IN ('Fleas', 'Arthritis', 'Ringworm')
  GROUP BY
    layer,
    diagnosis
)
SELECT
  DIAGNOSIS,
  -- Pivot counts into columns for better visualization
  MAX(CASE WHEN layer = '01_stage' THEN count ELSE 0 END) AS stage_count,
  MAX(CASE WHEN layer = '02_integration' THEN count ELSE 0 END) AS integration_count,
  MAX(CASE WHEN layer = '03_consumer' THEN count ELSE 0 END) AS consumer_count,
  -- Flag if all three counts match
  CASE
    WHEN MAX(CASE WHEN layer = '01_stage' THEN count END) = MAX(CASE WHEN layer = '02_integration' THEN count END)
      AND MAX(CASE WHEN layer = '02_integration' THEN count END) = MAX(CASE WHEN layer = '03_consumer' THEN count END)
    THEN 'Match'
    ELSE 'Mismatch'
  END AS quality_check
FROM
  layer_counts
GROUP BY
  DIAGNOSIS
ORDER BY
  DIAGNOSIS
;