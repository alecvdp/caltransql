-- Sample Answer Key for Practice Project: Inflation-Adjusted Construction Costs
-- These are representative solutions, not the only correct ones.

-- Base adjusted contracts dataset
WITH contract_quarters AS (
    SELECT
        c.contract_id,
        c.project_id,
        c.contractor_name,
        c.award_date,
        c.bid_amount,
        EXTRACT(YEAR FROM c.award_date)::INT AS award_year,
        EXTRACT(QUARTER FROM c.award_date)::INT AS award_quarter
    FROM contracts c
    WHERE c.award_date IS NOT NULL
      AND c.bid_amount IS NOT NULL
),
reference_quarter AS (
    SELECT quarter_date, nhcci_raw
    FROM construction_cost_index
    ORDER BY quarter_date DESC
    LIMIT 1
),
adjusted_contracts AS (
    SELECT
        cq.contract_id,
        cq.project_id,
        cq.contractor_name,
        cq.award_date,
        cq.bid_amount,
        cq.award_year,
        cci.quarter_date,
        cci.nhcci_raw AS contract_nhcci_raw,
        rq.nhcci_raw AS reference_nhcci_raw,
        cq.bid_amount * (rq.nhcci_raw / NULLIF(cci.nhcci_raw, 0)) AS inflation_adjusted_bid_amount
    FROM contract_quarters cq
    JOIN construction_cost_index cci
        ON cq.award_year = cci.year
       AND cq.award_quarter = cci.quarter
    CROSS JOIN reference_quarter rq
)
SELECT *
FROM adjusted_contracts
ORDER BY award_date;

-- Deliverable 1: year-level nominal vs adjusted totals
WITH contract_quarters AS (
    SELECT
        c.contract_id,
        c.project_id,
        c.contractor_name,
        c.award_date,
        c.bid_amount,
        EXTRACT(YEAR FROM c.award_date)::INT AS award_year,
        EXTRACT(QUARTER FROM c.award_date)::INT AS award_quarter
    FROM contracts c
    WHERE c.award_date IS NOT NULL
      AND c.bid_amount IS NOT NULL
),
reference_quarter AS (
    SELECT quarter_date, nhcci_raw
    FROM construction_cost_index
    ORDER BY quarter_date DESC
    LIMIT 1
),
adjusted_contracts AS (
    SELECT
        cq.contract_id,
        cq.award_year,
        cq.bid_amount,
        cq.bid_amount * (rq.nhcci_raw / NULLIF(cci.nhcci_raw, 0)) AS inflation_adjusted_bid_amount
    FROM contract_quarters cq
    JOIN construction_cost_index cci
        ON cq.award_year = cci.year
       AND cq.award_quarter = cci.quarter
    CROSS JOIN reference_quarter rq
)
SELECT
    award_year,
    COUNT(*) AS contract_count,
    SUM(bid_amount) AS nominal_total_bid_amount,
    SUM(inflation_adjusted_bid_amount) AS inflation_adjusted_total_bid_amount,
    AVG(bid_amount) AS nominal_avg_bid_amount,
    AVG(inflation_adjusted_bid_amount) AS inflation_adjusted_avg_bid_amount
FROM adjusted_contracts
GROUP BY award_year
ORDER BY award_year;

-- Deliverable 2: top contracts in adjusted dollars with project context
WITH contract_quarters AS (
    SELECT
        c.contract_id,
        c.project_id,
        c.contractor_name,
        c.award_date,
        c.bid_amount,
        EXTRACT(YEAR FROM c.award_date)::INT AS award_year,
        EXTRACT(QUARTER FROM c.award_date)::INT AS award_quarter
    FROM contracts c
    WHERE c.award_date IS NOT NULL
      AND c.bid_amount IS NOT NULL
),
reference_quarter AS (
    SELECT quarter_date, nhcci_raw
    FROM construction_cost_index
    ORDER BY quarter_date DESC
    LIMIT 1
),
adjusted_contracts AS (
    SELECT
        cq.contract_id,
        cq.project_id,
        cq.contractor_name,
        cq.award_date,
        cq.bid_amount AS nominal_bid_amount,
        cq.bid_amount * (rq.nhcci_raw / NULLIF(cci.nhcci_raw, 0)) AS inflation_adjusted_bid_amount
    FROM contract_quarters cq
    JOIN construction_cost_index cci
        ON cq.award_year = cci.year
       AND cq.award_quarter = cci.quarter
    CROSS JOIN reference_quarter rq
)
SELECT
    ac.contract_id,
    ac.contractor_name,
    p.county,
    p.work_type,
    ac.award_date,
    ac.nominal_bid_amount,
    ac.inflation_adjusted_bid_amount
FROM adjusted_contracts ac
LEFT JOIN construction_projects p
    ON ac.project_id = p.project_id
ORDER BY inflation_adjusted_bid_amount DESC NULLS LAST
LIMIT 20;

-- Deliverable 3: counties with highest adjusted spending
WITH contract_quarters AS (
    SELECT
        c.contract_id,
        c.project_id,
        c.bid_amount,
        EXTRACT(YEAR FROM c.award_date)::INT AS award_year,
        EXTRACT(QUARTER FROM c.award_date)::INT AS award_quarter
    FROM contracts c
    WHERE c.award_date IS NOT NULL
      AND c.bid_amount IS NOT NULL
),
reference_quarter AS (
    SELECT quarter_date, nhcci_raw
    FROM construction_cost_index
    ORDER BY quarter_date DESC
    LIMIT 1
),
adjusted_contracts AS (
    SELECT
        cq.project_id,
        cq.bid_amount,
        cq.bid_amount * (rq.nhcci_raw / NULLIF(cci.nhcci_raw, 0)) AS inflation_adjusted_bid_amount
    FROM contract_quarters cq
    JOIN construction_cost_index cci
        ON cq.award_year = cci.year
       AND cq.award_quarter = cci.quarter
    CROSS JOIN reference_quarter rq
)
SELECT
    p.county,
    COUNT(*) AS contract_count,
    SUM(ac.bid_amount) AS nominal_total_bid_amount,
    SUM(ac.inflation_adjusted_bid_amount) AS inflation_adjusted_total_bid_amount
FROM adjusted_contracts ac
JOIN construction_projects p
    ON ac.project_id = p.project_id
GROUP BY p.county
ORDER BY inflation_adjusted_total_bid_amount DESC NULLS LAST;
