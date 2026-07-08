-- ============================================
-- Chicago Food Inspections
-- 06_q4_zip_code_risk.sql
-- Q4: Which ZIP codes are the riskiest?
-- ============================================

WITH zip_status AS (
    SELECT
        zip,
        COUNT(*) AS total_inspections,
        SUM(CASE WHEN results = 'Fail' THEN 1 ELSE 0 END) AS total_failures,
        ROUND(
            SUM(CASE WHEN results = 'Fail' THEN 1 ELSE 0 END)
            * 100.0 / COUNT(*), 2
        ) AS failure_rate_pct
    FROM food_inspections
    WHERE results IN ('Pass', 'Fail', 'Pass w/ Conditions')
        AND zip IS NOT NULL
        AND TRIM(zip) != ''
    GROUP BY zip
    HAVING COUNT(*) >= 200
)
SELECT
    zip,
    total_inspections,
    total_failures,
    failure_rate_pct,
    RANK() OVER (ORDER BY failure_rate_pct DESC) AS risk_rank
FROM zip_status
ORDER BY risk_rank
LIMIT 20;

-- ============================================
-- Key Finding:
-- The riskiest ZIP codes cluster on Chicago's
-- South and West sides. ZIP 60620 leads with
-- a 29.18% failure rate -- nearly 7 points above
-- the city average of 22.17%.
-- The top 10 riskiest ZIPs all exceed 26%,
-- suggesting systemic geographic disparities
-- in food safety outcomes.
-- ============================================