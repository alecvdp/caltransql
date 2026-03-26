-- Answer Key for Exercise 5.2: EXISTS and NOT EXISTS

-- Q1
SELECT b.structure_number, b.county, b.facility_carried
FROM bridges b
WHERE EXISTS (
    SELECT 1
    FROM construction_projects p
    WHERE p.county = b.county
      AND p.total_cost > 100000000
)
LIMIT 25;

-- Q2
SELECT b.structure_number, b.county, b.facility_carried
FROM bridges b
WHERE NOT EXISTS (
    SELECT 1
    FROM construction_projects p
    WHERE p.county = b.county
)
LIMIT 25;

-- Q3
SELECT p.project_id, p.county, p.work_type, p.total_cost
FROM construction_projects p
WHERE EXISTS (
    SELECT 1
    FROM contracts c
    WHERE c.project_id = p.project_id
);

-- Q4
SELECT DISTINCT c1.contractor_name
FROM contracts c1
WHERE EXISTS (
    SELECT 1
    FROM contracts c2
    WHERE c2.contractor_name = c1.contractor_name
      AND c2.bid_amount > (SELECT AVG(bid_amount) FROM contracts)
);

-- Q5
SELECT DISTINCT b.county
FROM bridges b
WHERE EXISTS (
    SELECT 1
    FROM bridges b2
    WHERE b2.county = b.county
      AND b2.deck_condition <= 4
      AND b2.adt >= 50000
)
ORDER BY b.county;

-- Q6
SELECT p.project_id, p.county, p.project_description
FROM construction_projects p
WHERE NOT EXISTS (
    SELECT 1
    FROM contracts c
    WHERE c.project_id = p.project_id
      AND c.final_cost IS NOT NULL
);

-- Q7
SELECT
    county,
    CASE WHEN EXISTS (
        SELECT 1
        FROM bridges b2
        WHERE b2.county = b.county
          AND b2.deck_condition <= 4
    ) THEN 'YES' ELSE 'NO' END AS has_poor_condition_bridges,
    CASE WHEN EXISTS (
        SELECT 1
        FROM construction_projects p
        WHERE p.county = b.county
    ) THEN 'YES' ELSE 'NO' END AS has_projects,
    CASE WHEN EXISTS (
        SELECT 1
        FROM construction_projects p
        JOIN contracts c
            ON p.project_id = c.project_id
        WHERE p.county = b.county
    ) THEN 'YES' ELSE 'NO' END AS has_contracts
FROM (SELECT DISTINCT county FROM bridges) b
ORDER BY county;
