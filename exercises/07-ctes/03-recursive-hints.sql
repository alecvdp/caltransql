-- Hints for Exercise 7.3: Recursive CTEs (WITH RECURSIVE)

-- Q1 hint:
-- Use an anchor row (smallest post_mile_start), then recurse to the next
-- row with a larger post_mile_start. A visited array helps prevent loops.

-- Q2 hint:
-- Build month_bounds first, then recurse month by month until max_month.
-- Left join aggregated monthly project counts.

-- Q3 hint:
-- Create phase_base with ROW_NUMBER(), anchor on phase_no = 1,
-- then join to phase_no + 1 in the recursive term.

-- Q4 hint:
-- Add running_total_cost to the recursive CTE output and keep recursing
-- only while step_no < 12 and running_total_cost <= 250000000.
