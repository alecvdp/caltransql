-- ============================================================
-- Exercise 7.2: Multi-Step Analysis with CTEs
-- ============================================================
-- These exercises combine bridges, projects, and contracts.
-- Focus on breaking a large question into clear stages.
-- ============================================================


-- ----- EXAMPLE -----

WITH bridge_summary AS (
    SELECT
        county,
        COUNT(*) AS bridge_count,
        AVG(deck_condition) AS avg_deck_condition
    FROM bridges
    GROUP BY county
),
project_summary AS (
    SELECT
        county,
        COUNT(*) AS project_count,
        SUM(total_cost) AS total_project_cost
    FROM construction_projects
    GROUP BY county
)
SELECT
    b.county,
    b.bridge_count,
    b.avg_deck_condition,
    COALESCE(p.project_count, 0) AS project_count,
    COALESCE(p.total_project_cost, 0) AS total_project_cost
FROM bridge_summary b
LEFT JOIN project_summary p
    ON b.county = p.county
ORDER BY b.bridge_count DESC;


-- ----- YOUR TURN -----

-- Q1: Build a county scorecard in three CTEs:
--     1) bridge_summary:
--        county, bridge_count, avg_year_built, poor_bridge_count
--     2) project_summary:
--        county, project_count, total_project_cost
--     3) final:
--        join the summaries and calculate project_cost_per_bridge
--     Order by project_cost_per_bridge descending.


-- Q2: Create a multi-step analysis of contractor activity:
--     1) contract_base: join contracts to projects
--     2) contractor_summary: contract_count, total_bid_amount
--     3) ranked_contractors: add rank by total_bid_amount
--     Return the top 15 contractors.


-- Q3: Build a bridge watch list:
--     1) old_busy_bridges: bridges built before 1960 with ADT >= 50000
--     2) county_project_counts: projects per county
--     3) final: combine them and show whether each bridge's county
--        has active project coverage
--     Limit to 30 rows.


-- ============================================================
-- Challenge Project in One Query
-- ============================================================

-- Q4: Create a county infrastructure risk ranking.
--     Break the problem into at least four CTEs:
--     - bridge_age_stats
--     - bridge_condition_stats
--     - project_investment_stats
--     - ranked_counties
--
--     Suggested final columns:
--     county
--     bridge_count
--     avg_year_built
--     avg_deck_condition
--     poor_bridge_pct
--     project_count
--     total_project_cost
--     risk_rank
