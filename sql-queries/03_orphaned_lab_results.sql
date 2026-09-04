-- ============================================
-- Query 3: Orphaned Lab Results
-- ============================================
-- Purpose: Find lab results referencing
--          encounters that don't exist
--          in the encounters table
--
-- Business Impact: Indicates referential
--          integrity failure -- common when
--          HL7 lab results arrive before
--          encounter is created or when
--          encounter creation fails
--
-- Skills: LEFT JOIN + IS NULL
-- Author: David Kazakov
-- Date: September 2026
-- ============================================

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
