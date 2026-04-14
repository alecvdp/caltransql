-- ============================================================
-- Exercise 7.3: Recursive CTEs (WITH RECURSIVE)
-- ============================================================
-- Recursive CTEs let a query refer to its own prior output.
-- They are useful for:
--   - ordered traversal problems (route/post_mile chains)
--   - date/quarter series generation for gap filling
--   - iterative rollups like cumulative budget by phase
-- ============================================================


-- ----- EXAMPLES -----

-- Basic recursion: count from 1 to 5
WITH RECURSIVE step_counter AS (
    SELECT 1 AS step_no
    UNION ALL
    SELECT step_no + 1
    FROM step_counter
    WHERE step_no < 5
)
SELECT *
FROM step_counter;

-- Generate a month series between min and max contract award month
WITH RECURSIVE month_bounds AS (
    SELECT
        DATE_TRUNC('month', MIN(award_date))::date AS min_month,
        DATE_TRUNC('month', MAX(award_date))::date AS max_month
    FROM contracts
    WHERE award_date IS NOT NULL
),
month_series AS (
    SELECT min_month AS month_start
    FROM month_bounds
    UNION ALL
    SELECT (month_start + INTERVAL '1 month')::date
    FROM month_series ms
    CROSS JOIN month_bounds b
    WHERE ms.month_start < b.max_month
)
SELECT month_start
FROM month_series
ORDER BY month_start
LIMIT 24;


-- ----- YOUR TURN -----

-- Q1: Route traversal by post mile
--     Build a recursive query that walks project segments in order.
--     Suggested steps:
--       1) route_candidates: pick one county+route with post_mile data
--       2) ordered_projects: all projects for that county+route
--       3) route_walk (recursive):
--          - anchor = smallest post_mile_start
--          - recursive step = next nearest post_mile_start
--       4) include step_no and a visited_projects array to avoid loops
--     Return up to 15 steps in traversal order.


-- Q2: Date series generation + gap filling
--     Use WITH RECURSIVE to generate every month between the minimum
--     and maximum start_date in construction_projects.
--     Then left join monthly project counts so months with no projects
--     still appear with 0.
--     Return: month_start, project_count, total_project_cost.


-- Q3: Recursive cumulative phase cost rollup
--     Create a phase list from construction_projects by ordering rows
--     with non-null approval_date and total_cost.
--     Use ROW_NUMBER() as phase_no.
--     Then build a recursive CTE that accumulates total_cost one phase
--     at a time.
--     Return: phase_no, project_id, phase_cost, cumulative_phase_cost.


-- ============================================================
-- Challenge
-- ============================================================

-- Q4: Budget-capped route walk
--     Extend Q1 so the recursion stops when either:
--       - 12 steps have been reached, or
--       - running_total_cost exceeds 250,000,000
--     Return step_no, county, route, project_id, post_mile range,
--     segment_cost, and running_total_cost.
