-- Hints for Exercise 4b.1: UNION, INTERSECT, and EXCEPT

-- Q1 hint:
-- Write three separate SELECT statements — one filtering on
-- deck_condition, one on superstructure_condition, one on
-- substructure_condition. Combine them with UNION ALL. Use a
-- string literal ('deck', 'superstructure', 'substructure') as
-- an extra column in each SELECT to label the type.

-- Q2 hint:
-- Wrap the Q1 UNION ALL in a CTE called deficiency_register.
-- Then SELECT condition_type, county, COUNT(*) FROM that CTE
-- and GROUP BY county, condition_type.

-- Q3 hint:
-- SELECT county FROM bridges
-- UNION
-- SELECT county FROM construction_projects
-- Then wrap in a subquery or CTE and COUNT(*).

-- Q4 hint:
-- SELECT county FROM bridges
-- INTERSECT
-- SELECT county FROM construction_projects

-- Q5 hint:
-- SELECT county FROM bridges
-- EXCEPT
-- SELECT county FROM construction_projects

-- Q6 hint:
-- Flip the order of Q5:
-- SELECT county FROM construction_projects
-- EXCEPT
-- SELECT county FROM bridges

-- Q7 hint:
-- Compute three sets: all_bridge_counties, all_project_counties,
-- both_counties (INTERSECT). Then FULL OUTER JOIN or use CASE
-- expressions against those sets.
-- Example skeleton:
--   WITH bridge_counties  AS (SELECT DISTINCT county FROM bridges),
--        project_counties AS (SELECT DISTINCT county FROM construction_projects),
--        both_counties    AS (SELECT county FROM bridges INTERSECT SELECT county FROM construction_projects)
--   SELECT ...
