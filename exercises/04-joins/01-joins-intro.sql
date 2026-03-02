-- ============================================================
-- Exercise 4.1: JOINs
-- ============================================================
-- JOINs combine rows from two or more tables.
-- These exercises use the 'bridges' and 'construction_projects'
-- tables.
-- ============================================================


-- ----- EXAMPLES -----

-- INNER JOIN - only matching rows from both tables
SELECT
    b.structure_number,
    b.facility_carried,
    b.county,
    p.project_id,
    p.project_description,
    p.total_cost
FROM bridges b
INNER JOIN construction_projects p
    ON b.county = p.county
LIMIT 20;

-- LEFT JOIN - all rows from left table, matching from right
-- (NULLs where there's no match)
SELECT
    b.structure_number,
    b.facility_carried,
    b.county,
    p.project_id
FROM bridges b
LEFT JOIN construction_projects p
    ON b.county = p.county
LIMIT 20;


-- ----- YOUR TURN -----

-- Q1: Join bridges with construction_projects on county.
--     Show the bridge's facility_carried, the project_description,
--     and the total_cost. Limit to 20 rows.


-- Q2: Use a LEFT JOIN to find bridges that DON'T have any
--     construction projects in their county.
--     (Hint: WHERE p.project_id IS NULL)


-- Q3: Count how many construction projects exist per county.
--     Join with bridges to also show how many bridges each county has.
--     (Hint: you might need subqueries or multiple GROUP BYs)


-- ============================================================
-- Joining contracts table
-- ============================================================

-- Q4: Join contracts with construction_projects on project_id.
--     Show the contractor_name, project_description, bid_amount,
--     and award_date.
--     Order by bid_amount descending to see the biggest contracts.


-- Q5: Find all contracts where the bid_amount was more than 10%
--     above the engineer_estimate.
--     (Hint: bid_amount > engineer_estimate * 1.10)


-- Q6: For each contractor, find:
--     - How many contracts they've won
--     - Their total bid_amount across all contracts
--     - Their average bid_amount
--     Order by total bid_amount descending.


-- ============================================================
-- Multi-table JOINs
-- ============================================================

-- Q7: Join all three tables: bridges, construction_projects,
--     and contracts. Show a complete picture of a bridge, its
--     associated project, and the contract details.
--     Limit to 10 rows.

