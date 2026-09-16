-- ============================================================
-- Query 4: Abnormal Lab Results With Patient + Provider Detail
-- Business reason: Surfaces clinically actionable results
-- (High/Low/Critical) alongside who ordered them and who the
-- patient is, mirroring a real critical-results worklist a
-- clinical data or QA team would review.
-- Skills shown: 3-table JOIN
-- ============================================================

SELECT
    lr.result_date,
    p.mrn,
    p.first_name,
    p.last_name,
    lr.test_name,
    lr.result_value,
    lr.result_units,
    lr.abnormal_flag,
    pr.first_name AS ordering_provider_first,
    pr.last_name  AS ordering_provider_last,
    pr.specialty
FROM lab_results lr
JOIN patients p        ON lr.patient_id = p.patient_id
JOIN encounters e       ON lr.encounter_id = e.encounter_id
JOIN providers pr       ON e.provider_id = pr.provider_id
WHERE lr.abnormal_flag IN ('High', 'Low', 'Critical')
ORDER BY
    CASE lr.abnormal_flag WHEN 'Critical' THEN 1 WHEN 'High' THEN 2 ELSE 3 END,
    lr.result_date DESC;
