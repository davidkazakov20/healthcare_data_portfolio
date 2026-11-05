-- ============================================================
-- Query 7: Patients With No Lab Results in the Last 90 Days
-- Business reason: Flags patients with no recorded labs during
-- the 90 days preceding a fixed demo as-of date (2026-08-30).
-- This is not proof that testing was clinically indicated or that
-- an interface failed. Fixed dates keep demo results reproducible.
-- Skills shown: CTE + date functions
-- Author: David Kazakov
-- Date: September 2026
-- ============================================================

-- SQLite reference implementation; 2026-08-30 is an intentional
-- historical snapshot date, not today's date.
WITH last_lab_per_patient AS (
    SELECT
        patient_id,
        MAX(result_date) AS most_recent_result_date
    FROM lab_results
    GROUP BY patient_id
)
SELECT
    p.patient_id,
    p.mrn,
    p.first_name,
    p.last_name,
    ll.most_recent_result_date,
    CASE
        WHEN ll.most_recent_result_date IS NULL THEN 'No labs on record'
        ELSE CAST(julianday('2026-08-30') - julianday(ll.most_recent_result_date) AS INTEGER) || ' days ago'
    END AS last_lab_status
FROM patients p
LEFT JOIN last_lab_per_patient ll ON p.patient_id = ll.patient_id
WHERE ll.most_recent_result_date IS NULL
   OR ll.most_recent_result_date < date('2026-08-30', '-90 days')
ORDER BY ll.most_recent_result_date;
