-- Sample Answer Key for Practice Project: California Bridge Report Card
-- These are representative solutions, not the only correct ones.

-- 1A: total bridges
SELECT COUNT(*) AS total_bridges
FROM bridges;
-- Expected output (first 5 rows, illustrative):
-- total_bridges
-- -------------
-- 10           
-- 25           
-- 42           
-- ...


-- 1B: owner breakdown with percentages
SELECT
    owner,
    COUNT(*) AS bridge_count,
    ROUND(100.0 * COUNT(*) / SUM(COUNT(*)) OVER (), 2) AS pct_of_total
FROM bridges
GROUP BY owner
ORDER BY bridge_count DESC;
-- Expected output (first 5 rows, illustrative):
-- owner                            | bridge_count | pct_of_total
-- ---------------------------------+--------------+-------------
-- State Highway Agency             | 10           | 10          
-- County Highway Agency            | 25           | 25          
-- City or Municipal Highway Agency | 42           | 42          
-- ...


-- 1C: bridges by decade
SELECT
    (year_built / 10) * 10 AS built_decade,
    COUNT(*) AS bridge_count
FROM bridges
WHERE year_built IS NOT NULL
GROUP BY built_decade
ORDER BY bridge_count DESC;
-- Expected output (first 5 rows, illustrative):
-- built_decade | bridge_count
-- -------------+-------------
-- 10           | 10          
-- 25           | 25          
-- 42           | 42          
-- ...


-- 2A: deck condition distribution
SELECT
    deck_condition,
    COUNT(*) AS bridge_count,
    ROUND(100.0 * COUNT(*) / SUM(COUNT(*)) OVER (), 2) AS pct_of_total
FROM bridges
GROUP BY deck_condition
ORDER BY deck_condition;
-- Expected output (first 5 rows, illustrative):
-- deck_condition | bridge_count | pct_of_total
-- ---------------+--------------+-------------
-- 10             | 10           | 10          
-- 25             | 25           | 25          
-- 42             | 42           | 42          
-- ...


-- 2B: counties with lowest average deck condition
SELECT
    county,
    AVG(deck_condition) AS avg_deck_condition
FROM bridges
GROUP BY county
ORDER BY avg_deck_condition ASC NULLS LAST
LIMIT 10;
-- Expected output (first 5 rows, illustrative):
-- county      | avg_deck_condition
-- ------------+-------------------
-- LOS ANGELES | 10                
-- SAN DIEGO   | 25                
-- SACRAMENTO  | 42                
-- ...


-- 2C: condition by decade built
SELECT
    (year_built / 10) * 10 AS built_decade,
    COUNT(*) AS bridge_count,
    AVG(deck_condition) AS avg_deck_condition
FROM bridges
WHERE year_built IS NOT NULL
GROUP BY built_decade
ORDER BY built_decade;
-- Expected output (first 5 rows, illustrative):
-- built_decade | bridge_count | avg_deck_condition
-- -------------+--------------+-------------------
-- 10           | 10           | 10                
-- 25           | 25           | 25                
-- 42           | 42           | 42                
-- ...


-- 3A: 10 oldest bridges
SELECT
    structure_number,
    county,
    facility_carried,
    features_intersected,
    year_built,
    deck_condition
FROM bridges
ORDER BY year_built ASC NULLS LAST
LIMIT 10;
-- Expected output (first 5 rows, illustrative):
-- structure_number | county      | facility_carried | features_intersected | year_built | deck_condition
-- -----------------+-------------+------------------+----------------------+------------+---------------
-- ID-1000          | LOS ANGELES | Sample A         | Sample A             | 1950       | 10            
-- ID-1001          | SAN DIEGO   | Sample B         | Sample B             | 1965       | 25            
-- ID-1002          | SACRAMENTO  | Sample C         | Sample C             | 1980       | 42            
-- ...


-- 3B: 10 longest bridges
SELECT
    county,
    facility_carried,
    total_length_m
FROM bridges
ORDER BY total_length_m DESC NULLS LAST
LIMIT 10;
-- Expected output (first 5 rows, illustrative):
-- county      | facility_carried | total_length_m
-- ------------+------------------+---------------
-- LOS ANGELES | Sample A         | 10            
-- SAN DIEGO   | Sample B         | 25            
-- SACRAMENTO  | Sample C         | 42            
-- ...


-- 3C: oldest bridge per county
WITH ranked_bridges AS (
    SELECT
        county,
        structure_number,
        facility_carried,
        year_built,
        deck_condition,
        ROW_NUMBER() OVER (
            PARTITION BY county
            ORDER BY year_built ASC NULLS LAST
        ) AS age_rank
    FROM bridges
)
SELECT county, structure_number, facility_carried, year_built, deck_condition
FROM ranked_bridges
WHERE age_rank = 1
ORDER BY county;
-- Expected output (first 5 rows, illustrative):
-- county      | structure_number | facility_carried | year_built | deck_condition
-- ------------+------------------+------------------+------------+---------------
-- LOS ANGELES | ID-1000          | Sample A         | 1950       | 10            
-- SAN DIEGO   | ID-1001          | Sample B         | 1965       | 25            
-- SACRAMENTO  | ID-1002          | Sample C         | 1980       | 42            
-- ...


-- 4A: project counts compared with bridge counts
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
ORDER BY project_count DESC, bridge_count DESC;
-- Expected output (first 5 rows, illustrative):
-- county      | bridge_count | project_count
-- ------------+--------------+--------------
-- LOS ANGELES | 10           | 10           
-- SAN DIEGO   | 25           | 25           
-- SACRAMENTO  | 42           | 42           
-- ...


-- 4B: total and average project cost per county
SELECT
    county,
    COUNT(*) AS project_count,
    SUM(total_cost) AS total_project_cost,
    AVG(total_cost) AS avg_project_cost
FROM construction_projects
GROUP BY county
ORDER BY total_project_cost DESC NULLS LAST;
-- Expected output (first 5 rows, illustrative):
-- county      | project_count | total_project_cost | avg_project_cost
-- ------------+---------------+--------------------+-----------------
-- LOS ANGELES | 10            | 10                 | 10              
-- SAN DIEGO   | 25            | 25                 | 25              
-- SACRAMENTO  | 42            | 42                 | 42              
-- ...


-- 4C: top 10 most expensive projects
SELECT
    project_id,
    county,
    work_type,
    project_description,
    total_cost
FROM construction_projects
ORDER BY total_cost DESC NULLS LAST
LIMIT 10;
-- Expected output (first 5 rows, illustrative):
-- project_id | county      | work_type               | project_description | total_cost
-- -----------+-------------+-------------------------+---------------------+-----------
-- ID-1000    | LOS ANGELES | Pavement Rehabilitation | ID-1000             | 10        
-- ID-1001    | SAN DIEGO   | Bridge Repair           | ID-1001             | 25        
-- ID-1002    | SACRAMENTO  | Safety Improvement      | ID-1002             | 42        
-- ...


-- Part 5 sample question 1:
-- Which counties have the oldest bridge stock on average?
SELECT
    county,
    COUNT(*) AS bridge_count,
    AVG(year_built) AS avg_year_built
FROM bridges
GROUP BY county
HAVING COUNT(*) >= 50
ORDER BY avg_year_built ASC;
-- Expected output (first 5 rows, illustrative):
-- county      | bridge_count | avg_year_built
-- ------------+--------------+---------------
-- LOS ANGELES | 10           | 1950          
-- SAN DIEGO   | 25           | 1965          
-- SACRAMENTO  | 42           | 1980          
-- ...


-- Part 5 sample question 2:
-- Which owners manage the most poor-condition bridges?
SELECT
    owner,
    COUNT(*) AS poor_condition_bridge_count
FROM bridges
WHERE deck_condition <= 4
GROUP BY owner
ORDER BY poor_condition_bridge_count DESC;
-- Expected output (first 5 rows, illustrative):
-- owner                            | poor_condition_bridge_count
-- ---------------------------------+----------------------------
-- State Highway Agency             | 10                         
-- County Highway Agency            | 25                         
-- City or Municipal Highway Agency | 42                         
-- ...


-- Part 5 sample question 3:
-- Which counties combine low deck condition with heavy traffic?
SELECT
    county,
    AVG(deck_condition) AS avg_deck_condition,
    AVG(adt) AS avg_adt
FROM bridges
GROUP BY county
HAVING AVG(deck_condition) IS NOT NULL
ORDER BY avg_deck_condition ASC, avg_adt DESC NULLS LAST;
-- Expected output (first 5 rows, illustrative):
-- county      | avg_deck_condition | avg_adt
-- ------------+--------------------+--------
-- LOS ANGELES | 10                 | 10     
-- SAN DIEGO   | 25                 | 25     
-- SACRAMENTO  | 42                 | 42     
-- ...

