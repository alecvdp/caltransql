-- Hints for Exercise 6.1: Window Functions

-- Q1 hint:
-- ROW_NUMBER() OVER (ORDER BY total_length_m DESC)

-- Q2 hint:
-- Rank inside each county, then wrap it and filter rank = 1.

-- Q3 hint:
-- Put ROW_NUMBER, RANK, and DENSE_RANK side by side in one SELECT.

-- Q4 hint:
-- AVG(total_length_m) OVER (PARTITION BY county) gives the county average.

-- Q5 hint:
-- SUM(bid_amount) OVER (ORDER BY award_date).

-- Q6 hint:
-- Divide bid_amount by SUM(bid_amount) OVER (PARTITION BY contractor_name).
