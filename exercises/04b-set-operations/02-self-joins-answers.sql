-- Answer Key for Exercise 4b.2: Self-Joins

-- Q1
SELECT
    a.structure_number  AS bridge_a,
    b.structure_number  AS bridge_b,
    a.county,
    a.deck_condition    AS deck_condition_a,
    b.deck_condition    AS deck_condition_b
FROM bridges a
JOIN bridges b
    ON  a.county           = b.county
    AND a.structure_number < b.structure_number
WHERE a.deck_condition <= 4
  AND b.deck_condition <= 4
ORDER BY a.county, a.structure_number;
-- Expected output (first 5 rows, illustrative):
-- bridge_a | bridge_b | county      | deck_condition_a | deck_condition_b
-- ---------+----------+-------------+------------------+-----------------
-- Sample A | Sample A | LOS ANGELES | 10               | 10              
-- Sample B | Sample B | SAN DIEGO   | 25               | 25              
-- Sample C | Sample C | SACRAMENTO  | 42               | 42              
-- ...


-- Q2
SELECT
    a.structure_number              AS older_bridge,
    b.structure_number              AS newer_bridge,
    a.facility_carried,
    a.county,
    a.year_built                    AS year_built_a,
    b.year_built                    AS year_built_b,
    b.year_built - a.year_built     AS year_diff
FROM bridges a
JOIN bridges b
    ON  a.county           = b.county
    AND a.facility_carried = b.facility_carried
    AND b.year_built - a.year_built >= 30
WHERE a.facility_carried IS NOT NULL
ORDER BY year_diff DESC;
-- Expected output (first 5 rows, illustrative):
-- older_bridge | newer_bridge | facility_carried | county      | year_built_a | year_built_b | year_diff
-- -------------+--------------+------------------+-------------+--------------+--------------+----------
-- Sample A     | Sample A     | Sample A         | LOS ANGELES | 1950         | 1950         | 1950     
-- Sample B     | Sample B     | Sample B         | SAN DIEGO   | 1965         | 1965         | 1965     
-- Sample C     | Sample C     | Sample C         | SACRAMENTO  | 1980         | 1980         | 1980     
-- ...


-- Q3
SELECT
    a.structure_number                          AS bridge_a,
    b.structure_number                          AS bridge_b,
    a.county,
    a.features_intersected,
    a.deck_condition                            AS deck_condition_a,
    b.deck_condition                            AS deck_condition_b,
    ABS(a.deck_condition - b.deck_condition)    AS condition_gap
FROM bridges a
JOIN bridges b
    ON  a.county               = b.county
    AND a.features_intersected = b.features_intersected
    AND a.structure_number     < b.structure_number
WHERE a.features_intersected IS NOT NULL
  AND a.deck_condition IS NOT NULL
  AND b.deck_condition IS NOT NULL
  AND ABS(a.deck_condition - b.deck_condition) >= 3
ORDER BY condition_gap DESC;
-- Expected output (first 5 rows, illustrative):
-- bridge_a | bridge_b | county      | features_intersected | deck_condition_a | deck_condition_b | condition_gap
-- ---------+----------+-------------+----------------------+------------------+------------------+--------------
-- Sample A | Sample A | LOS ANGELES | Sample A             | 10               | 10               | 10           
-- Sample B | Sample B | SAN DIEGO   | Sample B             | 25               | 25               | 25           
-- Sample C | Sample C | SACRAMENTO  | Sample C             | 42               | 42               | 42           
-- ...


-- Q4
SELECT
    a.structure_number          AS older_bridge,
    b.structure_number          AS newer_bridge,
    a.facility_carried,
    a.county,
    a.year_built                AS year_built_older,
    b.year_built                AS year_built_newer,
    a.deck_condition            AS older_deck_condition
FROM bridges a
JOIN bridges b
    ON  a.county           = b.county
    AND a.facility_carried = b.facility_carried
    AND b.year_built - a.year_built >= 20
WHERE a.facility_carried IS NOT NULL
  AND a.deck_condition <= 5
ORDER BY a.year_built ASC;
-- Expected output (first 5 rows, illustrative):
-- older_bridge | newer_bridge | facility_carried | county      | year_built_older | year_built_newer | older_deck_condition
-- -------------+--------------+------------------+-------------+------------------+------------------+---------------------
-- Sample A     | Sample A     | Sample A         | LOS ANGELES | 1950             | 1950             | 10                  
-- Sample B     | Sample B     | Sample B         | SAN DIEGO   | 1965             | 1965             | 25                  
-- Sample C     | Sample C     | Sample C         | SACRAMENTO  | 1980             | 1980             | 42                  
-- ...


-- Q5
WITH all_pairs AS (
    SELECT
        a.county,
        a.structure_number                          AS bridge_a,
        b.structure_number                          AS bridge_b,
        a.deck_condition                            AS deck_a,
        b.deck_condition                            AS deck_b,
        ABS(a.deck_condition - b.deck_condition)    AS condition_gap
    FROM bridges a
    JOIN bridges b
        ON  a.county           = b.county
        AND a.structure_number < b.structure_number
    WHERE a.deck_condition IS NOT NULL
      AND b.deck_condition IS NOT NULL
),
ranked AS (
    SELECT
        *,
        ROW_NUMBER() OVER (PARTITION BY county ORDER BY condition_gap DESC) AS rn
    FROM all_pairs
)
SELECT county, bridge_a, bridge_b, deck_a, deck_b, condition_gap
FROM ranked
WHERE rn = 1
ORDER BY condition_gap DESC;
-- Expected output (first 5 rows, illustrative):
-- county      | bridge_a | bridge_b | deck_a   | deck_b   | condition_gap
-- ------------+----------+----------+----------+----------+--------------
-- LOS ANGELES | Sample A | Sample A | Sample A | Sample A | 10           
-- SAN DIEGO   | Sample B | Sample B | Sample B | Sample B | 25           
-- SACRAMENTO  | Sample C | Sample C | Sample C | Sample C | 42           
-- ...


-- Q6
-- A plain GROUP BY is sufficient — no self-join required.
SELECT
    facility_carried,
    county,
    COUNT(*)                                            AS bridge_count,
    MIN(deck_condition)                                 AS min_deck_condition,
    MAX(deck_condition)                                 AS max_deck_condition,
    MAX(deck_condition) - MIN(deck_condition)           AS condition_gap
FROM bridges
WHERE facility_carried IS NOT NULL
  AND deck_condition IS NOT NULL
GROUP BY facility_carried, county
HAVING COUNT(*) > 1
ORDER BY condition_gap DESC NULLS LAST;
-- Expected output (first 5 rows, illustrative):
-- facility_carried | county      | bridge_count | min_deck_condition | max_deck_condition | condition_gap
-- -----------------+-------------+--------------+--------------------+--------------------+--------------
-- Sample A         | LOS ANGELES | 10           | 10                 | 10                 | 10           
-- Sample B         | SAN DIEGO   | 25           | 25                 | 25                 | 25           
-- Sample C         | SACRAMENTO  | 42           | 42                 | 42                 | 42           
-- ...

