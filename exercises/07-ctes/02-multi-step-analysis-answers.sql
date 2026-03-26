-- Answer Key for Exercise 7.2: Multi-Step Analysis with CTEs

-- Q1
WITH bridge_summary AS (
    SELECT
        county,
        COUNT(*) AS bridge_count,
        AVG(year_built) AS avg_year_built,
        COUNT(CASE WHEN deck_condition <= 4 THEN 1 END) AS poor_bridge_count
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
),
final AS (
    SELECT
        b.county,
        b.bridge_count,
        b.avg_year_built,
        b.poor_bridge_count,
        COALESCE(p.project_count, 0) AS project_count,
        COALESCE(p.total_project_cost, 0) AS total_project_cost,
        COALESCE(p.total_project_cost, 0) / NULLIF(b.bridge_count, 0) AS project_cost_per_bridge
    FROM bridge_summary b
    LEFT JOIN project_summary p
        ON b.county = p.county
)
SELECT *
FROM final
ORDER BY project_cost_per_bridge DESC NULLS LAST;

-- Q2
WITH contract_base AS (
    SELECT
        c.contract_id,
        c.contractor_name,
        c.bid_amount,
        p.county,
        p.work_type
    FROM contracts c
    JOIN construction_projects p
        ON c.project_id = p.project_id
),
contractor_summary AS (
    SELECT
        contractor_name,
        COUNT(*) AS contract_count,
        SUM(bid_amount) AS total_bid_amount
    FROM contract_base
    GROUP BY contractor_name
),
ranked_contractors AS (
    SELECT
        contractor_name,
        contract_count,
        total_bid_amount,
        RANK() OVER (ORDER BY total_bid_amount DESC NULLS LAST) AS contractor_rank
    FROM contractor_summary
)
SELECT *
FROM ranked_contractors
WHERE contractor_rank <= 15
ORDER BY contractor_rank;

-- Q3
WITH old_busy_bridges AS (
    SELECT
        structure_number,
        county,
        facility_carried,
        year_built,
        adt
    FROM bridges
    WHERE year_built < 1960
      AND adt >= 50000
),
county_project_counts AS (
    SELECT county, COUNT(*) AS project_count
    FROM construction_projects
    GROUP BY county
),
final AS (
    SELECT
        ob.structure_number,
        ob.county,
        ob.facility_carried,
        ob.year_built,
        ob.adt,
        COALESCE(cpc.project_count, 0) AS project_count,
        CASE WHEN COALESCE(cpc.project_count, 0) > 0 THEN 'YES' ELSE 'NO' END AS has_project_coverage
    FROM old_busy_bridges ob
    LEFT JOIN county_project_counts cpc
        ON ob.county = cpc.county
)
SELECT *
FROM final
LIMIT 30;

-- Q4
WITH bridge_age_stats AS (
    SELECT
        county,
        COUNT(*) AS bridge_count,
        AVG(year_built) AS avg_year_built
    FROM bridges
    GROUP BY county
),
bridge_condition_stats AS (
    SELECT
        county,
        AVG(deck_condition) AS avg_deck_condition,
        ROUND(
            100.0 * COUNT(CASE WHEN deck_condition <= 4 THEN 1 END) / COUNT(*),
            1
        ) AS poor_bridge_pct
    FROM bridges
    GROUP BY county
),
project_investment_stats AS (
    SELECT
        county,
        COUNT(*) AS project_count,
        SUM(total_cost) AS total_project_cost
    FROM construction_projects
    GROUP BY county
),
ranked_counties AS (
    SELECT
        a.county,
        a.bridge_count,
        a.avg_year_built,
        c.avg_deck_condition,
        c.poor_bridge_pct,
        COALESCE(p.project_count, 0) AS project_count,
        COALESCE(p.total_project_cost, 0) AS total_project_cost,
        RANK() OVER (
            ORDER BY c.poor_bridge_pct DESC, c.avg_deck_condition ASC NULLS LAST, a.avg_year_built ASC
        ) AS risk_rank
    FROM bridge_age_stats a
    JOIN bridge_condition_stats c
        ON a.county = c.county
    LEFT JOIN project_investment_stats p
        ON a.county = p.county
)
SELECT *
FROM ranked_counties
ORDER BY risk_rank;
