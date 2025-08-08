select
	'stage' as layer,
	'in' as transaction_type,
	sum(packs) as PACKS ,
	sum(TOTAL_PRICE) as value
from orders
union all
select
	'stage' as layer,
	'out' as transaction_type,
	sum(v.MED_DOSAGE) as packs, 
	sum(v.MED_COST) as value
from visits as v
union all
select
	'integration' as layer,
	'in' as transaction_type,
	sum(packs) as PACKS ,
	sum(TOTAL_PRICE) as value
from orders_clean
union all
select
	'integration' as layer,
	'out' as transaction_type,
	sum(v.MED_DOSAGE) as packs, 
	sum(v.MED_COST) as value
from visits_clean as v
union all
select
	'consumer' as layer,
	'in' as transaction_type,
	sum(v.units) as packs, 
	sum(v.value) as value
from consumer_stock_audit as v
where transaction_type = 'stock_in' -- ok
union all
select
	'consumer' as layer,
	'out' as transaction_type,
	sum(v.units) as packs, 
	sum(v.value) as value
from consumer_stock_audit as v
where transaction_type = 'stock_out' -- ok
;


select
	count(*) as row_cnt,
	count(visit_id) as visit_id_cnt,
	sum(med_dosage) as med_dosage_sum,
	sum(med_cost) as med_cost_sum
from visits;


select 
	'01_stage' as layer,
	DIAGNOSIS,
	count(diagnosis)
from visits
where diagnosis in ('Fleas', 'Arthritis', 'Ringworm')
group by layer, diagnosis
union all
select 
	'02_integration' as layer,
	DIAGNOSIS,
	count(diagnosis)
from visits_clean
where diagnosis in ('Fleas', 'Arthritis', 'Ringworm')
group by layer, diagnosis
union all
select 
	'03_consumer' as layer,
	DIAGNOSIS,
	count(diagnosis)
from consumer_diseases
where diagnosis in ('Fleas', 'Arthritis', 'Ringworm')
group by layer, diagnosis
order by layer, diagnosis
;