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

-- Q2
SELECT
    b.structure_number,
    b.facility_carried,
    b.county
FROM bridges b
LEFT JOIN construction_projects p
    ON b.county = p.county
WHERE p.project_id IS NULL;

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

-- Q5
SELECT
    contract_id,
    contractor_name,
    bid_amount,
    engineer_estimate
FROM contracts
WHERE bid_amount > engineer_estimate * 1.10;

-- Q6
SELECT
    contractor_name,
    COUNT(*) AS contract_count,
    SUM(bid_amount) AS total_bid_amount,
    AVG(bid_amount) AS avg_bid_amount
FROM contracts
GROUP BY contractor_name
ORDER BY total_bid_amount DESC NULLS LAST;

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
