-- ============================================================
-- Query 2: Patients Registered but Never Had an Encounter
-- Business reason: Flags "dangling" registrations — patients
-- without linked encounters in this dataset. Pre-registration,
-- data retention, and interface timing can all explain this flag;
-- it is not proof of an integration failure.
-- Skills shown: LEFT JOIN + IS NULL
-- ============================================================

SELECT
    p.patient_id,
    p.mrn,
    p.first_name,
    p.last_name,
    p.registration_date
FROM patients p
LEFT JOIN encounters e ON p.patient_id = e.patient_id
WHERE e.encounter_id IS NULL
ORDER BY p.registration_date DESC;
