-- ============================================================
-- Exercise 1.1: SELECT Basics
-- ============================================================
-- These exercises use the 'bridges' table.
-- Run each query one at a time and study the results.
--
-- TIP: In pgAdmin, highlight a single query and press F5
--      to run just that selection.
-- ============================================================


-- ----- EXAMPLES (run these first to see how they work) -----

-- Select all columns from bridges (LIMIT to avoid huge results)
SELECT *
FROM bridges
LIMIT 10;

-- Select specific columns
SELECT structure_number, facility_carried, county, year_built
FROM bridges
LIMIT 10;


-- ----- YOUR TURN -----

-- Q1: Select the structure_number, owner, and year_built for all bridges.
--     (Limit to 20 rows)


-- Q2: Select ALL columns for bridges, but only show 5 rows.


-- Q3: Select the facility_carried and features_intersected columns.
--     These tell you what road the bridge carries and what it crosses over.
--     Limit to 15 rows.


-- Q4: Use SELECT DISTINCT to find all unique values in the "owner" column.
--     How many different types of bridge owners are there?


-- Q5: Use SELECT DISTINCT on the "deck_condition" column.
--     What rating scale is used?


-- ============================================================
-- BONUS: Column Aliases
-- ============================================================

-- You can rename columns in your output using AS:
SELECT
    structure_number AS bridge_id,
    facility_carried AS road_name,
    year_built AS construction_year
FROM bridges
LIMIT 5;

-- Q6: Select county, facility_carried, and total_length_m.
--     Rename them to "county_name", "bridge_name", and "length_meters".
--     Limit to 10 rows.

