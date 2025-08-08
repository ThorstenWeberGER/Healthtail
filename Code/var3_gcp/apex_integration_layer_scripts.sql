-- cleaning procedures for apex dataset - will create tablename_clean in integration layer

-- table patients
create or replace table `masteschool-gcp.apex_integration.patients_clean` as
select
  patient_id,
  patient_age,
  -- Extract prefix (title)
  REGEXP_EXTRACT(owner_name, r'(?i)\b(Dr|Mr|Mrs|Ms|Prof)\.?\b') AS extracted_prefix,
  -- Extract suffix
  REGEXP_EXTRACT(owner_name, r'(?i)\b(Jr|Sr|II|III|IV|PhD|MD|DDS|Esq)\.?\b') AS extracted_suffix,
  -- clean name field, trim and correct upper lower case
  initcap(
    TRIM(
      REGEXP_REPLACE(
        REGEXP_REPLACE(
          REGEXP_REPLACE(
            owner_name,
            r'(?i)\b(Dr|Mr|Mrs|Ms|Prof)\.?\b',
            ''
          ),
          r'(?i)\b(Jr|Sr|II|III|IV|PhD|MD|DDS|Esq)\.?\b',
          ''
        ),
        r'\.', ''  -- Remove leftover periods
      )
    )  
  ) AS owner_name_clean,
  trim(initcap(pet_type)) as pet_type,
  -- clean breed by replacing missing values and substituting no breed with unknown
  trim(
    initcap(
      ifnull(
        (case 
          when breed = 'No Breed' 
          then 'unknown' 
          else breed 
        end)
        , 'unknown'
        )
      )
    ) 
  as breed_clean,
  trim(initcap(patient_name)) as patient_name,
  trim(lower(gender)) as gender,
  -- clean phone by removing non numeric chars, whitespace and replacing + with leading 00
  REGEXP_REPLACE(
    REGEXP_REPLACE(
      owner_phone,
      r'^\+', '00'  -- Replace leading "+" with "00"
    ),
    r'[^0-9]', ''   -- Remove all non-numeric characters
  ) AS owner_phone_clean
from `masteschool-gcp.apex_stage.patients`
;

-- table visits
create or replace table `masteschool-gcp.apex_integration.visits_clean` as
select 
  * except(doctor, diagnosis, med_prescribed),
  initcap(trim(doctor)) as doctor,
  initcap(trim(diagnosis)) as diagnosis,
  initcap(trim(med_prescribed)) as med_prescribed
from masteschool-gcp.apex_stage.visits
;

-- table invoices
create or replace table `masteschool-gcp.apex_integration.invoices_clean` as
select 
  * except(supplier, med_name),
  initcap(trim(supplier)) as supplier,
  initcap(trim(med_name)) as med_name
from masteschool-gcp.apex_stage.invoices
;