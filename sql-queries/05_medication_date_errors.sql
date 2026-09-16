-- ============================================================
-- Query 5: Medications Where end_date Is Before start_date
-- Business reason: A logically impossible date range — almost
-- always a data entry error at order entry or a mapping bug in
-- an interface transforming free-text/date fields. Left
-- uncorrected, this breaks "active medication" logic downstream
-- (a med may incorrectly show as inactive or vice versa).
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
    CASE
        WHEN m.end_date < m.start_date THEN 'INVALID: end before start'
        ELSE 'OK'
    END AS date_validity
FROM medications m
JOIN patients p ON m.patient_id = p.patient_id
WHERE m.end_date < m.start_date
ORDER BY m.start_date DESC;
