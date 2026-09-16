-- ============================================================
-- Query 3: Lab Results With No Matching Encounter
-- Business reason: An ORU (lab result) message should always tie
-- back to a valid encounter. Orphaned results usually indicate an
-- ADT/ORU timing mismatch at the interface layer (result message
-- arrived before/without its encounter, or the encounter was later
-- merged/deleted) and should be routed back to the interface team.
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
