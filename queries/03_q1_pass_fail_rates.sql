-- ============================================
-- Chicago Food Inspections
-- 03_q1_pass_fail_rates.sql
-- Q1: What is the overall pass, fail, and
-- conditional pass rate across all inspections?
-- ============================================

SELECT
    results,
    COUNT(*)                                                    AS total,
    ROUND(COUNT(*) * 100.0 / SUM(COUNT(*)) OVER (), 2)         AS pct
FROM food_inspections
WHERE results IN ('Pass', 'Fail', 'Pass w/ Conditions')
GROUP BY results
ORDER BY total DESC;

-- ============================================
-- Key Finding:
-- When filtering to real inspection outcomes only,
-- 57.69% of inspections pass outright.
-- Nearly 1 in 5 inspections (22.17%) result in failure.
-- Pass w/ Conditions accounts for 20.14% --
-- meaning over 42% of inspections find some violation.
-- ============================================