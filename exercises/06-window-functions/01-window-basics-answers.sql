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

-- Q4
SELECT
    structure_number,
    county,
    total_length_m,
    AVG(total_length_m) OVER (PARTITION BY county) AS county_avg_length,
    total_length_m - AVG(total_length_m) OVER (PARTITION BY county) AS difference_from_county_avg
FROM bridges
LIMIT 20;

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
