-- ============================================
-- Chicago Food Inspections
-- 01_setup.sql — Table schema
-- ============================================

DROP TABLE IF EXISTS food_inspections;

CREATE TABLE food_inspections (
    inspection_id     TEXT,
    dba_name          TEXT,
    aka_name          TEXT,
    license_num       TEXT,
    facility_type     TEXT,
    risk              TEXT,
    address           TEXT,
    city              TEXT,
    state             TEXT,
    zip               TEXT,
    inspection_date   TEXT,
    inspection_type   TEXT,
    results           TEXT,
    violations        TEXT,
    latitude          TEXT,
    longitude         TEXT,
    location          TEXT
);

-- Data loaded via load_data.py
-- Run: python load_data.py