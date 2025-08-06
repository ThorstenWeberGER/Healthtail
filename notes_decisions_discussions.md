# Notes

### Dirty data

**cleaning**: 
* standardisation (names, case, ...)
* cleaning phone-numbers, removing non-numerical chars
* imputation - missing values in breed 

# Decisions


**BigQuery datasets**
- apex_stage (3 tables raw data)
- apex_integration 
  - ...
  - registration_clean
- apex_consumer
  - ...
  - med_audit (invoices_visits)

# Job Lists

## data cleaning (step 1)

**The registration card table** likely contains errors due to *manual data entry* by the vet clinic staff.

* inaccuracies in pet or owner names
* missing values in certain columns
* inconsistencies in phone numbers

> `task` is to create a `new table, registration_clean`, that resolves all inconsistencies in the healthtail_reg_cards table. 

## data model (step 2)

requested a `dedicated table, med_audit`, to track 
* the monthly movement of medications, 
* including purchases and 
* usage during visits or procedures. 

> `task` is a query that `combines` data from the `invoices table` (for purchased medications) and the `visits table` (for medications used). 

