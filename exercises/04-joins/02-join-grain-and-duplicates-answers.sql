-- Answer Key for Exercise 4.2: Join Grain and Duplicate Rows

-- Q1
SELECT COUNT(*) AS bridge_rows FROM bridges;
-- Expected output (first 5 rows, illustrative):
-- bridge_rows
-- -----------
-- Sample A   
-- Sample B   
-- Sample C   
-- ...

SELECT COUNT(*) AS project_rows FROM construction_projects;
-- Expected output (first 5 rows, illustrative):
-- project_rows
-- ------------
-- ID-1000     
-- ID-1001     
-- ID-1002     
-- ...

SELECT COUNT(*) AS joined_rows
FROM bridges b
JOIN construction_projects p
    ON b.county = p.county;
-- Expected output (first 5 rows, illustrative):
-- joined_rows
-- -----------
-- Sample A   
-- Sample B   
-- Sample C   
-- ...


-- Q2
SELECT
    b.county,
    COUNT(*) AS joined_row_count
FROM bridges b
JOIN construction_projects p
    ON b.county = p.county
GROUP BY b.county
ORDER BY joined_row_count DESC;
-- Expected output (first 5 rows, illustrative):
-- county      | joined_row_count
-- ------------+-----------------
-- LOS ANGELES | 10              
-- SAN DIEGO   | 25              
-- SACRAMENTO  | 42              
-- ...


-- Q3
WITH bridge_counts AS (
    SELECT county, COUNT(*) AS bridge_count
    FROM bridges
    GROUP BY county
),
project_summary AS (
    SELECT county, COUNT(*) AS project_count, SUM(total_cost) AS total_project_cost
    FROM construction_projects
    GROUP BY county
)
SELECT
    bc.county,
    bc.bridge_count,
    COALESCE(ps.project_count, 0) AS project_count,
    COALESCE(ps.total_project_cost, 0) AS total_project_cost
FROM bridge_counts bc
LEFT JOIN project_summary ps
    ON bc.county = ps.county
ORDER BY bc.bridge_count DESC;
-- Expected output (first 5 rows, illustrative):
-- county      | bridge_count | project_count | total_project_cost
-- ------------+--------------+---------------+-------------------
-- LOS ANGELES | 10           | 10            | 10                
-- SAN DIEGO   | 25           | 25            | 25                
-- SACRAMENTO  | 42           | 42            | 42                
-- ...


-- Q4
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
SELECT bc.county, bc.bridge_count
FROM bridge_counts bc
LEFT JOIN project_counts pc
    ON bc.county = pc.county
WHERE pc.county IS NULL
ORDER BY bc.bridge_count DESC;
-- Expected output (first 5 rows, illustrative):
-- county      | bridge_count
-- ------------+-------------
-- LOS ANGELES | 10          
-- SAN DIEGO   | 25          
-- SACRAMENTO  | 42          
-- ...


-- Q5
SELECT
    p.county,
    COUNT(*) AS project_count_without_contracts
FROM construction_projects p
LEFT JOIN contracts c
    ON p.project_id = c.project_id
WHERE c.project_id IS NULL
GROUP BY p.county
ORDER BY project_count_without_contracts DESC;
-- Expected output (first 5 rows, illustrative):
-- county      | project_count_without_contracts
-- ------------+--------------------------------
-- LOS ANGELES | 10                             
-- SAN DIEGO   | 25                             
-- SACRAMENTO  | 42                             
-- ...


-- Q6
SELECT
    p.project_id,
    p.county,
    p.work_type,
    c.contractor_name,
    c.bid_amount
FROM construction_projects p
JOIN contracts c
    ON p.project_id = c.project_id
ORDER BY c.bid_amount DESC NULLS LAST;
-- Expected output (first 5 rows, illustrative):
-- project_id | county      | work_type               | contractor_name | bid_amount
-- -----------+-------------+-------------------------+-----------------+-----------
-- ID-1000    | LOS ANGELES | Pavement Rehabilitation | Sample A        | 10        
-- ID-1001    | SAN DIEGO   | Bridge Repair           | Sample B        | 25        
-- ID-1002    | SACRAMENTO  | Safety Improvement      | Sample C        | 42        
-- ...


-- Q7
WITH project_counts AS (
    SELECT county, COUNT(*) AS project_count
    FROM construction_projects
    GROUP BY county
),
contract_counts AS (
    SELECT p.county, COUNT(*) AS contract_count
    FROM construction_projects p
    JOIN contracts c
        ON p.project_id = c.project_id
    GROUP BY p.county
)
SELECT
    pc.county,
    pc.project_count,
    COALESCE(cc.contract_count, 0) AS contract_count,
    ROUND(
        COALESCE(cc.contract_count, 0)::NUMERIC / NULLIF(pc.project_count, 0),
        2
    ) AS avg_contracts_per_project
FROM project_counts pc
LEFT JOIN contract_counts cc
    ON pc.county = cc.county
ORDER BY avg_contracts_per_project DESC NULLS LAST;
-- Expected output (first 5 rows, illustrative):
-- county      | project_count | contract_count | avg_contracts_per_project
-- ------------+---------------+----------------+--------------------------
-- LOS ANGELES | 10            | 10             | 10                       
-- SAN DIEGO   | 25            | 25             | 25                       
-- SACRAMENTO  | 42            | 42             | 42                       
-- ...


-- Q8
WITH bridge_counts AS (
    SELECT county, COUNT(*) AS bridge_count
    FROM bridges
    GROUP BY county
),
project_counts AS (
    SELECT county, COUNT(*) AS project_count
    FROM construction_projects
    GROUP BY county
),
contract_summary AS (
    SELECT
        p.county,
        COUNT(*) AS contract_count,
        SUM(c.bid_amount) AS total_bid_amount,
        AVG(c.bid_amount) AS average_bid_amount
    FROM construction_projects p
    JOIN contracts c
        ON p.project_id = c.project_id
    GROUP BY p.county
)
SELECT
    bc.county,
    bc.bridge_count,
    COALESCE(pc.project_count, 0) AS project_count,
    COALESCE(cs.contract_count, 0) AS contract_count,
    COALESCE(cs.total_bid_amount, 0) AS total_bid_amount,
    cs.average_bid_amount
FROM bridge_counts bc
LEFT JOIN project_counts pc
    ON bc.county = pc.county
LEFT JOIN contract_summary cs
    ON bc.county = cs.county
ORDER BY total_bid_amount DESC;
-- Expected output (first 5 rows, illustrative):
-- county      | bridge_count | project_count | contract_count | total_bid_amount | average_bid_amount
-- ------------+--------------+---------------+----------------+------------------+-------------------
-- LOS ANGELES | 10           | 10            | 10             | 10               | 10                
-- SAN DIEGO   | 25           | 25            | 25             | 25               | 25                
-- SACRAMENTO  | 42           | 42            | 42             | 42               | 42                
-- ...

