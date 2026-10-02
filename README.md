# Healthcare Data Quality Audit

A SQL + Power BI audit of a simulated hospital dataset covering patient registration, encounters, lab results, and medications, built around common data quality issues found in HL7 ADT and ORU interface feeds.

**Author:** David Kazakov — Sr. QA Engineer | Integration & Interface Analyst, healthcare data/interfaces  
[LinkedIn](https://linkedin.com/in/davidkazakov)

## Why this project

Working daily with HL7 interfaces, Mirth Connect, and SQL in oncology diagnostics, I built this project to show how I approach real healthcare data quality problems — tracing where data breaks across systems, measuring the impact, and sharing findings with development.

## Problem → Approach → Findings

**Problem:** Hospital data systems often pick up quality issues from interface timing gaps, duplicate registrations, and manual entry errors. If they go unnoticed, they can lead to fragmented patient records, missed results, and unreliable downstream reporting.

**Approach:** I built a simulated hospital database with 109 patients, 268 encounters, 360 lab results, and 59 medications, then intentionally added realistic data quality issues. I wrote 10 SQL audit queries to check for duplicates, broken relationships, missing data, and trends, and summarized the results in a 4-page Power BI dashboard.

**Findings (this dataset):**

| Issue | Count |
|---|---:|
| Duplicate patient registrations (same name + DOB) | 6 |
| Patients registered with zero encounters | 17 |
| Orphaned lab results (no matching encounter) | 12 |
| Medications with end_date before start_date | 1 |
| Patients with no lab activity in 90+ days | 66 |
| Lab result NULL rate (worst test type) | 11.1% (Troponin I) |

**Business impact:** In a live system, 6 duplicate registrations would mean 6 patients with clinical history split across two MRNs — creating a real risk of missed medications, allergies, or prior results.

## Case Study

The duplicate patient records were the most important finding.

Six patients were each split across two MRNs, meaning a clinician could open what looks like a complete chart and still miss food or drug allergies, prior lab results, diagnoses, or procedures stored under the second record.

From an interface perspective, I would trace the HL7 message flow — validating **PID** for patient identifiers, **PV1** for encounters, **AL1** for allergies, **DG1/PR1** for diagnoses and procedures, **ORC/OBR** for orders, **SPM** for specimen details, and **OBX** for results.

Then, using an interface engine such as **Orion Rhapsody, Mirth Connect, or InterSystems HealthShare**, I would review connection status, ACK responses, and retry queues. When needed, I could also restart a Rhapsody Communication Point, stop/start a Mirth channel, or review and restart HealthShare services before validating that message flow resumed correctly.

These issues usually cross more than one team. Registration may need to stop the duplicate at the source, while the interface team may need to trace messages, compare patient identifiers, and help reconcile the history across systems.

This was a controlled batch audit. In production, I would move these checks closer to the source — flag likely duplicates earlier, validate patient-to-encounter-to-order relationships, and automatically detect missing or orphaned messages.

The goal is not just to fix one bad record. It is to understand where the data broke and prevent the same issue from affecting thousands of patients.

## SQL Audit Queries

| # | Query | SQL skill demonstrated |
|---|---|---|
| 1 | Duplicate patients (same name + DOB) | `GROUP BY` + `HAVING` |
| 2 | Patients registered but never had an encounter | `LEFT JOIN` + `IS NULL` |
| 3 | Lab results with no matching encounter | `LEFT JOIN` + `IS NULL` |
| 4 | Abnormal lab results with patient + provider detail | 3-table `JOIN` |
| 5 | Medications where end_date is before start_date | `CASE WHEN` + date logic |
| 6 | Providers with above-average encounter count | Subquery |
| 7 | Patients with no lab results in the last 90 days | CTE + date functions |
| 8 | Data completeness audit — NULL % per test type | `GROUP BY` + `CASE WHEN` |
| 9 | Most recent lab result per patient | `ROW_NUMBER()` window function |
| 10 | Monthly encounter volume trend | `GROUP BY` + date functions |

Each query file includes a header comment explaining the business reason it matters — not just what it does.

## Power BI Dashboard

Four pages, built from the CSV exports in `/powerbi/csv-exports/`:

1. **Data Quality Overview** — total issues found, completeness %, KPI cards
2. **Patient Summary** — encounter/lab volume, demographics, monthly trend
3. **Lab Results Analysis** — abnormal result rates and trends by test type
4. **Provider Performance** — encounter counts, above-average outliers

See `/docs/dashboard-build-guide.md` for the page-by-page build spec.

## Repository Structure

```text
/sql-queries/       10 standalone .sql files, one per audit query
/sample-data/       schema.sql, data generator script, and the SQLite db
/powerbi/           Power BI file + CSV exports used as its data source
/docs/              data dictionary, screenshots
```

## How to Reproduce

1. `sample-data/generate_data.py` builds `healthcare_audit.db` (SQLite) from `schema.sql`, with intentional data quality issues injected.
2. Run any query directly:  
   `sqlite3 healthcare_audit.db < ../sql-queries/01_duplicate_patients.sql`
3. `sample-data/run_queries.py` runs all 10 queries and exports results to `/powerbi/csv-exports/` for the dashboard.

## Other Projects

- **[HL7 to FHIR Integration Pipeline](https://github.com/davidkazakov20/healthcare_data_portfolio/tree/main/hl7-fhir)** — End-to-end HL7 v2.x to FHIR R4 conversion pipeline built in Mirth Connect, demonstrating interface engine configuration and healthcare interoperability standards mapping.

## Data Note

All data in this project is synthetically generated using the `Faker` library — no real patient information is used anywhere in this repository.
