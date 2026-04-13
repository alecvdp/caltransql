-- ============================================================
-- Exercise 4b.1: UNION, INTERSECT, and EXCEPT
-- ============================================================
-- Set operations combine the results of two or more SELECT
-- statements into a single result set.
--
-- Rules: both queries must return the same number of columns
-- with compatible data types.
--
-- UNION      — combines results and removes duplicates
-- UNION ALL  — combines results and keeps all rows (faster)
-- INTERSECT  — rows that appear in BOTH result sets
-- EXCEPT     — rows in the first set that are NOT in the second
--
-- These exercises use the 'bridges' and 'construction_projects'
-- tables.
-- ============================================================


-- ----- EXAMPLES -----

-- UNION ALL: pool deck-deficient and substructure-deficient bridges
--   Each row is labelled by which condition triggered it.
SELECT
    structure_number,
    county,
    facility_carried,
    deck_condition      AS condition_rating,
    'deck'              AS condition_type
FROM bridges
WHERE deck_condition <= 4

UNION ALL

SELECT
    structure_number,
    county,
    facility_carried,
    substructure_condition,
    'substructure'
FROM bridges
WHERE substructure_condition <= 4

ORDER BY county, condition_rating
LIMIT 30;

-- UNION (distinct): list every county that appears in either
-- bridges or construction_projects
SELECT county FROM bridges
UNION
SELECT county FROM construction_projects
ORDER BY county;


-- ----- YOUR TURN -----

-- Q1: Build a deficiency register with UNION ALL.
--     Include bridges where deck_condition, superstructure_condition,
--     OR substructure_condition is rated 4 or below.
--     Each row should have:
--       structure_number, county, facility_carried,
--       condition_rating, condition_type ('deck' / 'superstructure' / 'substructure')
--     Order by county, condition_type.


-- Q2: Count how many deficiency entries there are per county and
--     condition_type using the UNION ALL query from Q1 as a CTE.
--     Order by deficiency count descending.


-- Q3: Use UNION to produce a single list of all distinct counties
--     that appear in either the 'bridges' table or the
--     'construction_projects' table. How many unique counties are there?


-- ============================================================
-- INTERSECT and EXCEPT
-- ============================================================

-- Q4: Use INTERSECT to find counties that appear in BOTH the
--     'bridges' table AND the 'construction_projects' table.
--     How many counties is that?


-- Q5: Use EXCEPT to find counties that have bridges but NO
--     matching rows in 'construction_projects'.
--     Order alphabetically.
--     (Compare this approach to the LEFT JOIN you used in 4.2 Q4.)


-- Q6: Use EXCEPT to find counties in 'construction_projects'
--     that have no bridges recorded in the 'bridges' table.
--     Order alphabetically.


-- ============================================================
-- Challenge
-- ============================================================

-- Q7: Build a county summary table with three flags:
--       has_bridges      (TRUE / FALSE)
--       has_projects     (TRUE / FALSE)
--       has_both         (TRUE / FALSE)
--     Use UNION, INTERSECT, or EXCEPT sets as building blocks,
--     combined with LEFT JOINs or CASE expressions.
--     Order by county.
