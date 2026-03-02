-- ============================================================
-- Exercise 6.1: Window Functions
-- ============================================================
-- Window functions perform calculations across a set of rows
-- related to the current row - WITHOUT collapsing them like
-- GROUP BY does. This is an intermediate/advanced topic.
--
-- These exercises use the 'bridges' and 'contracts' tables.
-- ============================================================


-- ----- EXAMPLES -----

-- ROW_NUMBER: assign a sequential number to each row
SELECT
    structure_number,
    facility_carried,
    county,
    year_built,
    ROW_NUMBER() OVER (ORDER BY year_built) AS age_rank
FROM bridges
LIMIT 20;

-- ROW_NUMBER with PARTITION BY: number within each group
SELECT
    structure_number,
    facility_carried,
    county,
    year_built,
    ROW_NUMBER() OVER (
        PARTITION BY county
        ORDER BY year_built
    ) AS county_age_rank
FROM bridges
LIMIT 20;


-- ----- YOUR TURN -----

-- Q1: Rank all bridges by total_length_m (longest = rank 1).
--     Use ROW_NUMBER() OVER (ORDER BY total_length_m DESC).
--     Show the top 20.


-- Q2: Within each county, rank bridges by year_built (oldest first).
--     Use PARTITION BY county.
--     Filter to show only rank 1 (the oldest bridge per county).
--     (Hint: wrap in a subquery or CTE and filter WHERE rank = 1)


-- ============================================================
-- RANK vs DENSE_RANK vs ROW_NUMBER
-- ============================================================
-- ROW_NUMBER: always unique (1, 2, 3, 4, 5)
-- RANK:       ties get same rank, gaps after (1, 2, 2, 4, 5)
-- DENSE_RANK: ties get same rank, no gaps   (1, 2, 2, 3, 4)

-- Q3: Rank bridges by deck_condition using all three functions.
--     Show the first 20 rows. Notice the differences.


-- ============================================================
-- Aggregate Window Functions
-- ============================================================

-- You can use SUM, AVG, COUNT etc. as window functions!

-- Example: Show each bridge alongside its county's average year_built
SELECT
    structure_number,
    facility_carried,
    county,
    year_built,
    AVG(year_built) OVER (PARTITION BY county) AS county_avg_year
FROM bridges
LIMIT 20;

-- Q4: For each bridge, show its total_length_m and the average
--     total_length_m for its county. Also calculate how much longer
--     or shorter it is vs the county average.


-- Q5: For each contract, show the bid_amount and a running total
--     of bid_amounts ordered by award_date.
--     (SUM(bid_amount) OVER (ORDER BY award_date))


-- Q6: For each contract, show what percentage of the contractor's
--     total spending this contract represents.
--     (bid_amount / SUM(bid_amount) OVER (PARTITION BY contractor_name))

