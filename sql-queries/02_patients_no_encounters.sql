-- ============================================================
-- Query 2: Patients Registered but Never Had an Encounter
-- Business reason: Flags "dangling" registrations — patients
-- created in the system (often via ADT feed or pre-registration)
-- who never actually presented for care. Useful for identifying
-- interface issues where registration messages fire without a
-- corresponding visit message ever following.
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
