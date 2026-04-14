-- Answer Key for Exercise 7.3: Recursive CTEs (WITH RECURSIVE)

-- Q1
WITH RECURSIVE route_candidates AS (
    SELECT county, route, COUNT(*) AS segment_count
    FROM construction_projects
    WHERE route IS NOT NULL
      AND county IS NOT NULL
      AND post_mile_start IS NOT NULL
    GROUP BY county, route
    ORDER BY segment_count DESC
    LIMIT 1
),
ordered_projects AS (
    SELECT
        p.project_id,
        p.county,
        p.route,
        p.post_mile_start,
        p.post_mile_end,
        p.total_cost
    FROM construction_projects p
    JOIN route_candidates rc
      ON p.county = rc.county
     AND p.route = rc.route
    WHERE p.post_mile_start IS NOT NULL
),
route_seed AS (
    SELECT
        op.project_id,
        op.county,
        op.route,
        op.post_mile_start,
        op.post_mile_end,
        op.total_cost
    FROM ordered_projects op
    ORDER BY op.post_mile_start
    LIMIT 1
),
route_walk AS (
    SELECT
        rs.project_id,
        rs.county,
        rs.route,
        rs.post_mile_start,
        rs.post_mile_end,
        rs.total_cost,
        1 AS step_no,
        ARRAY[rs.project_id] AS visited_projects
    FROM route_seed rs

    UNION ALL

    SELECT
        next_op.project_id,
        next_op.county,
        next_op.route,
        next_op.post_mile_start,
        next_op.post_mile_end,
        next_op.total_cost,
        rw.step_no + 1,
        rw.visited_projects || next_op.project_id
    FROM route_walk rw
    JOIN LATERAL (
        SELECT op.*
        FROM ordered_projects op
        WHERE op.post_mile_start > COALESCE(rw.post_mile_end, rw.post_mile_start)
          AND NOT (op.project_id = ANY (rw.visited_projects))
        ORDER BY op.post_mile_start
        LIMIT 1
    ) next_op ON TRUE
    WHERE rw.step_no < 15
)
SELECT
    step_no,
    county,
    route,
    project_id,
    post_mile_start,
    post_mile_end,
    total_cost
FROM route_walk
ORDER BY step_no;

-- Q2
WITH RECURSIVE month_bounds AS (
    SELECT
        DATE_TRUNC('month', MIN(start_date))::date AS min_month,
        DATE_TRUNC('month', MAX(start_date))::date AS max_month
    FROM construction_projects
    WHERE start_date IS NOT NULL
),
month_series AS (
    SELECT min_month AS month_start
    FROM month_bounds
    UNION ALL
    SELECT (ms.month_start + INTERVAL '1 month')::date
    FROM month_series ms
    CROSS JOIN month_bounds b
    WHERE ms.month_start < b.max_month
),
monthly_projects AS (
    SELECT
        DATE_TRUNC('month', start_date)::date AS month_start,
        COUNT(*) AS project_count,
        SUM(total_cost) AS total_project_cost
    FROM construction_projects
    WHERE start_date IS NOT NULL
    GROUP BY 1
)
SELECT
    ms.month_start,
    COALESCE(mp.project_count, 0) AS project_count,
    COALESCE(mp.total_project_cost, 0) AS total_project_cost
FROM month_series ms
LEFT JOIN monthly_projects mp
  ON ms.month_start = mp.month_start
ORDER BY ms.month_start;

-- Q3
WITH RECURSIVE phase_base AS (
    SELECT
        ROW_NUMBER() OVER (ORDER BY approval_date, project_id) AS phase_no,
        project_id,
        total_cost AS phase_cost
    FROM construction_projects
    WHERE approval_date IS NOT NULL
      AND total_cost IS NOT NULL
),
phase_rollup AS (
    SELECT
        pb.phase_no,
        pb.project_id,
        pb.phase_cost,
        pb.phase_cost AS cumulative_phase_cost
    FROM phase_base pb
    WHERE pb.phase_no = 1

    UNION ALL

    SELECT
        next_phase.phase_no,
        next_phase.project_id,
        next_phase.phase_cost,
        pr.cumulative_phase_cost + next_phase.phase_cost AS cumulative_phase_cost
    FROM phase_rollup pr
    JOIN phase_base next_phase
      ON next_phase.phase_no = pr.phase_no + 1
)
SELECT
    phase_no,
    project_id,
    phase_cost,
    cumulative_phase_cost
FROM phase_rollup
ORDER BY phase_no
LIMIT 25;

-- Q4
WITH RECURSIVE route_candidates AS (
    SELECT county, route, COUNT(*) AS segment_count
    FROM construction_projects
    WHERE route IS NOT NULL
      AND county IS NOT NULL
      AND post_mile_start IS NOT NULL
    GROUP BY county, route
    ORDER BY segment_count DESC
    LIMIT 1
),
ordered_projects AS (
    SELECT
        p.project_id,
        p.county,
        p.route,
        p.post_mile_start,
        p.post_mile_end,
        COALESCE(p.total_cost, 0) AS segment_cost
    FROM construction_projects p
    JOIN route_candidates rc
      ON p.county = rc.county
     AND p.route = rc.route
    WHERE p.post_mile_start IS NOT NULL
),
route_budget_seed AS (
    SELECT
        op.project_id,
        op.county,
        op.route,
        op.post_mile_start,
        op.post_mile_end,
        op.segment_cost
    FROM ordered_projects op
    ORDER BY op.post_mile_start
    LIMIT 1
),
route_budget_walk AS (
    SELECT
        rbs.project_id,
        rbs.county,
        rbs.route,
        rbs.post_mile_start,
        rbs.post_mile_end,
        rbs.segment_cost,
        rbs.segment_cost AS running_total_cost,
        1 AS step_no,
        ARRAY[rbs.project_id] AS visited_projects
    FROM route_budget_seed rbs

    UNION ALL

    SELECT
        next_op.project_id,
        next_op.county,
        next_op.route,
        next_op.post_mile_start,
        next_op.post_mile_end,
        next_op.segment_cost,
        rbw.running_total_cost + next_op.segment_cost AS running_total_cost,
        rbw.step_no + 1 AS step_no,
        rbw.visited_projects || next_op.project_id AS visited_projects
    FROM route_budget_walk rbw
    JOIN LATERAL (
        SELECT op.*
        FROM ordered_projects op
        WHERE op.post_mile_start > COALESCE(rbw.post_mile_end, rbw.post_mile_start)
          AND NOT (op.project_id = ANY (rbw.visited_projects))
        ORDER BY op.post_mile_start
        LIMIT 1
    ) next_op ON TRUE
    WHERE rbw.step_no < 12
      AND rbw.running_total_cost <= 250000000
)
SELECT
    step_no,
    county,
    route,
    project_id,
    post_mile_start,
    post_mile_end,
    segment_cost,
    running_total_cost
FROM route_budget_walk
ORDER BY step_no;
