-- ============================================================
-- Exercise 2.1: WHERE Clause - Filtering Rows
-- ============================================================
-- These exercises use the 'bridges' table.
-- ============================================================


-- ----- EXAMPLES -----

-- Filter by exact match
SELECT structure_number, facility_carried, county, year_built
FROM bridges
WHERE county = 'LOS ANGELES';

-- Filter by numeric comparison
SELECT structure_number, facility_carried, year_built
FROM bridges
WHERE year_built >= 2000;


-- ----- YOUR TURN -----

-- Q1: Find all bridges in Sacramento county.


-- Q2: Find all bridges built before 1950.


-- Q3: Find all bridges where the owner is 'State Highway Agency'.


-- Q4: Find bridges with a deck_condition rating of 9 (excellent).


-- Q5: Find bridges where the total_length_m is greater than 1000.
--     What are the longest bridges in California?


-- ============================================================
-- Comparison Operators: =, <>, <, >, <=, >=
-- ============================================================

-- Q6: Find bridges that were NOT built in 2010.
--     (Use the <> operator)


-- Q7: Find bridges built between 1990 and 2000 (inclusive).
--     (Use >= and <= with AND)


-- ============================================================
-- AND, OR, NOT
-- ============================================================

-- Q8: Find bridges in 'SAN FRANCISCO' county built after 2000.


-- Q9: Find bridges owned by either 'City or Municipal Highway Agency'
--     OR 'County Highway Agency'.


-- Q10: Find bridges in 'LOS ANGELES' county with a deck_condition
--      of 7 or higher.

