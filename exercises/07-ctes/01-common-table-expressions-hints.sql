-- Hints for Exercise 7.1: Common Table Expressions

-- Q1 hint:
-- The CTE should filter long bridges first, then the outer query groups by county.

-- Q2 hint:
-- One CTE for county average deck_condition, outer query filters average < 6.

-- Q3 hint:
-- Build bridge_counts and project_counts separately, then join them by county.

-- Q4 hint:
-- Put ROW_NUMBER() inside the CTE and filter rank = 1 outside.

-- Q5 hint:
-- Create one CTE for statewide average and one for county averages,
-- then compare them in the final SELECT.
