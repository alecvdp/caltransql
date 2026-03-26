-- Hints for Exercise 4.2: Join Grain and Duplicate Rows

-- Q1 hint:
-- Write three separate COUNT(*) queries:
-- bridges, construction_projects, and the raw join.

-- Q2 hint:
-- Group the raw county join by county and count rows.

-- Q3 hint:
-- Aggregate bridges and projects separately first, then join the summaries.

-- Q4 hint:
-- LEFT JOIN project counts onto bridge counts and keep only NULL matches.

-- Q5 hint:
-- Start from construction_projects, LEFT JOIN contracts on project_id,
-- then filter where c.project_id IS NULL.

-- Q6 hint:
-- project_id is the correct contract-to-project join key.

-- Q7 hint:
-- Count projects and contracts separately by county, then divide.

-- Q8 hint:
-- Use multiple CTEs so each source is already at county grain before the final join.
