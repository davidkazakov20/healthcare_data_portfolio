# Healthcare Data Quality Audit

A SQL + Power BI audit of a simulated hospital data environment (patient registration, encounters, lab results, medications), modeled on the kinds of data quality issues that surface in HL7 ADT/ORU interface feeds.

**Author:** David Kazakov — Sr. QA Engineer | Integration & Interface Analyst, healthcare data/interfaces  
[LinkedIn](https://linkedin.com/in/davidkazakov)

## Why this project

Working daily with HL7 interfaces, Mirth Connect, and SQL at an oncology diagnostics company, I built this project to demonstrate the kind of data quality work performed by Interface Analysts and Healthcare Data Analysts: finding where patient data breaks across systems, measuring the impact, and communicating the findings clearly.

## Problem → Approach → Findings

**Problem:** Hospital data systems accumulate quality issues from interface timing gaps, duplicate registrations, and manual entry errors. Left undetected, these can cause fragmented patient records, missed critical results, and broken downstream reporting.

**Approach:** Built a simulated hospital database (109 patients, 268 encounters, 360 lab results, 59 medications) with realistic, deliberately injected data quality issues. Wrote 10 SQL audit queries covering duplicate detection, referential integrity, completeness, and trend analysis. Visualized results in a 4-page Power BI dashboard.

**Findings (this dataset):**

| Issue | Count |
|---|---:|
| Duplicate patient registrations (same name + DOB) | 6 |
| Patients registered with zero encounters | 17 |
| Orphaned lab results (no matching encounter) | 12 |
| Medications with end_date before start_date | 1 |
| Patients with no lab activity in 90+ days | 66 |
| Lab result NULL rate (worst test type) | 11.1% (Troponin I) |

**Business impact:** In a live system, the duplicate registrations alone represent 6 patients whose clinical history is split across two MRNs — each a medication reconciliation and clinical safety risk. The orphaned lab results could indicate an interface timing or message-processing issue rather than a simple data-entry problem, which changes where the investigation starts.

## Case Study

The same handful of problems tend to show up again and again in HL7 integration work.

A patient gets registered twice because the search fails to find the existing record. An ADT message is delayed or dropped during a brief interface outage, never reaching the inbound interface and leaving the target system with an encounter but no related order. Someone fixes a bad record manually, closes the ticket, and no one verifies whether the source and target systems are still in sync.

Individually, these issues can look minor. Across an EHR or HIE environment, they can create duplicate charts, broken patient-to-encounter relationships, and reports that appear correct but are based on incomplete data.

In this audit of 109 patients, I found:

- 6 patients with duplicate registrations
- 17 patients registered with no encounters
- 12 lab results with no matching encounter
- 1 medication record with an end date earlier than its start date

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

## How to Reproduce

1. `sample-data/generate_data.py` builds `healthcare_audit.db` (SQLite)
   from `schema.sql`, with intentional data quality issues injected.
2. Run any query directly: `sqlite3 healthcare_audit.db < ../sql-queries/01_duplicate_patients.sql`
3. `sample-data/run_queries.py` runs all 10 queries and exports results
   to `/powerbi/csv-exports/` for the dashboard.

## Other Projects

- **[HL7 to FHIR Integration Pipeline](https://github.com/davidkazakov20/healthcare_data_portfolio/tree/main/hl7-fhir)** — End-to-end HL7 v2.x to FHIR R4 conversion pipeline built in Mirth Connect, demonstrating interface engine configuration and healthcare interoperability standards mapping.

## Data Note

All data in this project is synthetically generated (via the `Faker`
library) — no real patient information is used anywhere in this
repository.
