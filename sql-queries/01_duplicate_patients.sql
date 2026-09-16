-- ============================================================
-- Query 1: Duplicate Patient Registrations
-- Business reason: Duplicate MRNs fragment a patient's clinical
-- history across records, causing missed allergies, duplicate
-- orders, and incomplete med reconciliation. Common root cause:
-- ADT A04 registration re-entry when an existing MRN isn't found
-- at check-in.
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
