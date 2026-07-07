-- ============================================
-- Chicago Food Inspections
-- 05_q3_yearly_trends.sql
-- Q3: How have inspection volumes and failure rates changed year over year?
-- ============================================

SELECT
    DATE_PART('year', inspection_date)                          AS yr,
    COUNT(*)                                                    AS total_inspections,
    SUM(CASE WHEN results = 'Fail' THEN 1 ELSE 0 END)          AS total_failures,
    ROUND(
        SUM(CASE WHEN results = 'Fail' THEN 1 ELSE 0 END)
        * 100.0 / COUNT(*), 2
    )                                                           AS failure_rate_pct
FROM food_inspections
WHERE results IN ('Pass', 'Fail', 'Pass w/ Conditions')
GROUP BY yr
ORDER BY yr;

-- ============================================
-- Key Finding:
-- Inspection volumes dropped sharply in 2020
-- (COVID-19 impact: 12,600 vs 16,121 in 2019).
-- Failure rates steadily climbed from 20% in 2014
-- to a peak of 24.88% in 2022-2023, then improved
-- back to ~21% in 2024-2025.
-- 2026 data is partial (Jan-Jul only).
-- ============================================