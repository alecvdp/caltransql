-- ============================================================
-- Exercise 5.1: Subqueries
-- ============================================================
-- A subquery is a query nested inside another query.
-- These exercises use the 'bridges' and 'contracts' tables.
-- ============================================================


-- ----- EXAMPLES -----

-- Subquery in WHERE (scalar - returns one value)
SELECT structure_number, facility_carried, year_built
FROM bridges
WHERE year_built = (SELECT MIN(year_built) FROM bridges);
-- ^ Finds the oldest bridge(s)

-- Subquery in WHERE (list - returns multiple values)
SELECT structure_number, facility_carried, county
FROM bridges
WHERE county IN (
    SELECT county
    FROM bridges
    GROUP BY county
    HAVING COUNT(*) > 1000
);
-- ^ Bridges in counties that have more than 1000 bridges


-- ----- YOUR TURN -----

-- Q1: Find the bridge(s) with the maximum total_length_m.
--     (Use a subquery to find the max, then filter)


-- Q2: Find all bridges that are older than the average year_built.


-- Q3: Find bridges in counties where the average deck_condition
--     is below 6. (Subquery to find those counties, then filter)


-- Q4: Find contractors who have won contracts above the overall
--     average bid_amount.


-- ============================================================
-- Correlated Subqueries
-- ============================================================
-- A correlated subquery references the outer query.
-- It runs once per row of the outer query.

-- Example: Find bridges that are older than the average
-- for their specific county.
SELECT b.structure_number, b.facility_carried, b.county, b.year_built
FROM bridges b
WHERE b.year_built < (
    SELECT AVG(b2.year_built)
    FROM bridges b2
    WHERE b2.county = b.county
)
LIMIT 20;

-- Q5: Find bridges whose total_length_m is greater than the
--     average total_length_m in their county.


-- Q6: Find contracts where the bid_amount is the highest
--     for that specific contractor.
--     (Each row = a contractor's biggest contract)


-- ============================================================
-- Subqueries in SELECT and FROM
-- ============================================================

-- Q7: For each bridge, show its year_built and the average
--     year_built for its county (as a subquery in SELECT).
--     Also show the difference.
--     Limit to 20 rows.

