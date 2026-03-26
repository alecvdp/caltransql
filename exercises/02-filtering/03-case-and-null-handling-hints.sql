-- Hints for Exercise 2.3: CASE, COALESCE, and NULL Handling

-- Q1 hint:
-- Use CASE in the SELECT list and test year_built ranges in order.

-- Q2 hint:
-- Handle ADT IS NULL before numeric comparisons if you want an "Unknown" bucket.

-- Q3 hint:
-- COALESCE(year_reconstructed, year_built) gives you one effective year column.

-- Q4 hint:
-- CASE can return labels like 'Urgent', 'Monitor', 'Stable', 'Unknown'.

-- Q5 hint:
-- Repeat the deck_condition logic from Q4 inside WHERE,
-- or filter directly with deck_condition <= 4.

-- Q6 hint:
-- Use CASE inside ORDER BY to map labels to numbers.

-- Q7 hint:
-- bridge_age can use data_year - year_built.
