-- Sample Answer Key for Practice Project: Contractor Performance Dashboard
-- These are representative solutions, not the only correct ones.

-- Deliverable 1: contractor leaderboard
WITH contract_base AS (
    SELECT
        c.contract_id,
        c.project_id,
        c.contractor_name,
        p.county,
        p.district,
        p.work_type,
        c.award_date,
        c.bid_amount,
        c.engineer_estimate,
        c.final_cost,
        CASE
            WHEN c.engineer_estimate IS NULL OR c.engineer_estimate = 0 THEN NULL
            ELSE 100.0 * (c.bid_amount - c.engineer_estimate) / c.engineer_estimate
        END AS bid_vs_estimate_pct
    FROM contracts c
    JOIN construction_projects p
        ON c.project_id = p.project_id
    WHERE c.bid_amount IS NOT NULL
),
contractor_summary AS (
    SELECT
        contractor_name,
        COUNT(*) AS contract_count,
        MIN(award_date) AS first_award_date,
        MAX(award_date) AS most_recent_award_date,
        SUM(bid_amount) AS total_bid_amount,
        AVG(bid_amount) AS avg_bid_amount,
        AVG(bid_vs_estimate_pct) AS avg_bid_vs_estimate_pct
    FROM contract_base
    GROUP BY contractor_name
)
SELECT
    contractor_name,
    contract_count,
    first_award_date,
    most_recent_award_date,
    total_bid_amount,
    avg_bid_amount,
    avg_bid_vs_estimate_pct,
    RANK() OVER (ORDER BY total_bid_amount DESC NULLS LAST) AS statewide_rank,
    ROUND(
        100.0 * total_bid_amount / SUM(total_bid_amount) OVER (),
        2
    ) AS pct_of_statewide_total
FROM contractor_summary
ORDER BY statewide_rank
LIMIT 15;

-- Deliverable 2: largest contract per contractor
WITH contract_base AS (
    SELECT
        c.contract_id,
        c.project_id,
        c.contractor_name,
        p.county,
        p.work_type,
        c.award_date,
        c.bid_amount
    FROM contracts c
    JOIN construction_projects p
        ON c.project_id = p.project_id
    WHERE c.bid_amount IS NOT NULL
),
ranked_contracts AS (
    SELECT
        *,
        ROW_NUMBER() OVER (
            PARTITION BY contractor_name
            ORDER BY bid_amount DESC NULLS LAST
        ) AS contract_rank
    FROM contract_base
)
SELECT
    contractor_name,
    project_id,
    county,
    work_type,
    award_date,
    bid_amount
FROM ranked_contracts
WHERE contract_rank = 1
ORDER BY bid_amount DESC NULLS LAST;

-- Deliverable 3A: counties with most awarded dollars
WITH contract_base AS (
    SELECT
        c.contract_id,
        p.county,
        p.work_type,
        c.bid_amount
    FROM contracts c
    JOIN construction_projects p
        ON c.project_id = p.project_id
    WHERE c.bid_amount IS NOT NULL
)
SELECT
    county,
    COUNT(*) AS contract_count,
    SUM(bid_amount) AS total_bid_amount
FROM contract_base
GROUP BY county
ORDER BY total_bid_amount DESC NULLS LAST;

-- Deliverable 3B: work types with highest average contract size
WITH contract_base AS (
    SELECT
        p.work_type,
        c.bid_amount
    FROM contracts c
    JOIN construction_projects p
        ON c.project_id = p.project_id
    WHERE c.bid_amount IS NOT NULL
)
SELECT
    work_type,
    COUNT(*) AS contract_count,
    AVG(bid_amount) AS avg_bid_amount,
    SUM(bid_amount) AS total_bid_amount
FROM contract_base
GROUP BY work_type
ORDER BY avg_bid_amount DESC NULLS LAST;
