-- ============================================================
-- Exercise 2.2: LIKE, IN, BETWEEN
-- ============================================================
-- More filtering techniques using the 'bridges' table.
-- ============================================================


-- ----- EXAMPLES -----

-- LIKE with wildcards (% = any characters, _ = single character)
SELECT structure_number, facility_carried
FROM bridges
WHERE facility_carried LIKE 'INTERSTATE%';

-- IN - match against a list of values
SELECT structure_number, county, facility_carried
FROM bridges
WHERE county IN ('SAN FRANCISCO', 'ALAMEDA', 'CONTRA COSTA');

-- BETWEEN - inclusive range
SELECT structure_number, facility_carried, year_built
FROM bridges
WHERE year_built BETWEEN 1960 AND 1970;


-- ----- YOUR TURN -----

-- Q1: Find all bridges where the facility_carried starts with 'STATE'.


-- Q2: Find all bridges where the facility_carried contains the word 'CREEK'.
--     (Hint: use % on both sides)


-- Q3: Find bridges in these Bay Area counties:
--     SAN FRANCISCO, SAN MATEO, SANTA CLARA, ALAMEDA,
--     CONTRA COSTA, MARIN


-- Q4: Find bridges built between 1930 and 1940.
--     How many Depression-era bridges are still standing?


-- Q5: Find bridges where features_intersected (what the bridge
--     crosses over) contains 'RAILROAD'.


-- ============================================================
-- IS NULL / IS NOT NULL
-- ============================================================

-- NULL means "no data" - you can't use = to check for NULL!

-- Q6: Find bridges where year_reconstructed IS NOT NULL.
--     These bridges have been rebuilt at some point.


-- Q7: Find bridges where deck_condition IS NULL.
--     These bridges haven't been rated.


-- ============================================================
-- Combining it all together
-- ============================================================

-- Q8: Find bridges in Los Angeles county that were built before 1950,
--     carry a road with 'HIGHWAY' in the name, and have a
--     deck_condition of 5 or lower.
--     (These might be aging infrastructure worth investigating!)

