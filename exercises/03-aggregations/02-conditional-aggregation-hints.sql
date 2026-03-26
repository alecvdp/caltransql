-- Hints for Exercise 3.2: Conditional Aggregation

-- Q1 hint:
-- COUNT(CASE WHEN ... THEN 1 END) works well for subgroup counts.

-- Q2 hint:
-- Make three separate conditional counts in the same SELECT.

-- Q3 hint:
-- Percentage = 100.0 * matching_count / total_count.

-- Q4 hint:
-- You can count multiple thresholds in one grouped query.

-- Q5 hint:
-- AVG(CASE WHEN ... THEN total_length_m END) averages only matching rows.

-- Q6 hint:
-- Use two conditional AVG expressions side by side.

-- Q7 hint:
-- Build the percentages from conditional counts and filter with HAVING COUNT(*) >= 100.
