-- ============================================================
-- Exercise 2.3: CASE, COALESCE, and NULL Handling
-- ============================================================
-- These exercises use the 'bridges' table.
-- CASE helps you create categories; COALESCE fills in missing data.
-- ============================================================


-- ----- EXAMPLES -----

-- Group condition ratings into buckets
SELECT
    structure_number,
    county,
    deck_condition,
    CASE
        WHEN deck_condition >= 8 THEN 'Good'
        WHEN deck_condition >= 6 THEN 'Fair'
        WHEN deck_condition IS NULL THEN 'Unrated'
        ELSE 'Poor'
    END AS condition_bucket
FROM bridges
LIMIT 15;

-- Replace NULL reconstructed years with original construction year
SELECT
    structure_number,
    year_built,
    year_reconstructed,
    COALESCE(year_reconstructed, year_built) AS effective_year
FROM bridges
LIMIT 15;


-- ----- YOUR TURN -----

-- Q1: Classify each bridge into an age bucket:
--     - 'Historic' for year_built < 1940
--     - 'Mid-century' for 1940-1979
--     - 'Modern' for 1980+
--     Show structure_number, county, year_built, and the bucket.
--     Limit to 20 rows.


-- Q2: Create a traffic bucket using ADT:
--     - 'Very High' for 100000+
--     - 'High' for 50000-99999
--     - 'Moderate' for 10000-49999
--     - 'Low' for under 10000
--     - 'Unknown' when ADT is NULL
--     Limit to 25 rows.


-- Q3: Show each bridge's "effective service year" using
--     COALESCE(year_reconstructed, year_built).
--     Order by effective service year descending.
--     Limit to 20 rows.


-- Q4: Create a label called maintenance_priority:
--     - 'Urgent' if deck_condition <= 4
--     - 'Monitor' if deck_condition is 5 or 6
--     - 'Stable' if deck_condition >= 7
--     - 'Unknown' if deck_condition is NULL
--     Show 25 rows.


-- ============================================================
-- CASE inside WHERE and ORDER BY
-- ============================================================

-- Q5: Return only bridges classified as 'Urgent'
--     using the same logic as Q4.


-- Q6: Sort bridges so the highest maintenance priority appears first:
--     Urgent -> Monitor -> Stable -> Unknown.
--     (Hint: use CASE in ORDER BY)
--     Limit to 30 rows.


-- ============================================================
-- Challenge
-- ============================================================

-- Q7: Build a bridge snapshot with these derived columns:
--     - bridge_age = current data_year - year_built
--     - effective_year = COALESCE(year_reconstructed, year_built)
--     - condition_bucket from the example above
--     - traffic_bucket from Q2
--     Limit to 20 rows.
