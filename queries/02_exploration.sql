-- ============================================
-- Chicago Food Inspections
-- 02_exploration.sql — Data Exploration & Cleaning
-- ============================================


-- ============================================
-- SECTION 1: Big Picture
-- ============================================

-- Total row count
SELECT COUNT(*) AS total_rows
FROM food_inspections;

-- Unique facilities
SELECT COUNT(DISTINCT license_num) AS unique_facilities
FROM food_inspections;

-- Date range
SELECT
    MIN(inspection_date) AS earliest,
    MAX(inspection_date) AS latest
FROM food_inspections;


-- ============================================
-- SECTION 2: NULL & Empty String Check
-- ============================================

-- Count NULLs in key columns
SELECT
    COUNT(*) - COUNT(inspection_id)   AS missing_inspection_id,
    COUNT(*) - COUNT(dba_name)        AS missing_name,
    COUNT(*) - COUNT(facility_type)   AS missing_facility_type,
    COUNT(*) - COUNT(risk)            AS missing_risk,
    COUNT(*) - COUNT(inspection_date) AS missing_date,
    COUNT(*) - COUNT(results)         AS missing_results,
    COUNT(*) - COUNT(violations)      AS missing_violations,
    COUNT(*) - COUNT(latitude)        AS missing_latitude,
    COUNT(*) - COUNT(zip)             AS missing_zip
FROM food_inspections;

-- Check for empty strings in key columns
SELECT COUNT(*) AS empty_results
FROM food_inspections
WHERE results = '';

SELECT COUNT(*) AS empty_dates
FROM food_inspections
WHERE inspection_date::TEXT = '';

SELECT COUNT(*) AS empty_names
FROM food_inspections
WHERE dba_name = '';

-- Find corrupt rows
SELECT *
FROM food_inspections
WHERE dba_name IS NULL
   OR results IS NULL
   OR inspection_date IS NULL;


-- ============================================
-- SECTION 3: Cleaning
-- ============================================

-- Remove corrupt and empty rows
DELETE FROM food_inspections
WHERE results IS NULL
   OR results = ''
   OR inspection_date IS NULL
   OR dba_name IS NULL
   OR dba_name = '';

-- Verify row count after cleaning
SELECT COUNT(*) AS total_rows_after_cleaning
FROM food_inspections;

-- Convert inspection_date from TEXT to DATE
ALTER TABLE food_inspections
ALTER COLUMN inspection_date TYPE DATE
USING TO_DATE(inspection_date, 'MM/DD/YYYY');

-- Convert latitude and longitude to DOUBLE PRECISION
ALTER TABLE food_inspections
ALTER COLUMN latitude TYPE DOUBLE PRECISION
USING NULLIF(latitude, '')::DOUBLE PRECISION;

ALTER TABLE food_inspections
ALTER COLUMN longitude TYPE DOUBLE PRECISION
USING NULLIF(longitude, '')::DOUBLE PRECISION;

-- Verify final schema
SELECT
    column_name,
    data_type
FROM information_schema.columns
WHERE table_name = 'food_inspections'
ORDER BY ordinal_position;


-- ============================================
-- SECTION 4: Column Profiling
-- ============================================

-- Results breakdown with percentages
SELECT
    results,
    COUNT(*)                                                   AS total,
    ROUND(COUNT(*) * 100.0 / SUM(COUNT(*)) OVER (), 2)        AS pct
FROM food_inspections
GROUP BY results
ORDER BY total DESC;

-- Facility type breakdown
SELECT
    facility_type,
    COUNT(*) AS total
FROM food_inspections
WHERE facility_type IS NOT NULL
GROUP BY facility_type
ORDER BY total DESC
LIMIT 15;

-- Risk level breakdown
SELECT
    risk,
    COUNT(*) AS total
FROM food_inspections
WHERE risk IS NOT NULL
GROUP BY risk
ORDER BY total DESC;


-- ============================================
-- Data Quality Summary
-- ============================================
-- Total rows loaded:        234,044
-- Rows removed (corrupt):   5
-- Rows removed (empty):     2
-- Final clean row count:    234,039
--
-- Key findings:
-- - inspection_date converted from TEXT to DATE
-- - latitude/longitude converted to DOUBLE PRECISION
-- - 15% of results are non-inspection statuses
--   (Out of Business, No Entry, Not Ready)
--   these will be filtered in analytical queries
-- - 1,772 rows have blank facility_type
-- - 46 rows have blank risk level
-- ============================================