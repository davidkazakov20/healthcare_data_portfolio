# Healthcare Data Quality Audit

A SQL + Power BI audit of a simulated hospital data environment (patient
registration, encounters, lab results, medications), modeled on the kinds
of data quality issues that surface in HL7 ADT/ORU interface feeds.

**Author:** David Kazakov — Sr. QA Engineer, healthcare data/interfaces
([LinkedIn](https://linkedin.com/in/davidkazakov))

## Why this project

Working daily with HL7 interfaces (Mirth Connect) and SQL as a QA Engineer
at a clinical lab company, I wanted to demonstrate — the
kind of data quality auditing that Interface Analysts, Epic Analysts, and
Healthcare Data Analysts do: finding where patient data breaks down across
systems, quantifying it, and communicating it to non-technical stakeholders.

## Problem → Approach → Findings

**Problem:** Hospital data systems accumulate quality issues from interface
timing gaps, duplicate registrations, and manual entry errors. Left
undetected, these cause fragmented patient records, missed critical
results, and broken downstream reporting.

**Approach:** Built a simulated hospital database (109 patients, 268
encounters, 360 lab results, 59 medications) with realistic, deliberately
injected data quality issues. Wrote 10 SQL audit queries covering
duplicate detection, referential integrity, completeness, and trend
analysis. Visualized results in a 4-page Power BI dashboard.

**Findings (this dataset):**
| Issue | Count |
|---|---|
| Duplicate patient registrations (same name + DOB) | 6 |
| Patients registered with zero encounters | 17 |
| Orphaned lab results (no matching encounter) | 12 |
| Medications with end_date before start_date | 1 |
| Patients with no lab activity in 90+ days | 66 |
| Lab result NULL rate (worst test type) | 11.1% (Troponin I) |

**Business impact:** In a live system, the duplicate registrations alone
represent 6 patients whose clinical history is split across two MRNs —
each a medication reconciliation and clinical safety risk. The orphaned
lab results point to a specific, fixable interface timing issue rather
than a data entry problem, which changes who owns the fix (interface team
vs. registration desk).

## Repository structure

```
/sql-queries/       10 standalone .sql files, one per audit query
/sample-data/       schema.sql, data generator script, and the SQLite db
/powerbi/           Power BI file + CSV exports used as its data source
/docs/              data dictionary, screenshots
```

## The 10 audit queries

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

Each query file includes a header comment explaining the business reason
it matters — not just what it does.

## How to reproduce

1. `sample-data/generate_data.py` builds `healthcare_audit.db` (SQLite)
   from `schema.sql`, with intentional data quality issues injected.
2. Run any query directly: `sqlite3 healthcare_audit.db < ../sql-queries/01_duplicate_patients.sql`
3. `sample-data/run_queries.py` runs all 10 queries and exports results
   to `/powerbi/csv-exports/` for the dashboard.

## Power BI dashboard

Four pages, built from the CSV exports in `/powerbi/csv-exports/`:

1. **Data Quality Overview** — total issues found, completeness %, KPI cards
2. **Patient Summary** — encounter/lab volume, demographics, monthly trend
3. **Lab Results Analysis** — abnormal result rates and trends by test type
4. **Provider Performance** — encounter counts, above-average outliers

See `/docs/dashboard-build-guide.md` for the page-by-page build spec.

## Data note

All data in this project is synthetically generated (via the `Faker`
library) — no real patient information is used anywhere in this
repository.
