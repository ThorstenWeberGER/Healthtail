-- what med did we spend most money in total
-- interpretation: spend means value of ordered drugs
select
  drug,
  sum(total_value) as total_value
from `masteschool-gcp.apex_consumer.inventory`
where transaction_type = 'stock_in'
group by drug
order by total_value desc
limit 1
;
-- drug with highest order total is Vetmedin (Pimobendan) at 1.035M value

-- what med did have the highest monthly value
-- interpretation: now the business question adresses consumption of medication
select
  drug,
  date,
  sum(total_value) as total_value
from `masteschool-gcp.apex_consumer.inventory`
where transaction_type = 'stock_out'
group by drug, date
order by total_value desc
limit 1
;
-- Highest consumption of drug was for Palladia (Toceranib Phosphate) in 2024-11 with a value of 50.000


-- What month was the highest in packs of meds spent in vet clinic?
-- interpretation: spent means usage of medication in packs
select
  drug,
  date,
  sum(total_packs) as total_packs
from `masteschool-gcp.apex_consumer.inventory`
where transaction_type = 'stock_out'
group by drug, date
order by total_packs desc
limit 1
;
-- In 2024-12 we used up max packs every for a medication. It were 724 packs for Vetmedin

-- What’s an average monthly spent in packs of the med that generated the most revenue?
with drug_max_rev as (
select
    drug,
    sum(total_value) total_value
  from `masteschool-gcp.apex_consumer.inventory`
  where transaction_type='stock_out'
  group by drug
  order by total_value DESC
  limit 1
)
select
  drug,
  round(avg(total_value),2) as avg_monthly_revenue
from `masteschool-gcp.apex_consumer.inventory` as i
where drug in (select drug from drug_max_rev) and transaction_type='stock_out'
group by drug
;
-- Drug which created most revenue is Palladia (Toceranib Phosphate). 
-- It was prescribed in 24 month.
-- On average we made 26270.83 per month where it was prescribed
