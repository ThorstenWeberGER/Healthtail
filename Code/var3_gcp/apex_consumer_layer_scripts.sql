-- apex health clinic scripts to create consumer data models

-- data model for inventory audit
create or replace table `masteschool-gcp.apex_consumer.inventory` as
-- add ordered drugs
select
  'stock_in' as transaction_type,
  date_trunc(month_invoice, MONTH) as date,
  med_name as drug,
  supplier,
  sum(packs) as total_packs,
  sum(total_price) as total_value,
from `masteschool-gcp.apex_integration.invoices_clean` as ic 
group by transaction_type, date, drug, supplier
union all
-- add consumed drugs
select
  'stock_out' as transaction_type,
  date_trunc(visit_datetime, MONTH) as date,
  med_prescribed as drug,
	'-' as supplier,
  sum(med_dosage) as total_packs,
  sum(med_cost) as total_value
from `masteschool-gcp.apex_integration.visits_clean` as vc
group by transaction_type, date, drug --, supplier
;

-- date model for disease tracking
-- datamodel für answering questions regarding diseases over time and segmented by breed, sex, a.s.o.
create or replace table `masteschool-gcp.apex_consumer.diseases` as
select
	date_trunc(vc.visit_datetime, MONTH) year_month,
	vc.diagnosis,
	pc.breed_clean,
	pc.gender,
	pc.patient_age,
	pc.pet_type,
	sum(vc.med_cost) as total_med_costs,
	count(vc.diagnosis) as disease_cnt
from
	`masteschool-gcp.apex_integration.visits_clean` as vc
left join `masteschool-gcp.apex_integration.patients_clean` pc
		using (patient_id)
group by
	year_month,
	breed_clean,
	gender,
	patient_age,
	pet_type,
	diagnosis
;