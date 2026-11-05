-- ============================================================
-- Query 1: Duplicate Patient Registrations
-- Business reason: Matching name and DOB can flag potential duplicate
-- registrations, but does not confirm patient identity. Review
-- MRNs, assigning authorities, and additional demographics before
-- concluding records belong to the same patient.
-- Skills shown: GROUP BY + HAVING
-- ============================================================

SELECT
    first_name,
    last_name,
    dob,
    COUNT(*)              AS registration_count,
    GROUP_CONCAT(mrn)      AS mrns_involved,
    GROUP_CONCAT(patient_id) AS patient_ids_involved
FROM patients
GROUP BY first_name, last_name, dob
HAVING COUNT(*) > 1
ORDER BY registration_count DESC;
