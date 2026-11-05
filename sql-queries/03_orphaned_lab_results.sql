-- ============================================================
-- Query 3: Lab Results With No Matching Encounter
-- Business reason: This audit flags lab rows whose encounter_id
-- has no matching encounter row. Some valid laboratory workflows
-- may not require encounter linkage; investigate the data model,
-- feed timing, and source-system rules before calling it an error.
-- Skills shown: LEFT JOIN + IS NULL
-- ============================================================

SELECT
    lr.lab_result_id,
    lr.encounter_id AS referenced_encounter_id,
    lr.patient_id,
    lr.test_name,
    lr.result_date
FROM lab_results lr
LEFT JOIN encounters e ON lr.encounter_id = e.encounter_id
WHERE e.encounter_id IS NULL
ORDER BY lr.result_date DESC;
