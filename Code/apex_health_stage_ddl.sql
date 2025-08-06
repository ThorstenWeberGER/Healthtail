-- create new schema
drop schema if exists healthtail cascade;
create schema if not exists healthtail;

-- create table for patient records
create table if not EXISTS patients(
	patient_id varchar, -- the pet
	owner_id smallint,  -- the owner
	owner_name varchar,
	pet_type varchar,
	breed varchar,
	patient_name varchar, 
	gender varchar,
	patient_age smallint,
	date_registration date,
	owner_phone varchar
)
;

-- create medication orders table
drop table if exists orders;
create table if not exists orders (
	month_invoice date,
	invoice_id varchar,
	supplier varchar,
	med_name varchar,
	packs decimal,
	price decimal,
	total_price decimal
)
;


-- create patient visits table
drop table if exists visits;
create table if not exists visits (
	visit_id varchar,
	patient_id varchar,
	visit_datetime date,
	doctor varchar,
	diagnosis varchar,
	med_prescribed varchar,
	med_dosage decimal,
	med_cost decimal
)
;

-- create constraints for different tables
alter table patients
add constraint pk_patient_id primary key (patient_id);
alter table visits
add constraint pk_visit_id primary key (visit_id),
add constraint fk_patient_id foreign key (patient_id) references patients (patient_id);
alter table orders
add constraint pk_invoice_id primary key(invoice_id);