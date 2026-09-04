-- ============================================
-- Query 2: Patients With No Encounters
-- ============================================
-- Purpose: Find patients registered in the system
--          but with no encounter history
-- Business Impact: Could indicate registration
--          errors or missing HL7 interface data
-- Skills: LEFT JOIN + IS NULL
-- Author: David Kazakov
-- Date: September 2026
-- ============================================

SELECT
    p.patient_id,
    p.first_name,
    p.last_name,
    p.dob,
    p.insurance_type
FROM patients AS p
LEFT JOIN encounters AS e
    ON p.patient_id = e.patient_id
WHERE
    e.encounter_id IS NULL
ORDER BY
    p.last_name;
