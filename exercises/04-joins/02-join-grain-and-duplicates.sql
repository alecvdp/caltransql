-- ============================================================
-- Exercise 4.2: Join Grain and Duplicate Rows
-- ============================================================
-- These exercises use the 'bridges', 'construction_projects',
-- and 'contracts' tables.
--
-- Important idea:
-- Joining on county is convenient, but it is NOT a precise
-- bridge-to-project relationship. One county can have many
-- bridges and many projects, which multiplies rows.
-- ============================================================


-- ----- EXAMPLES -----

-- Raw county join: many-to-many at the county level
SELECT
    b.county,
    b.structure_number,
    p.project_id
FROM bridges b
JOIN construction_projects p
    ON b.county = p.county
LIMIT 20;

-- Safer pattern: aggregate first, then join summaries
WITH bridge_counts AS (
    SELECT county, COUNT(*) AS bridge_count
    FROM bridges
    GROUP BY county
),
project_counts AS (
    SELECT county, COUNT(*) AS project_count
    FROM construction_projects
    GROUP BY county
)
SELECT
    bc.county,
    bc.bridge_count,
    COALESCE(pc.project_count, 0) AS project_count
FROM bridge_counts bc
LEFT JOIN project_counts pc
    ON bc.county = pc.county
ORDER BY bc.bridge_count DESC;


-- ----- YOUR TURN -----

-- Q1: Count the number of rows produced by a raw join between
--     bridges and construction_projects on county.
--     Compare it with the number of rows in each source table.


-- Q2: Find the counties that produce the most rows in that raw join.
--     Show county plus the joined row count.


-- Q3: Build a county-level summary that shows:
--     - bridge_count
--     - project_count
--     - total_project_cost
--     Use pre-aggregated CTEs before joining.


-- ============================================================
-- LEFT JOIN and missing matches
-- ============================================================

-- Q4: Find counties that have bridges but no construction projects.
--     Return county and bridge_count.


-- Q5: Find counties that have construction projects but no contracts.
--     (Hint: LEFT JOIN contracts to construction_projects)


-- ============================================================
-- Joining at the right grain
-- ============================================================

-- Q6: Join construction_projects to contracts on project_id.
--     Show one row per contract with:
--     project_id, county, work_type, contractor_name, bid_amount.
--     Order by bid_amount descending.


-- Q7: For each county, compare:
--     - number of projects
--     - number of contracts
--     - average contracts per project
--     Use aggregated project and contract data.


-- ============================================================
-- Challenge
-- ============================================================

-- Q8: Create a county "delivery snapshot" with:
--     - bridge_count
--     - project_count
--     - contract_count
--     - total_bid_amount
--     - average_bid_amount
--     Order by total_bid_amount descending.
--     Use multiple CTEs and be careful to avoid duplicate inflation.
