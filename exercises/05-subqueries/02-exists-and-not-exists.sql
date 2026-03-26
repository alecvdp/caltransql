-- ============================================================
-- Exercise 5.2: EXISTS and NOT EXISTS
-- ============================================================
-- These exercises use the 'bridges', 'construction_projects',
-- and 'contracts' tables.
-- EXISTS is often clearer than IN when you care about whether
-- a matching row exists at all.
-- ============================================================


-- ----- EXAMPLES -----

-- Counties that have at least one construction project
SELECT DISTINCT b.county
FROM bridges b
WHERE EXISTS (
    SELECT 1
    FROM construction_projects p
    WHERE p.county = b.county
)
ORDER BY b.county;

-- Projects that do not yet have a contract
SELECT p.project_id, p.county, p.project_description
FROM construction_projects p
WHERE NOT EXISTS (
    SELECT 1
    FROM contracts c
    WHERE c.project_id = p.project_id
)
LIMIT 20;


-- ----- YOUR TURN -----

-- Q1: Find bridges in counties that have at least one project
--     with total_cost greater than 100000000.
--     Limit to 25 rows.


-- Q2: Find bridges in counties that have no construction projects.
--     Return structure_number, county, and facility_carried.
--     Limit to 25 rows.


-- Q3: Find construction projects that do have at least one contract.
--     Show project_id, county, work_type, and total_cost.


-- Q4: Find contractors who have won at least one contract
--     above the overall average bid_amount.
--     Use EXISTS with a subquery against contracts.


-- ============================================================
-- Correlated existence checks
-- ============================================================

-- Q5: Find counties where there exists at least one bridge with:
--     - deck_condition <= 4
--     - AND ADT >= 50000
--     Return each county once.


-- Q6: Find projects for which there does NOT exist a contract
--     with final_cost populated.
--     (This can represent incomplete downstream data.)


-- ============================================================
-- Challenge
-- ============================================================

-- Q7: Build a county list showing whether each county has:
--     - any poor-condition bridges
--     - any projects
--     - any contracts
--     Return YES/NO flags using CASE with EXISTS.
