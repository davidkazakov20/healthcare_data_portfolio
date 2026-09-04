-- Query 3: Orphaned Lab Results
-- Purpose: Find lab results referencing encounters
-- that don't exist in the encounters table
-- Common cause: HL7 interface timing issues
-- or failed encounter creation
-- Skills: LEFT JOIN + IS NULL


SELECT
  	l.result_id,
    l.patient_id,
    l.encounter_id,
    l.test_name,
    l.result_value,
    l.result_status
FROM lab_results AS l
LEFT JOIN encounters AS e
ON l.encounter_id = e.encounter_id
WHERE e.encounter_id IS NULL
