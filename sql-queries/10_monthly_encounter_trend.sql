-- ============================================================
-- Query 10: Monthly Encounter Volume Trend
-- Business reason: Baseline operational metric — encounter volume
-- by month, split by type. Powers the trend line on the Power BI
-- Patient Summary page and is also a useful QA sanity check: a
-- sudden drop in volume for a given month often signals an
-- interface outage rather than an actual drop in patient visits.
-- Skills shown: GROUP BY + date functions
-- ============================================================

SELECT
    strftime('%Y-%m', admit_date) AS encounter_month,
    encounter_type,
    COUNT(*)                       AS encounter_count
FROM encounters
GROUP BY encounter_month, encounter_type
ORDER BY encounter_month, encounter_type;
