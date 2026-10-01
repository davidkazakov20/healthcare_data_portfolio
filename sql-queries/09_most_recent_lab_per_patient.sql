-- ============================================================
-- Query 9: Most Recent Lab Result Per Patient
-- Business reason: A common "current state" pattern needed for
-- clinical summary views and dashboards — show only each
-- patient's latest result per visible list row rather than every
-- historical result.
-- Skills shown: ROW_NUMBER (window function)
-- Design note: Used ROW_NUMBER() instead of a correlated subquery
-- with MAX(result_date), since it naturally extends to "top 3
-- most recent" later with no rewrite — just changing
-- WHERE rn <= 1 to <= 3.
-- ============================================================

SELECT
    patient_id,
    mrn,
    first_name,
    last_name,
    test_name,
    result_value,
    result_units,
    abnormal_flag,
    result_date
FROM (
    SELECT
        lr.patient_id,
        p.mrn,
        p.first_name,
        p.last_name,
        lr.test_name,
        lr.result_value,
        lr.result_units,
        lr.abnormal_flag,
        lr.result_date,
        ROW_NUMBER() OVER (
            PARTITION BY lr.patient_id
            ORDER BY lr.result_date DESC
        ) AS rn
    FROM lab_results lr
    JOIN patients p ON lr.patient_id = p.patient_id
) ranked
WHERE rn = 1
ORDER BY result_date DESC;
