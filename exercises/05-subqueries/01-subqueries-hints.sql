-- Hints for Exercise 5.1: Subqueries

-- Q1 hint:
-- Compare total_length_m to a scalar subquery returning MAX(total_length_m).

-- Q2 hint:
-- Use AVG(year_built) in a subquery, then compare with < or > carefully.

-- Q3 hint:
-- First find the counties where AVG(deck_condition) < 6, then filter bridges with IN.

-- Q4 hint:
-- Compare bid_amount to (SELECT AVG(bid_amount) FROM contracts).

-- Q5 hint:
-- Correlate on county and compare each bridge's total_length_m to the county average.

-- Q6 hint:
-- Correlate on contractor_name and compare bid_amount to MAX(bid_amount) for that contractor.

-- Q7 hint:
-- Put the county average year in a SELECT subquery and subtract it from year_built.
