-- create two consumer level datamodels for apex health care dashboarding

-- datamodel für answering questions regarding diseases over time and segmented by breed, sex, a.s.o.
drop table if exists consumer_diseases;

create table if not exists consumer_diseases as
select
	date_trunc('month', vc.visit_datetime_clean) year_month,
	vc.diagnosis,
	pc.breed,
	pc.gender,
	pc.patient_age,
	pc.pet_type,
	count(vc.diagnosis) as disease_cnt
from
	visits_clean as vc
left join patients_clean pc
		using (patient_id)
group by
	year_month,
	breed,
	gender,
	patient_age,
	pet_type,
	diagnosis
;
-- create datamodel for stock auditing purposes tracking supply and consumption
drop table if exists consumer_stock_audit;
-- start with orders as supply in
create table if not exists consumer_stock_audit as
select
	'stock_in' as transaction_type,
	date_trunc('month', oc.month_invoice_cleaned) as year_month,
	oc.med_name,
	oc.supplier,
	sum(oc.packs) as units,
	--sum(oc.price) as unit_cost,
	sum(oc.total_price) as value
from
	orders_clean as oc
	-- group on adequate level for data reduction
group by
	transaction_type,
	year_month,
	med_name,
	supplier
	-- append medication usage
union all
select
	'stock_out' as transaction_type,
	date_trunc('month', vc.visit_datetime_clean) as year_month,
	vc.med_prescribed as med_name,
	'-' as supplier,
	sum(vc.med_dosage) as units,
	sum(vc.med_cost) as value
from
	visits_clean as vc
group by
	transaction_type,
	year_month,
	med_name,
	supplier
order by
	transaction_type,
	year_month,
	med_name,
	supplier
;