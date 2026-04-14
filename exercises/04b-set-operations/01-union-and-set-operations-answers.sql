-- Answer Key for Exercise 4b.1: UNION, INTERSECT, and EXCEPT

-- Q1
SELECT
    structure_number,
    county,
    facility_carried,
    deck_condition          AS condition_rating,
    'deck'                  AS condition_type
FROM bridges
WHERE deck_condition <= 4

UNION ALL

SELECT
    structure_number,
    county,
    facility_carried,
    superstructure_condition,
    'superstructure'
FROM bridges
WHERE superstructure_condition <= 4

UNION ALL

SELECT
    structure_number,
    county,
    facility_carried,
    substructure_condition,
    'substructure'
FROM bridges
WHERE substructure_condition <= 4

ORDER BY county, condition_type;
-- Expected output (first 5 rows, illustrative):
-- structure_number | county      | facility_carried | condition_rating | condition_type
-- -----------------+-------------+------------------+------------------+---------------
-- ID-1000          | LOS ANGELES | Sample A         | 10               | 10            
-- ID-1001          | SAN DIEGO   | Sample B         | 25               | 25            
-- ID-1002          | SACRAMENTO  | Sample C         | 42               | 42            
-- ...


-- Q2
WITH deficiency_register AS (
    SELECT
        structure_number,
        county,
        facility_carried,
        deck_condition          AS condition_rating,
        'deck'                  AS condition_type
    FROM bridges
    WHERE deck_condition <= 4

    UNION ALL

    SELECT
        structure_number,
        county,
        facility_carried,
        superstructure_condition,
        'superstructure'
    FROM bridges
    WHERE superstructure_condition <= 4

    UNION ALL

    SELECT
        structure_number,
        county,
        facility_carried,
        substructure_condition,
        'substructure'
    FROM bridges
    WHERE substructure_condition <= 4
)
SELECT
    county,
    condition_type,
    COUNT(*) AS deficiency_count
FROM deficiency_register
GROUP BY county, condition_type
ORDER BY deficiency_count DESC;
-- Expected output (first 5 rows, illustrative):
-- county      | condition_type | deficiency_count
-- ------------+----------------+-----------------
-- LOS ANGELES | 10             | 10              
-- SAN DIEGO   | 25             | 25              
-- SACRAMENTO  | 42             | 42              
-- ...


-- Q3
SELECT COUNT(*) AS total_distinct_counties
FROM (
    SELECT county FROM bridges
    UNION
    SELECT county FROM construction_projects
) AS all_counties;
-- Expected output (first 5 rows, illustrative):
-- total_distinct_counties
-- -----------------------
-- 10                     
-- 25                     
-- 42                     
-- ...


-- Q4
SELECT county
FROM bridges
INTERSECT
SELECT county
FROM construction_projects
ORDER BY county;
-- Expected output (first 5 rows, illustrative):
-- county     
-- -----------
-- LOS ANGELES
-- SAN DIEGO  
-- SACRAMENTO 
-- ...


-- Q5
SELECT county
FROM bridges
EXCEPT
SELECT county
FROM construction_projects
ORDER BY county;
-- Expected output (first 5 rows, illustrative):
-- county     
-- -----------
-- LOS ANGELES
-- SAN DIEGO  
-- SACRAMENTO 
-- ...


-- Q6
SELECT county
FROM construction_projects
EXCEPT
SELECT county
FROM bridges
ORDER BY county;
-- Expected output (first 5 rows, illustrative):
-- county     
-- -----------
-- LOS ANGELES
-- SAN DIEGO  
-- SACRAMENTO 
-- ...


-- Q7
WITH bridge_counties AS (
    SELECT DISTINCT county FROM bridges
),
project_counties AS (
    SELECT DISTINCT county FROM construction_projects
),
both_counties AS (
    SELECT county FROM bridges
    INTERSECT
    SELECT county FROM construction_projects
),
all_counties AS (
    SELECT county FROM bridges
    UNION
    SELECT county FROM construction_projects
)
SELECT
    a.county,
    CASE WHEN bc.county IS NOT NULL THEN TRUE ELSE FALSE END AS has_bridges,
    CASE WHEN pc.county IS NOT NULL THEN TRUE ELSE FALSE END AS has_projects,
    CASE WHEN bo.county IS NOT NULL THEN TRUE ELSE FALSE END AS has_both
FROM all_counties a
LEFT JOIN bridge_counties  bc ON a.county = bc.county
LEFT JOIN project_counties pc ON a.county = pc.county
LEFT JOIN both_counties    bo ON a.county = bo.county
ORDER BY a.county;
-- Expected output (first 5 rows, illustrative):
-- county      | has_bridges | has_projects | has_both
-- ------------+-------------+--------------+---------
-- LOS ANGELES | Sample A    | Sample A     | Sample A
-- SAN DIEGO   | Sample B    | Sample B     | Sample B
-- SACRAMENTO  | Sample C    | Sample C     | Sample C
-- ...

