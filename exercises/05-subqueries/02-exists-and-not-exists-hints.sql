-- Hints for Exercise 5.2: EXISTS and NOT EXISTS

-- Q1 hint:
-- The outer query is bridges; the EXISTS subquery should check for
-- at least one project in the same county with total_cost > 100000000.

-- Q2 hint:
-- Use NOT EXISTS against construction_projects where counties match.

-- Q3 hint:
-- Start from construction_projects and filter with EXISTS on contracts.

-- Q4 hint:
-- Compare each contractor's contracts against the overall average bid_amount.

-- Q5 hint:
-- Outer query can be DISTINCT county from bridges.

-- Q6 hint:
-- NOT EXISTS on a contract where final_cost IS NOT NULL.

-- Q7 hint:
-- CASE WHEN EXISTS (...) THEN 'YES' ELSE 'NO' END.
