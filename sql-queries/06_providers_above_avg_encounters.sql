-- ============================================================
-- Query 6: Providers With Above-Average Encounter Count
-- Business reason: Identifies high-volume providers — useful for
-- capacity planning, and for QA purposes as a starting point to
-- check whether high-volume interfaces/providers correlate with
-- higher data quality issue rates.
-- Skills shown: Subquery
-- Author: David Kazakov
-- Date: September 2026
-- ============================================================

SELECT
    pr.provider_id,
    pr.first_name,
    pr.last_name,
    pr.specialty,
    COUNT(e.encounter_id) AS encounter_count
FROM providers pr
JOIN encounters e ON pr.provider_id = e.provider_id
GROUP BY pr.provider_id, pr.first_name, pr.last_name, pr.specialty
HAVING COUNT(e.encounter_id) > (
    SELECT AVG(enc_count) FROM (
        SELECT COUNT(*) AS enc_count
        FROM encounters
        GROUP BY provider_id
    )
)
ORDER BY encounter_count DESC;
