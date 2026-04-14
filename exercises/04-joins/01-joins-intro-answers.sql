-- Answer Key for Exercise 4.1: JOINs

-- Q1
SELECT
    b.facility_carried,
    p.project_description,
    p.total_cost
FROM bridges b
JOIN construction_projects p
    ON b.county = p.county
LIMIT 20;
-- Expected output (first 5 rows, illustrative):
-- facility_carried | project_description | total_cost
-- -----------------+---------------------+-----------
-- Sample A         | ID-1000             | 10        
-- Sample B         | ID-1001             | 25        
-- Sample C         | ID-1002             | 42        
-- ...


-- Q2
SELECT
    b.structure_number,
    b.facility_carried,
    b.county
FROM bridges b
LEFT JOIN construction_projects p
    ON b.county = p.county
WHERE p.project_id IS NULL;
-- Expected output (first 5 rows, illustrative):
-- structure_number | facility_carried | county     
-- -----------------+------------------+------------
-- ID-1000          | Sample A         | LOS ANGELES
-- ID-1001          | Sample B         | SAN DIEGO  
-- ID-1002          | Sample C         | SACRAMENTO 
-- ...


-- Q3
WITH project_counts AS (
    SELECT county, COUNT(*) AS project_count
    FROM construction_projects
    GROUP BY county
),
bridge_counts AS (
    SELECT county, COUNT(*) AS bridge_count
    FROM bridges
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


-- Q4
SELECT
    c.contractor_name,
    p.project_description,
    c.bid_amount,
    c.award_date
FROM contracts c
JOIN construction_projects p
    ON c.project_id = p.project_id
ORDER BY c.bid_amount DESC NULLS LAST;
-- Expected output (first 5 rows, illustrative):
-- contractor_name | project_description | bid_amount | award_date
-- ----------------+---------------------+------------+-----------
-- Sample A        | ID-1000             | 10         | 2024-01-15
-- Sample B        | ID-1001             | 25         | 2024-02-15
-- Sample C        | ID-1002             | 42         | 2024-03-15
-- ...


-- Q5
SELECT
    contract_id,
    contractor_name,
    bid_amount,
    engineer_estimate
FROM contracts
WHERE bid_amount > engineer_estimate * 1.10;
-- Expected output (first 5 rows, illustrative):
-- contract_id | contractor_name | bid_amount | engineer_estimate
-- ------------+-----------------+------------+------------------
-- ID-1000     | Sample A        | 10         | Sample A         
-- ID-1001     | Sample B        | 25         | Sample B         
-- ID-1002     | Sample C        | 42         | Sample C         
-- ...


-- Q6
SELECT
    contractor_name,
    COUNT(*) AS contract_count,
    SUM(bid_amount) AS total_bid_amount,
    AVG(bid_amount) AS avg_bid_amount
FROM contracts
GROUP BY contractor_name
ORDER BY total_bid_amount DESC NULLS LAST;
-- Expected output (first 5 rows, illustrative):
-- contractor_name | contract_count | total_bid_amount | avg_bid_amount
-- ----------------+----------------+------------------+---------------
-- Sample A        | 10             | 10               | 10            
-- Sample B        | 25             | 25               | 25            
-- Sample C        | 42             | 42               | 42            
-- ...


-- Q7
SELECT
    b.structure_number,
    b.facility_carried,
    p.project_id,
    p.project_description,
    c.contractor_name,
    c.bid_amount
FROM bridges b
JOIN construction_projects p
    ON b.county = p.county
LEFT JOIN contracts c
    ON p.project_id = c.project_id
LIMIT 10;
-- Expected output (first 5 rows, illustrative):
-- structure_number | facility_carried | project_id | project_description | contractor_name | bid_amount
-- -----------------+------------------+------------+---------------------+-----------------+-----------
-- ID-1000          | Sample A         | ID-1000    | ID-1000             | Sample A        | 10        
-- ID-1001          | Sample B         | ID-1001    | ID-1001             | Sample B        | 25        
-- ID-1002          | Sample C         | ID-1002    | ID-1002             | Sample C        | 42        
-- ...

