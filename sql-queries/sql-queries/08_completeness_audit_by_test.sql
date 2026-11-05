-- ============================================================
-- Query 8: Data Completeness Audit — NULL % Per Test Type
-- Business reason: The core "data quality scorecard" metric.
-- Measures what fraction of lab results are missing a numeric
-- result_value per test — a completeness indicator for the synthetic dataset.
-- A NULL numeric value is not, by itself, evidence of feed failure
-- (e.g., some tests may report qualitative results).
-- Skills shown: GROUP BY + CASE WHEN
-- ============================================================

SELECT
    test_name,
    COUNT(*)                                            AS total_results,
    SUM(CASE WHEN result_value IS NULL THEN 1 ELSE 0 END) AS missing_value_count,
    ROUND(
        100.0 * SUM(CASE WHEN result_value IS NULL THEN 1 ELSE 0 END) / COUNT(*),
        1
    )                                                    AS pct_missing
FROM lab_results
GROUP BY test_name
ORDER BY pct_missing DESC;
