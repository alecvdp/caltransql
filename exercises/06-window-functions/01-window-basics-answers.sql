-- Answer Key for Exercise 6.1: Window Functions

-- Q1
SELECT
    structure_number,
    facility_carried,
    county,
    total_length_m,
    ROW_NUMBER() OVER (ORDER BY total_length_m DESC NULLS LAST) AS length_rank
FROM bridges
ORDER BY length_rank
LIMIT 20;
-- Expected output (first 5 rows, illustrative):
-- structure_number | facility_carried | county      | total_length_m | length_rank
-- -----------------+------------------+-------------+----------------+------------
-- ID-1000          | Sample A         | LOS ANGELES | 10             | 10         
-- ID-1001          | Sample B         | SAN DIEGO   | 25             | 25         
-- ID-1002          | Sample C         | SACRAMENTO  | 42             | 42         
-- ...


-- Q2
WITH ranked_bridges AS (
    SELECT
        structure_number,
        facility_carried,
        county,
        year_built,
        ROW_NUMBER() OVER (
            PARTITION BY county
            ORDER BY year_built ASC
        ) AS county_age_rank
    FROM bridges
)
SELECT *
FROM ranked_bridges
WHERE county_age_rank = 1
ORDER BY county;
-- Expected output (first 5 rows, illustrative):
-- *             
-- --------------
-- <many columns>
-- <many columns>
-- <many columns>
-- ...


-- Q3
SELECT
    structure_number,
    county,
    deck_condition,
    ROW_NUMBER() OVER (ORDER BY deck_condition DESC NULLS LAST) AS row_number_rank,
    RANK() OVER (ORDER BY deck_condition DESC NULLS LAST) AS rank_value,
    DENSE_RANK() OVER (ORDER BY deck_condition DESC NULLS LAST) AS dense_rank_value
FROM bridges
LIMIT 20;
-- Expected output (first 5 rows, illustrative):
-- structure_number | county      | deck_condition | row_number_rank | rank_value | dense_rank_value
-- -----------------+-------------+----------------+-----------------+------------+-----------------
-- ID-1000          | LOS ANGELES | 10             | 10              | 10         | 10              
-- ID-1001          | SAN DIEGO   | 25             | 25              | 25         | 25              
-- ID-1002          | SACRAMENTO  | 42             | 42              | 42         | 42              
-- ...


-- Q4
SELECT
    structure_number,
    county,
    total_length_m,
    AVG(total_length_m) OVER (PARTITION BY county) AS county_avg_length,
    total_length_m - AVG(total_length_m) OVER (PARTITION BY county) AS difference_from_county_avg
FROM bridges
LIMIT 20;
-- Expected output (first 5 rows, illustrative):
-- structure_number | county      | total_length_m | county_avg_length | difference_from_county_avg
-- -----------------+-------------+----------------+-------------------+---------------------------
-- ID-1000          | LOS ANGELES | 10             | 10                | 10                        
-- ID-1001          | SAN DIEGO   | 25             | 25                | 25                        
-- ID-1002          | SACRAMENTO  | 42             | 42                | 42                        
-- ...


-- Q5
SELECT
    contract_id,
    award_date,
    bid_amount,
    SUM(bid_amount) OVER (
        ORDER BY award_date
        ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
    ) AS running_bid_total
FROM contracts
ORDER BY award_date;
-- Expected output (first 5 rows, illustrative):
-- contract_id | award_date | bid_amount | running_bid_total
-- ------------+------------+------------+------------------
-- ID-1000     | 2024-01-15 | 10         | 10               
-- ID-1001     | 2024-02-15 | 25         | 25               
-- ID-1002     | 2024-03-15 | 42         | 42               
-- ...


-- Q6
SELECT
    contract_id,
    contractor_name,
    bid_amount,
    ROUND(
        100.0 * bid_amount / SUM(bid_amount) OVER (PARTITION BY contractor_name),
        2
    ) AS pct_of_contractor_total
FROM contracts;
-- Expected output (first 5 rows, illustrative):
-- contract_id | contractor_name | bid_amount | pct_of_contractor_total
-- ------------+-----------------+------------+------------------------
-- ID-1000     | Sample A        | 10         | 10                     
-- ID-1001     | Sample B        | 25         | 25                     
-- ID-1002     | Sample C        | 42         | 42                     
-- ...

