-- Answer Key for Exercise 7.1: Common Table Expressions

-- Q1
WITH long_bridges AS (
    SELECT structure_number, county, total_length_m
    FROM bridges
    WHERE total_length_m > 500
)
SELECT county, COUNT(*) AS long_bridge_count
FROM long_bridges
GROUP BY county
ORDER BY long_bridge_count DESC;
-- Expected output (first 5 rows, illustrative):
-- county      | long_bridge_count
-- ------------+------------------
-- LOS ANGELES | 10               
-- SAN DIEGO   | 25               
-- SACRAMENTO  | 42               
-- ...


-- Q2
WITH county_deck_avg AS (
    SELECT county, AVG(deck_condition) AS avg_deck_condition
    FROM bridges
    GROUP BY county
)
SELECT *
FROM county_deck_avg
WHERE avg_deck_condition < 6
ORDER BY avg_deck_condition;
-- Expected output (first 5 rows, illustrative):
-- *             
-- --------------
-- <many columns>
-- <many columns>
-- <many columns>
-- ...


-- Q3
WITH bridge_counts AS (
    SELECT county, COUNT(*) AS bridge_count
    FROM bridges
    GROUP BY county
),
project_counts AS (
    SELECT county, COUNT(*) AS project_count
    FROM construction_projects
    GROUP BY county
)
SELECT
    bc.county,
    bc.bridge_count,
    COALESCE(pc.project_count, 0) AS project_count
FROM bridge_counts bc
LEFT JOIN project_counts pc
    ON bc.county = pc.county
ORDER BY bc.bridge_count DESC;
-- Expected output (first 5 rows, illustrative):
-- county      | bridge_count | project_count
-- ------------+--------------+--------------
-- LOS ANGELES | 10           | 10           
-- SAN DIEGO   | 25           | 25           
-- SACRAMENTO  | 42           | 42           
-- ...


-- Q4
WITH ranked_bridges AS (
    SELECT
        structure_number,
        county,
        facility_carried,
        total_length_m,
        ROW_NUMBER() OVER (
            PARTITION BY county
            ORDER BY total_length_m DESC NULLS LAST
        ) AS length_rank
    FROM bridges
)
SELECT *
FROM ranked_bridges
WHERE length_rank = 1
ORDER BY county;
-- Expected output (first 5 rows, illustrative):
-- *             
-- --------------
-- <many columns>
-- <many columns>
-- <many columns>
-- ...


-- Q5
WITH statewide_avg AS (
    SELECT AVG(deck_condition) AS statewide_deck_avg
    FROM bridges
),
county_avgs AS (
    SELECT county, AVG(deck_condition) AS county_deck_avg
    FROM bridges
    GROUP BY county
)
SELECT b.*
FROM bridges b
JOIN county_avgs c
    ON b.county = c.county
CROSS JOIN statewide_avg s
WHERE c.county_deck_avg < s.statewide_deck_avg;
-- Expected output (first 5 rows, illustrative):
-- *             
-- --------------
-- <many columns>
-- <many columns>
-- <many columns>
-- ...

