-- ============================================================
-- Exercise 3.1: Aggregate Functions & GROUP BY
-- ============================================================
-- Aggregate functions: COUNT, SUM, AVG, MIN, MAX
-- These exercises use the 'bridges' table.
-- ============================================================


-- ----- EXAMPLES -----

-- COUNT all rows
SELECT COUNT(*) AS total_bridges
FROM bridges;

-- COUNT with a filter
SELECT COUNT(*) AS la_bridges
FROM bridges
WHERE county = 'LOS ANGELES';

-- GROUP BY to count per category
SELECT county, COUNT(*) AS bridge_count
FROM bridges
GROUP BY county
ORDER BY bridge_count DESC;


-- ----- YOUR TURN -----

-- Q1: How many total bridges are in the dataset?


-- Q2: What is the oldest bridge? (MIN year_built)
--     What is the newest? (MAX year_built)


-- Q3: What is the average year_built across all bridges?


-- Q4: Count how many bridges each owner type has.
--     Order by count descending.


-- Q5: For each county, find:
--     - the number of bridges
--     - the oldest bridge (min year_built)
--     - the newest bridge (max year_built)
--     - the average year_built
--     Order by number of bridges descending.


-- Q6: Find the average total_length_m by county.
--     Which county has the longest bridges on average?
--     Order by average length descending.


-- ============================================================
-- HAVING - filter AFTER aggregation
-- ============================================================

-- HAVING is like WHERE, but for aggregated results.

-- Example: Counties with more than 500 bridges
SELECT county, COUNT(*) AS bridge_count
FROM bridges
GROUP BY county
HAVING COUNT(*) > 500
ORDER BY bridge_count DESC;

-- Q7: Find all owners that are responsible for more than 1000 bridges.


-- Q8: Find counties where the average year_built is before 1960.
--     These counties have the oldest bridge infrastructure.


-- Q9: Find counties where the average deck_condition is below 6.
--     Which counties might have the most maintenance needs?

