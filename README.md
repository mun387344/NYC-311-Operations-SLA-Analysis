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
