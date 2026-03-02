-- ============================================================
-- Exercise 7.1: Common Table Expressions (CTEs)
-- ============================================================
-- CTEs (WITH clauses) let you create temporary named result sets.
-- They make complex queries more readable and maintainable.
--
-- These exercises use multiple tables.
-- ============================================================


-- ----- EXAMPLES -----

-- Basic CTE
WITH old_bridges AS (
    SELECT structure_number, facility_carried, county, year_built
    FROM bridges
    WHERE year_built < 1940
)
SELECT county, COUNT(*) AS old_bridge_count
FROM old_bridges
GROUP BY county
ORDER BY old_bridge_count DESC;

-- Multiple CTEs
WITH bridge_stats AS (
    SELECT
        county,
        COUNT(*) AS bridge_count,
        AVG(year_built) AS avg_year
    FROM bridges
    GROUP BY county
),
large_counties AS (
    SELECT *
    FROM bridge_stats
    WHERE bridge_count > 500
)
SELECT *
FROM large_counties
ORDER BY avg_year;


-- ----- YOUR TURN -----

-- Q1: Write a CTE called "long_bridges" that selects bridges
--     with total_length_m > 500. Then count how many there are
--     per county.


-- Q2: Write a CTE that calculates the average deck_condition
--     per county. Then find counties where the average is below 6.


-- Q3: Use two CTEs:
--     1) bridge_counts: count of bridges per county
--     2) project_counts: count of construction_projects per county
--     Then JOIN them to see counties side by side with their
--     bridge and project counts.


-- Q4: Write a CTE that ranks bridges by total_length_m within
--     each county (using ROW_NUMBER). Then select only the
--     longest bridge in each county.


-- ============================================================
-- CTEs for readability
-- ============================================================

-- Q5: Rewrite this nested query as a CTE to make it more readable:
--
-- SELECT *
-- FROM bridges
-- WHERE county IN (
--     SELECT county
--     FROM bridges
--     GROUP BY county
--     HAVING AVG(deck_condition) < (
--         SELECT AVG(deck_condition)
--         FROM bridges
--     )
-- );
--
-- Break it into:
--   1) A CTE for the statewide average
--   2) A CTE for county averages
--   3) A final SELECT joining them

