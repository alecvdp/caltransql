-- ============================================================
-- Practice Project: Contractor Performance Dashboard
-- ============================================================
-- Goal:
-- Build a reusable SQL analysis of contractor performance using
-- the 'contracts' and 'construction_projects' tables.
--
-- Recommended outputs:
-- 1) A contractor summary table
-- 2) A "largest contracts" table
-- 3) A pricing comparison vs engineer estimates
-- ============================================================


-- ============================================================
-- PART 1: Build the Base Dataset
-- ============================================================

-- 1A: Join contracts to construction_projects on project_id.
--     Return one row per contract with:
--     contract_id, contractor_name, county, district, work_type,
--     award_date, bid_amount, engineer_estimate, final_cost.


-- 1B: Add a calculated column called bid_vs_estimate_pct:
--     ((bid_amount - engineer_estimate) / engineer_estimate) * 100
--     Be careful with NULL or zero engineer_estimate values.


-- 1C: Create a cleaned version of the base dataset in a CTE.
--     Exclude rows where bid_amount is NULL.


-- ============================================================
-- PART 2: Contractor Scorecard
-- ============================================================

-- 2A: For each contractor, calculate:
--     - number of contracts
--     - first award_date
--     - most recent award_date
--     - total bid_amount
--     - average bid_amount
--     - average bid_vs_estimate_pct


-- 2B: Add a rank by total bid_amount.
--     Show the top 15 contractors.


-- 2C: Add each contractor's share of statewide bid_amount.


-- ============================================================
-- PART 3: Largest and Riskiest Contracts
-- ============================================================

-- 3A: Find the single largest contract for each contractor.
--     Use ROW_NUMBER() or RANK().


-- 3B: Find contracts where bid_amount was at least 15% above
--     engineer_estimate.
--     Which contractors show up the most?


-- 3C: Find contracts with missing final_cost even though an
--     award_date exists. These may indicate incomplete data.


-- ============================================================
-- PART 4: County and Work-Type Patterns
-- ============================================================

-- 4A: Which counties have the most total awarded dollars?
--     Show county, contract_count, total_bid_amount.


-- 4B: Which work_type categories have the highest average contract size?


-- 4C: For each contractor, identify the county where they have
--     won the most total bid_amount.
--     (Hint: aggregate by contractor + county, then rank)


-- ============================================================
-- PART 5: Final Deliverables
-- ============================================================

-- Deliverable 1:
-- A final contractor leaderboard with at least these columns:
-- contractor_name, contract_count, total_bid_amount,
-- avg_bid_amount, avg_bid_vs_estimate_pct, statewide_rank.

-- Deliverable 2:
-- A "largest contracts" output with:
-- contractor_name, project_id, county, work_type, award_date, bid_amount.

-- Deliverable 3:
-- A short written summary answering:
-- - Who are the biggest contractors by awarded dollars?
-- - Are bids usually above or below estimate?
-- - Which counties and work types dominate spending?


-- ============================================================
-- Stretch Goals
-- ============================================================

-- Stretch 1: Compare bid_amount vs final_cost to see which
-- contractors tend to grow after award.

-- Stretch 2: Segment contractors into small / medium / large
-- using CASE on total awarded dollars.

-- Stretch 3: Turn your final contractor leaderboard into a view.
