-- ============================================================
-- Exercise 6.2: Running Totals, Shares, and Percentiles
-- ============================================================
-- These exercises use the 'contracts' and 'construction_cost_index'
-- tables.
-- ============================================================


-- ----- EXAMPLES -----

-- Running total of contract awards by date
SELECT
    contract_id,
    award_date,
    bid_amount,
    SUM(bid_amount) OVER (
        ORDER BY award_date
        ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
    ) AS running_award_total
FROM contracts
ORDER BY award_date
LIMIT 20;

-- Percent of contractor total
SELECT
    contractor_name,
    contract_id,
    bid_amount,
    ROUND(
        100.0 * bid_amount
        / SUM(bid_amount) OVER (PARTITION BY contractor_name),
        2
    ) AS pct_of_contractor_total
FROM contracts
LIMIT 20;


-- ----- YOUR TURN -----

-- Q1: For each contract, show:
--     contractor_name, award_date, bid_amount,
--     and the contractor's running total over time.


-- Q2: Within each contractor, rank contracts from largest
--     to smallest bid_amount.
--     Show only the top 3 contracts per contractor.


-- Q3: Divide contracts into 4 quartiles by bid_amount
--     using NTILE(4). How many contracts land in each quartile?


-- ============================================================
-- Comparing rows with LAG/LEAD
-- ============================================================

-- Q4: For each quarter in construction_cost_index, show:
--     - quarter_date
--     - nhcci_raw
--     - previous quarter's nhcci_raw using LAG
--     - absolute change
--     - percent change


-- Q5: Find the quarter with the largest increase in nhcci_raw
--     versus the previous quarter.


-- ============================================================
-- Percentiles and shares
-- ============================================================

-- Q6: For each contract, calculate:
--     - PERCENT_RANK() over bid_amount
--     - CUME_DIST() over bid_amount
--     Order by bid_amount descending.


-- Q7: For each contractor, show what share of the statewide
--     total bid_amount they represent.
--     (Hint: divide contractor total by SUM(...) OVER ())


-- ============================================================
-- Challenge
-- ============================================================

-- Q8: Build a ranked contractor summary with:
--     - contractor_name
--     - contract_count
--     - total_bid_amount
--     - statewide_rank by total_bid_amount
--     - pct_of_statewide_total
--     Use a CTE plus window functions.
