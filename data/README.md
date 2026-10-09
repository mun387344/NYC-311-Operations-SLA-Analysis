# Dataset

## Source

**NYC Open Data — 311 Service Requests from 2010 to Present**

Official source: https://data.cityofnewyork.us/Social-Services/erm2-nwe9

## Analysis Period

**October 11, 2025 – November 29, 2025**

The project analyzes 50 complete days of NYC 311 service requests. The original extract contained approximately 539,545 records and included partial days at the beginning and end of the extracted period. These partial days were excluded from the main analysis to ensure consistent daily comparisons.

## Purpose

The dataset is used to analyze NYC 311 service request volume, complaint patterns across boroughs, operational differences between agencies, resolution performance, and due-date compliance where recorded due dates are available.

## Data Preparation

The raw dataset was preserved separately from the cleaned analytical table. SQL was used to investigate data quality, handle invalid resolution durations, and prepare the data for analysis.

Records without valid resolution times were retained for analyses such as request volume but excluded from resolution-time calculations.

## Important Notes

* The original NYC Open Data dataset is continuously updated. This project uses a fixed extract to support reproducibility.
* The main analysis period excludes partial days at the boundaries of the extract.
* Due-date information was available only for a subset of requests, primarily DSNY/Graffiti requests. Due-date compliance results should not be interpreted as citywide NYC 311 SLA performance.
* The raw dataset is not included in this repository. To reproduce the project, download the source data and follow the SQL setup and analysis scripts.
