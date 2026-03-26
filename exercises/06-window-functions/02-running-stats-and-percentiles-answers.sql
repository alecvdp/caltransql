-- Answer Key for Exercise 6.2: Running Totals, Shares, and Percentiles

-- Q1
SELECT
    contractor_name,
    award_date,
    bid_amount,
    SUM(bid_amount) OVER (
        PARTITION BY contractor_name
        ORDER BY award_date
        ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
    ) AS contractor_running_total
FROM contracts
ORDER BY contractor_name, award_date;

-- Q2
WITH ranked_contracts AS (
    SELECT
        contractor_name,
        contract_id,
        award_date,
        bid_amount,
        ROW_NUMBER() OVER (
            PARTITION BY contractor_name
            ORDER BY bid_amount DESC NULLS LAST
        ) AS contract_rank
    FROM contracts
)
SELECT *
FROM ranked_contracts
WHERE contract_rank <= 3
ORDER BY contractor_name, contract_rank;

-- Q3
WITH contract_quartiles AS (
    SELECT
        contract_id,
        bid_amount,
        NTILE(4) OVER (ORDER BY bid_amount DESC NULLS LAST) AS bid_quartile
    FROM contracts
)
SELECT bid_quartile, COUNT(*) AS contract_count
FROM contract_quartiles
GROUP BY bid_quartile
ORDER BY bid_quartile;

-- Q4
SELECT
    quarter_date,
    nhcci_raw,
    LAG(nhcci_raw) OVER (ORDER BY quarter_date) AS previous_quarter_nhcci,
    nhcci_raw - LAG(nhcci_raw) OVER (ORDER BY quarter_date) AS absolute_change,
    ROUND(
        100.0 * (
            nhcci_raw - LAG(nhcci_raw) OVER (ORDER BY quarter_date)
        ) / NULLIF(LAG(nhcci_raw) OVER (ORDER BY quarter_date), 0),
        2
    ) AS percent_change
FROM construction_cost_index
ORDER BY quarter_date;

-- Q5
WITH cci_changes AS (
    SELECT
        quarter_date,
        nhcci_raw,
        nhcci_raw - LAG(nhcci_raw) OVER (ORDER BY quarter_date) AS absolute_change
    FROM construction_cost_index
)
SELECT *
FROM cci_changes
ORDER BY absolute_change DESC NULLS LAST
LIMIT 1;

-- Q6
SELECT
    contract_id,
    bid_amount,
    PERCENT_RANK() OVER (ORDER BY bid_amount) AS percent_rank_bid_amount,
    CUME_DIST() OVER (ORDER BY bid_amount) AS cume_dist_bid_amount
FROM contracts
ORDER BY bid_amount DESC NULLS LAST;

-- Q7
WITH contractor_totals AS (
    SELECT
        contractor_name,
        SUM(bid_amount) AS total_bid_amount
    FROM contracts
    GROUP BY contractor_name
)
SELECT
    contractor_name,
    total_bid_amount,
    ROUND(
        100.0 * total_bid_amount / SUM(total_bid_amount) OVER (),
        2
    ) AS pct_of_statewide_total
FROM contractor_totals
ORDER BY total_bid_amount DESC NULLS LAST;

-- Q8
WITH contractor_summary AS (
    SELECT
        contractor_name,
        COUNT(*) AS contract_count,
        SUM(bid_amount) AS total_bid_amount
    FROM contracts
    GROUP BY contractor_name
)
SELECT
    contractor_name,
    contract_count,
    total_bid_amount,
    RANK() OVER (ORDER BY total_bid_amount DESC NULLS LAST) AS statewide_rank,
    ROUND(
        100.0 * total_bid_amount / SUM(total_bid_amount) OVER (),
        2
    ) AS pct_of_statewide_total
FROM contractor_summary
ORDER BY statewide_rank;
