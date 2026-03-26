-- ============================================================
-- Exercise 1.2: ORDER BY, LIMIT, and NULL Handling
-- ============================================================
-- These exercises use the 'bridges' table.
-- Learn how to sort results and inspect top/bottom records.
-- ============================================================


-- ----- EXAMPLES -----

-- Newest bridges first
SELECT structure_number, facility_carried, county, year_built
FROM bridges
ORDER BY year_built DESC
LIMIT 10;

-- Longest bridges first
SELECT structure_number, facility_carried, total_length_m
FROM bridges
ORDER BY total_length_m DESC
LIMIT 10;

-- Sort with NULL handling
SELECT structure_number, facility_carried, year_reconstructed
FROM bridges
ORDER BY year_reconstructed DESC NULLS LAST
LIMIT 10;


-- ----- YOUR TURN -----

-- Q1: Show the 15 oldest bridges in California.
--     Include structure_number, county, facility_carried, and year_built.


-- Q2: Show the 20 bridges with the highest ADT.
--     Include adt and adt_year.


-- Q3: Find the 10 narrowest bridges by deck_width_m.
--     Put NULL values at the end of the list.


-- Q4: List bridges in LOS ANGELES county ordered by deck_condition
--     from worst to best. Break ties by year_built (oldest first).
--     Limit to 25 rows.


-- Q5: Show the 15 most recently reconstructed bridges.
--     Exclude bridges where year_reconstructed is NULL.


-- ============================================================
-- Multi-column sorting
-- ============================================================

-- Q6: Sort all bridges by county A-Z, then within each county
--     by year_built oldest to newest.
--     Limit to 30 rows.


-- Q7: Find the 20 bridges with the worst condition.
--     Sort by deck_condition ascending, then by total_length_m descending.
--     What long bridges appear near the top?


-- ============================================================
-- Challenge
-- ============================================================

-- Q8: Build a "watch list" of bridges that are both old and busy.
--     Sort by:
--       1) oldest year_built first
--       2) highest ADT first
--     Include only bridges built before 1960 with ADT above 50000.
