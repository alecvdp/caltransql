-- ============================================================
-- Practice Project: Inflation-Adjusted Construction Costs
-- ============================================================
-- Goal:
-- Compare historical contract awards in nominal dollars versus
-- inflation-adjusted dollars using construction_cost_index.
--
-- This project is ideal for learning date logic, reference-table
-- joins, and metric design.
-- ============================================================


-- ============================================================
-- PART 1: Prepare the Quarter Mapping
-- ============================================================

-- 1A: Explore construction_cost_index.
--     Show quarter_date, year, quarter, and nhcci_raw.


-- 1B: For each contract, derive:
--     - award_year
--     - award_quarter
--     from award_date.


-- 1C: Join contracts to construction_cost_index by matching
--     award_year + award_quarter to year + quarter.
--     Return contract_id, award_date, bid_amount, quarter_date, nhcci_raw.


-- ============================================================
-- PART 2: Choose a Reference Quarter
-- ============================================================

-- 2A: Find the most recent quarter in construction_cost_index.
--     Use it as your reference quarter.


-- 2B: Pull the reference nhcci_raw value into every contract row
--     using a CROSS JOIN, scalar subquery, or CTE.


-- 2C: Calculate inflation_adjusted_bid_amount:
--     bid_amount * (reference_nhcci_raw / contract_nhcci_raw)


-- ============================================================
-- PART 3: Compare Nominal vs Adjusted Spending
-- ============================================================

-- 3A: Aggregate contracts by award_year and show:
--     - contract_count
--     - nominal_total_bid_amount
--     - inflation_adjusted_total_bid_amount
--     - nominal_avg_bid_amount
--     - inflation_adjusted_avg_bid_amount


-- 3B: Which years change the most after adjustment?
--     Show the percent difference between nominal and adjusted totals.


-- 3C: Rank the top 20 contracts by nominal bid_amount.
--     Then rank the top 20 by inflation_adjusted_bid_amount.
--     How does the ordering change?


-- ============================================================
-- PART 4: Add Project Context
-- ============================================================

-- 4A: Join in construction_projects to add county and work_type.


-- 4B: Which counties have the most inflation-adjusted spending?


-- 4C: Which work_type categories become more important after adjustment?


-- ============================================================
-- PART 5: Final Deliverables
-- ============================================================

-- Deliverable 1:
-- A year-level spending table with nominal and adjusted totals.

-- Deliverable 2:
-- A top-contracts table with:
-- contract_id, contractor_name, county, award_date,
-- nominal_bid_amount, inflation_adjusted_bid_amount.

-- Deliverable 3:
-- A short written summary answering:
-- - Which years look most different after inflation adjustment?
-- - Which contracts remain the largest in current-dollar terms?
-- - Why is nominal-dollar ranking sometimes misleading?


-- ============================================================
-- Stretch Goals
-- ============================================================

-- Stretch 1: Repeat the analysis with nhcci_seasonally_adj
-- instead of nhcci_raw.

-- Stretch 2: Create a reusable view of inflation-adjusted contracts.

-- Stretch 3: Compare contractor rankings in nominal versus
-- adjusted dollars.
