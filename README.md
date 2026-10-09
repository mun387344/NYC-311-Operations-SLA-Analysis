# NYC 311 Operations & SLA Analysis

## Project Overview

This project analyzes NYC 311 service requests to identify demand patterns, operational differences across city agencies, and service resolution performance.

The analysis uses PostgreSQL for data exploration, cleaning, and business analysis, and Power BI for interactive visualization and reporting.

The project focuses on three main questions:

1. What types of service requests generate the highest demand?
2. How does request volume vary across boroughs and agencies?
3. How quickly are requests resolved, and where do longer resolution times occur?

---

## Business Objective

NYC 311 receives a large volume of service requests covering issues such as parking, noise, housing conditions, sanitation, street conditions, and other city services.

The goal of this project was to transform raw 311 request data into actionable insights that could help identify:

- Major sources of service demand
- Geographic patterns in complaints
- Differences in resolution performance across agencies
- Long-running requests and operational bottlenecks
- Due-date compliance where a recorded service deadline was available

---

## Dataset

**Source:** NYC Open Data — 311 Service Requests from 2010 to Present

The dataset used for this project contains approximately **539,545 raw records** from a selected period in October–November 2025.

For the main analysis, I used the complete daily period:

**October 11, 2025 – November 29, 2025**

This represents **50 complete days**.

Partial dates at the beginning and end of the extracted dataset were excluded from the main analysis to avoid comparing incomplete days with full days.

### Key fields

- Request ID
- Created Date
- Closed Date
- Due Date
- Agency
- Problem
- Problem Detail
- Location Type
- Borough
- Status
- Resolution Description
- Geographic information
- Open Data Channel Type

---

## Tools

- **PostgreSQL** — data exploration, cleaning, transformation, and analysis
- **pgAdmin** — SQL development and database management
- **Power BI** — dashboard development and visualization
- **Git & GitHub** — version control and project documentation

---

## Project Workflow

```text
Raw NYC 311 Data
       ↓
Data Exploration
       ↓
Data Quality Investigation
       ↓
SQL Cleaning & Transformation
       ↓
Request Volume Analysis
       ↓
Resolution & Due-Date Analysis
       ↓
Power BI Dashboard
       ↓
Business Findings & Recommendations

```
Data Preparation & Cleaning

The raw dataset was preserved in its original form.

Instead of modifying the raw data, a separate cleaned table was created for analysis.

Key cleaning decisions
Invalid resolution durations

I identified 117 records where the closed date occurred before the created date.

These records were retained in the dataset, but their resolution time was set to NULL and they were excluded from resolution-time calculations.

Missing closed dates

There were 8,968 records with a missing closed date in the extracted dataset.

Most of these were associated with requests that were still open, in progress, pending, assigned, or otherwise not completed.

Valid resolution times

Within the main analysis period:

529,057 total requests
520,123 requests with valid resolution times
8,934 requests excluded from resolution-time calculations
Approximately 98.3% of requests therefore had a usable resolution duration

The 8,934 excluded records were not deleted. They remained available for request-volume and other analyses.

Key Analysis
1. Request Demand

The analysis showed that NYC 311 demand is concentrated around several recurring service problems.

The highest-volume request types included:

Request Type	Requests
Illegal Parking	79,984
HEAT/HOT WATER	75,167
Noise - Residential	74,811
Blocked Driveway	25,974
Noise - Street/Sidewalk	19,649
UNSANITARY CONDITION	17,098
PLUMBING	9,982
Noise - Commercial	8,892
Noise	8,636
PAINT/PLASTER	8,365

This shows that demand is heavily concentrated around parking, housing conditions, noise, and sanitation-related issues.

2. Geographic Patterns

Request volume varies considerably across boroughs.

The analysis also showed that the most important geographic patterns are not simply about which borough has the most requests.

Specific problems are concentrated in specific locations.

Examples include:

Noise - Residential was particularly concentrated in the Bronx.
Illegal Parking was strongly concentrated in Brooklyn and Queens.
HEAT/HOT WATER generated high demand in the Bronx, Brooklyn, and Manhattan.

This suggests that operational planning should consider both location and request type, rather than looking only at total requests by borough.

3. Resolution Performance

Within the main analysis period:

529,057 total requests
520,123 valid resolution times
Median resolution time: 6.8 hours
Average resolution time: 205.0 hours
P90 resolution time: 357.4 hours
Why median and P90 were used

The average resolution time is much higher than the median because a smaller number of requests took a very long time to resolve.

The median represents the typical request more effectively:

50% of validly resolved requests were completed within approximately 6.8 hours.

The P90 shows the long tail:

90% of validly resolved requests were completed within approximately 357.4 hours, while the slowest 10% took longer than this.

This difference indicates substantial variation in resolution performance.

Resolution Benchmarks

Using analytical benchmarks rather than claiming official NYC 311 SLAs:

Benchmark	Percentage
Resolved within 24 hours	61.2%
Resolved within 72 hours	77.8%
Resolved within 7 days	84.9%

These are analytical benchmarks created for this project, not official NYC 311 service-level agreements.

4. Resolution Performance by Agency

Resolution performance varied significantly across agencies.

Selected median resolution times included:

Agency	Median Resolution
EDC	6,219.8 hours
TLC	2,332.8 hours
DOE	1,564.4 hours
OOS	1,030.6 hours
DCWP	158.5 hours
DOB	134.0 hours
DPR	116.4 hours
DOT	72.2 hours
DOHMH	67.8 hours
HPD	54.7 hours
DSNY	34.1 hours
DEP	29.2 hours
DHS	7.3 hours
NYPD	1.2 hours

Small-volume agencies should be interpreted cautiously because their resolution statistics are based on relatively few requests.

The results nevertheless show substantial operational differences between agencies.

5. Due-Date / SLA Analysis

A recorded Due Date was available only for a subset of requests, primarily DSNY/Graffiti requests.

Therefore, the project does not claim that 67.37% represents the SLA performance of all NYC 311 requests.

For the subset with recorded due dates:

2,224 requests had a recorded due date
2,179 were validly closed for due-date analysis
1,468 were closed by the recorded due date
711 were closed after the recorded due date
67.37% were completed by the recorded due date
32.63% were completed after the recorded due date
Important interpretation

The 67.37% figure represents:

The percentage of validly closed DSNY/Graffiti requests with recorded due dates that were completed by their recorded due date.

It should not be interpreted as an official NYC 311-wide SLA.

Key Findings
1. Demand is concentrated

Illegal Parking, HEAT/HOT WATER, and Noise - Residential were the three largest request categories in the analysis period.

2. Geography matters

Different problems are concentrated in different boroughs. Looking at borough totals alone can hide important operational patterns.

3. Resolution times have a long tail

The median resolution time was only 6.8 hours, while the P90 was approximately 14.9 days.

This indicates that most requests were resolved relatively quickly, but a smaller group remained open for much longer.

4. Agencies perform very differently

Median resolution times ranged from approximately 1.2 hours for NYPD to more than 6,000 hours for EDC in this dataset.

These differences should be interpreted in the context of agency responsibilities, request types, and volume.

5. Due-date compliance requires careful interpretation

Due-date information was available only for a subset of requests. Therefore, due-date compliance was analyzed separately rather than being presented as a citywide SLA.

Recommendations

Based on the analysis:

1. Investigate long-running requests

Agencies with very high median or P90 resolution times should be investigated further to identify operational bottlenecks.

2. Monitor the long tail

Average resolution time can be heavily influenced by a small number of extremely slow requests.

Median and P90 should therefore be monitored together.

3. Use geographic demand patterns for resource planning

Service demand should be evaluated by both borough and request type to identify where specific operational resources may be most needed.

4. Improve deadline monitoring

Where reliable due dates are available, agencies can monitor due-date compliance separately from general resolution time.

5. Investigate high-volume request categories

High-volume categories such as Illegal Parking, HEAT/HOT WATER, and Noise represent major sources of demand and may benefit from targeted operational strategies.

Power BI Dashboard

The Power BI dashboard provides an interactive view of the analysis.

Main dashboard components
Daily 311 Request Volume
Top 10 Request Types
Requests by Borough
Median Resolution Time by Agency
Total Requests
Median Resolution Time
P90 Resolution Time
Percentage Resolved Within 7 Days
Date, Borough, and Agency filters

The dashboard was validated against the PostgreSQL analysis to ensure that the reported figures were consistent across the SQL and Power BI layers.

Project Structure
NYC-311-Operations-SLA-Analysis/
│
├── README.md
│
├── data/
│   └── README.md
│
├── sql/
│   ├── 00_data_setup.sql
│   ├── 01_data_exploration.sql
│   ├── 02_data_cleaning.sql
│   ├── 03_request_analysis.sql
│   └── 04_resolution_analysis.sql
│
├── dashboard/
│   └── nyc_311_dashboard.pbix
│
├── images/
│   └── dashboard.png
│
└── findings/
    └── executive_summary.pdf

The raw dataset is not included in the repository because of its size. The project can be reproduced by downloading the dataset from NYC Open Data and following the SQL setup and analysis scripts.

Limitations
The project analyzes a selected period rather than the complete NYC 311 historical dataset.
The extracted dataset includes partial days at the boundaries; these were excluded from the main daily analysis.
A missing closed date does not necessarily mean that a request will never be resolved.
Resolution time measures the elapsed time between request creation and closure and does not by itself measure service quality.
Due-date information was available only for a subset of requests.
Analytical benchmarks of 24 hours, 72 hours, and 7 days are not official NYC 311 SLAs.
Small-volume agencies may have unstable or less representative resolution statistics.
Resolution differences between agencies should be interpreted alongside differences in request type, operational responsibilities, and workload.
What I Learned

This project strengthened my ability to:

Explore large datasets using SQL
Investigate data-quality issues before making assumptions
Separate raw data from analytical data
Build reproducible SQL cleaning workflows
Analyze operational KPIs
Use median and percentile metrics to understand skewed data
Compare performance across categories and geographic areas
Distinguish analytical benchmarks from official service-level commitments
Validate SQL results against Power BI
Translate technical analysis into business recommendations
Conclusion

The NYC 311 analysis demonstrates how public-service request data can be transformed into operational insights using SQL and Power BI.

The key lesson from the analysis is that request volume and resolution performance tell different parts of the story. High-demand problems require attention to workload and geographic concentration, while resolution metrics reveal differences in operational performance and long-running requests.

By combining request volume, geography, agency performance, and resolution-time analysis, the project provides a more complete view of NYC 311 service operations.

Author

Muna Mohammed Husen

Data Science Student | Aspiring Data Analyst

Skills demonstrated in this project:

SQL · PostgreSQL · Power BI · Data Cleaning · Data Analysis · KPI Analysis · Business Insights
