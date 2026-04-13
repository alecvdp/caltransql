-- ============================================================
-- Exercise 4b.2: Self-Joins
-- ============================================================
-- A self-join joins a table to itself. This lets you compare
-- rows within the same table — for example:
--   • bridges on the same route
--   • bridges crossing the same feature
--   • bridges with large condition gaps in the same county
--
-- The trick is aliasing the table twice so the query engine
-- treats the two sides as distinct sources:
--   FROM bridges a JOIN bridges b ON <condition>
--
-- Always add a tiebreaker condition (e.g., a.structure_number < b.structure_number)
-- to avoid returning the same pair twice or a row matched with itself.
--
-- These exercises use the 'bridges' table.
-- ============================================================


-- ----- EXAMPLES -----

-- Bridges that cross the same feature (features_intersected)
-- within the same county — potential parallel or sister spans
SELECT
    a.structure_number          AS bridge_a,
    b.structure_number          AS bridge_b,
    a.county,
    a.features_intersected,
    a.year_built                AS year_built_a,
    b.year_built                AS year_built_b
FROM bridges a
JOIN bridges b
    ON  a.county               = b.county
    AND a.features_intersected = b.features_intersected
    AND a.structure_number     < b.structure_number   -- avoid duplicates & self-matches
WHERE a.features_intersected IS NOT NULL
LIMIT 20;

-- Bridges on the same route (facility_carried) within the same county
SELECT
    a.structure_number      AS bridge_a,
    b.structure_number      AS bridge_b,
    a.county,
    a.facility_carried,
    a.deck_condition        AS deck_a,
    b.deck_condition        AS deck_b
FROM bridges a
JOIN bridges b
    ON  a.county           = b.county
    AND a.facility_carried = b.facility_carried
    AND a.structure_number < b.structure_number
WHERE a.facility_carried IS NOT NULL
LIMIT 20;


-- ----- YOUR TURN -----

-- Q1: Find pairs of bridges in the same county where BOTH have
--     deck_condition rated 4 or below.
--     Show structure_number for each bridge, county,
--     and both deck_condition values.
--     Avoid duplicate pairs (a < b pattern).


-- Q2: Find pairs of bridges on the same route (facility_carried)
--     within the same county where one bridge was built at least
--     30 years after the other.
--     Show both structure numbers, facility_carried, county,
--     and both year_built values.
--     Order by the year difference descending.


-- Q3: Among bridges that cross the same feature (features_intersected)
--     in the same county, find pairs where the deck_condition
--     differs by 3 or more points.
--     Show both structure numbers, features_intersected, county,
--     and both deck_condition values.
--     This can highlight bridges that may need attention next
--     to a recently-rehabilitated neighbour.


-- ============================================================
-- Finding potential replacements
-- ============================================================

-- Q4: A newer bridge built on the same route in the same county
--     might be the replacement of an older one.
--     Find pairs where:
--       - same facility_carried and county
--       - one bridge was built 20+ years after the other
--       - the older bridge has deck_condition <= 5
--     Show both structure numbers, year_built values,
--     facility_carried, county, and older bridge deck_condition.
--     Order by older bridge year_built ascending.


-- Q5: For each county, find the pair of bridges with the
--     largest gap in deck_condition.
--     Show county, both structure numbers, and the condition gap.
--     (Hint: use a CTE with ROW_NUMBER or a subquery to keep
--     only the widest gap per county.)


-- ============================================================
-- Challenge
-- ============================================================

-- Q6: Build a "route condition summary" using a self-join.
--     For each route (facility_carried) and county combination
--     that has more than one bridge, compute:
--       - number of bridges on the route
--       - minimum deck_condition on the route
--       - maximum deck_condition on the route
--       - condition gap (max - min)
--     Order by condition gap descending.
--     (Hint: GROUP BY facility_carried, county after the self-join,
--     or simply aggregate without a self-join and think about when
--     a self-join is actually needed vs. a plain aggregation.)
