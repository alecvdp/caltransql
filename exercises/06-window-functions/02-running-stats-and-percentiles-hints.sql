-- Hints for Exercise 6.2: Running Totals, Shares, and Percentiles

-- Q1 hint:
-- PARTITION BY contractor_name, ORDER BY award_date.

-- Q2 hint:
-- Rank inside each contractor partition, then filter rank <= 3.

-- Q3 hint:
-- Wrap NTILE(4) in a subquery, then GROUP BY quartile.

-- Q4 hint:
-- LAG(nhcci_raw) OVER (ORDER BY quarter_date).

-- Q5 hint:
-- Compute quarter-over-quarter change first, then sort descending.

-- Q6 hint:
-- Both functions operate over an ordered window.

-- Q7 hint:
-- Aggregate to contractor level first, then divide by SUM(total_bid_amount) OVER ().

-- Q8 hint:
-- Use a contractor summary CTE, then add RANK() and percentage in the outer query.
