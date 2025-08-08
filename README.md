# Apex Pet Health 🐾

> * Pipelines, EDA, Cleaning, Data Modeling, Automation, Dashboarding
> * PostgreSQL, Python, Google Cloud Platform, BigQuery and Looker

![logo](Images\apex_pet_health_logo.png)

## Project purpose 🧭

A veterinary clinic wants to improve  patient management processes by bringing most used data into a cloud platform and using real-time dashboard information to make decisions better and quicker. 

#### Key challanges 📋
1. `Auditing Medication Purchases and Expenses`: They need a way to easily track and analyze their annual medication spending.
2. `Monitoring Diagnoses and Disease Trends`: They want to identify common diagnoses and diseases segmented by pet type and breed. This information will help them plan staffing needs and optimize medication procurement.

#### The Deliverables 📦

* **Phase one**
  - Create an integrated `data model` according to business requirements
  - Ingest data into `BigQuery`
  - `Data cleaning` and `transformation`
* **Phase two**
  - `Answer business questions` to enhance efficiency and accuracy of medication audits
* **Phase three**
  - Deliver `interactive Looker Studio report` to monitor 
      ○ disease trends
      ○ patient diagnoses
      ○ medication inventory
  - `Live presentation` to clinic directors

**Results** 🏆

- [Data Model]() (including decisions) *tbd*
- [EDA, Cleaning, Transformation]() *t.b.d*
- [BigQuery]() *tbd*
- [Automated Pipeline]() *tbd*
- [SQL scripts]() *tbd*
- [Python scripts]() *tbd*
- [Looker Studio Report]() *tbd*

## Skills built 🚀



## Looking under the hood ⚡

#### The data

Apex Pet Health gave us three dirty datasets giving me a great opportunity to apply my datacleaning skills.

| **Table**      | **Description**           | **Notes**      | **Details** | 
|------------------|---------------------------|----------------------|------------------|
| `patients.csv` <br> rows: xxxx     | Records of all patients (pet) and their owners including pet info and contact data.        | *xxxxx *xxxxx *xxxxx | <a href="Images\table_patients.png"><img src="Images\table_patients.png" width="80"/></a> | 
| `visits.csv`  <br> rows: xxxxx      | Visits of pets including diagnoses and medications, dosage, cost | *xxxxx *xxxxx *xxxxx | <a href="Images\table_visits.png"><img src="Images\table_visits.png" width="80"/></a> | 
| `supplies_invoices.csv` <br>rows: xxxx   | Order information for medication from invoice records including supplier infos | *xxxxx *xxxxx *xxxxx | <a href="Images\table_invoices.png"><img src="Images\table_invoices.png" width="80"/></a> |

#### Thoughts for the datamodel

Best practice is to first consider business questions and dashboard requirements and then progress backwards to the datamodel.

**Situation**: business questions adress `two separate domains`
  * Stock data (in/out)
  * Diseases data (time-series, segmented)

**Solution**: `Two datemodels`, wide format for fast and convenient querying

![Datamodel_stock]()
![Datamodel_diseases]()

#### Cleaning requirements

Initial quality check showed minor anomalies which can be cleaned at ease.

* white space
* inconsistent use of upper lower case in text columns
* missing values in 'breed' (real NA and '')
* inconsistent categorical data (e.g. 'Unknown' and 'No breed')
* phone numbers with non-numeric characters like '-+,()'

#### Pipeline Setup: Local database

* Data is stored in PostgreSQL database
* Import data via SQLalchemy into Python Pandas dataframe
* Cleaning, transformation in Python
* Save cleaned data in new tables in PostgreSQL database
* Data modeling in PostgreSQL (t.b.d.)
* *Optional*: Tableau dashboarding

#### Pipeline Setup: Google Cloud Platform | BigQuery

* Data is uploaded into Google Cloud Storage bucket
* Transfered via DataTransfer into BigQuery
* Cleaning, transformation with SQL utilizing three layers (stage, integration, consumer)
* Set-up Pipeline automation
* Design and connect Looker Studio dashboard