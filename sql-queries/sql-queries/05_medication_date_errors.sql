-- ============================================================
-- Query 5: Medications Where end_date Is Before start_date
-- Business reason: A logically impossible date range — a possible entry, source-system, or mapping error. Date
-- comparison assumes ISO-8601 YYYY-MM-DD text or date-compatible
-- storage. Validate source values before remediation.
-- Skills shown: CASE WHEN + date logic
-- Author: David Kazakov
-- Date: September 2026
-- ============================================================

SELECT
    m.medication_id,
    p.mrn,
    p.first_name,
    p.last_name,
    m.drug_name,
    m.start_date,
    m.end_date,
    'INVALID: end before start' AS date_validity
FROM medications m
JOIN patients p ON m.patient_id = p.patient_id
WHERE m.end_date < m.start_date
ORDER BY m.start_date DESC;
