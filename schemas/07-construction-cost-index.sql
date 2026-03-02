-- ============================================================
-- National Highway Construction Cost Index (NHCCI)
-- Source: FHWA - https://www.fhwa.dot.gov/policy/otps/nhcci/
-- ============================================================
-- Quarterly price index tracking highway construction costs
-- since Q1 2003. Small dataset (~90 rows) but directly relevant
-- to construction engineering for adjusting historical bid
-- prices to current dollars.
-- ============================================================

CREATE TABLE IF NOT EXISTS construction_cost_index (
    quarter_date        DATE PRIMARY KEY,  -- first day of quarter
    year                INTEGER,
    quarter             INTEGER,           -- 1-4
    nhcci_raw           DECIMAL(8, 3),     -- raw index value
    nhcci_seasonally_adj DECIMAL(8, 3),    -- seasonally adjusted
    quarterly_change_pct DECIMAL(6, 3)     -- percent change from prior quarter
);

CREATE INDEX IF NOT EXISTS idx_cci_year ON construction_cost_index(year);
