-- ============================================
-- Chicago Food Inspections
-- 04_q2_facility_type_risk.sql
-- Q2: Which facility types have the highest
-- failure rates?
-- ============================================

SELECT
    facility_type,
    COUNT(*)                                                   AS total_inspections,
    SUM(CASE WHEN results = 'Fail' THEN 1 ELSE 0 END)          AS total_failures,
    ROUND(
        SUM(CASE WHEN results = 'Fail' THEN 1 ELSE 0 END)
        * 100.0 / COUNT(*), 2
    )                                                          AS failure_rate_pct
FROM food_inspections
WHERE results IN ('Pass', 'Fail', 'Pass w/ Conditions')
  AND facility_type IS NOT NULL
  AND TRIM(facility_type) != ''
GROUP BY facility_type
HAVING COUNT(*) > 100
ORDER BY failure_rate_pct DESC
LIMIT 15;

-- ============================================
-- Key Finding:
-- Liquor stores (34.51%) and taverns (32.77%)
-- have the highest failure rates -- significantly
-- higher than restaurants (21.72%) which are the
-- most commonly inspected facility type.
-- Long Term Care facilities (25.69%) are notable
-- given they serve vulnerable populations.
-- Mobile food operations show elevated risk (25-27%)
-- likely due to challenges maintaining standards
-- on the move.
-- ============================================