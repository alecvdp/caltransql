-- ============================================================
-- Load synthetic construction project and contract data
-- ============================================================
-- Prerequisite: Run scripts/generate-contract-data.py first
-- to create data/construction_projects.csv and data/contracts.csv.
--
-- Usage (from repo root):
--   psql -h $PGHOST -p $PGPORT -U $PGUSER -d $PGDATABASE \
--        -f scripts/load-contracts.sql
-- ============================================================

-- ────────────────────────────────────────────────────────────
-- Stage and load construction_projects
-- ────────────────────────────────────────────────────────────

DROP TABLE IF EXISTS projects_staging;
CREATE TEMP TABLE projects_staging (
    project_id          TEXT,
    district            TEXT,
    county              TEXT,
    route               TEXT,
    post_mile_start     TEXT,
    post_mile_end       TEXT,
    project_description TEXT,
    work_type           TEXT,
    program             TEXT,
    total_cost          TEXT,
    engineer_estimate   TEXT,
    approval_date       TEXT,
    start_date          TEXT,
    completion_date     TEXT,
    status              TEXT,
    latitude            TEXT,
    longitude           TEXT
);

\COPY projects_staging FROM 'data/construction_projects.csv' WITH (FORMAT csv, HEADER true, NULL '');

DELETE FROM contracts WHERE project_id IN (
    SELECT project_id FROM projects_staging
);

DELETE FROM construction_projects WHERE project_id IN (
    SELECT project_id FROM projects_staging
);

INSERT INTO construction_projects (
    project_id, district, county, route,
    post_mile_start, post_mile_end,
    project_description, work_type, program,
    total_cost, engineer_estimate,
    approval_date, start_date, completion_date, status,
    latitude, longitude
)
SELECT
    TRIM(project_id),
    TRIM(district),
    TRIM(county),
    TRIM(route),
    NULLIF(TRIM(post_mile_start), '')::DECIMAL(8,3),
    NULLIF(TRIM(post_mile_end),   '')::DECIMAL(8,3),
    TRIM(project_description),
    TRIM(work_type),
    TRIM(program),
    NULLIF(TRIM(total_cost),         '')::DECIMAL(15,2),
    NULLIF(TRIM(engineer_estimate),  '')::DECIMAL(15,2),
    NULLIF(TRIM(approval_date),  '')::DATE,
    NULLIF(TRIM(start_date),     '')::DATE,
    NULLIF(TRIM(completion_date),'')::DATE,
    TRIM(status),
    NULLIF(TRIM(latitude),  '')::DECIMAL(10,7),
    NULLIF(TRIM(longitude), '')::DECIMAL(10,7)
FROM projects_staging
ON CONFLICT (project_id) DO UPDATE SET
    district            = EXCLUDED.district,
    county              = EXCLUDED.county,
    route               = EXCLUDED.route,
    post_mile_start     = EXCLUDED.post_mile_start,
    post_mile_end       = EXCLUDED.post_mile_end,
    project_description = EXCLUDED.project_description,
    work_type           = EXCLUDED.work_type,
    program             = EXCLUDED.program,
    total_cost          = EXCLUDED.total_cost,
    engineer_estimate   = EXCLUDED.engineer_estimate,
    approval_date       = EXCLUDED.approval_date,
    start_date          = EXCLUDED.start_date,
    completion_date     = EXCLUDED.completion_date,
    status              = EXCLUDED.status,
    latitude            = EXCLUDED.latitude,
    longitude           = EXCLUDED.longitude;

DROP TABLE projects_staging;

-- ────────────────────────────────────────────────────────────
-- Stage and load contracts
-- ────────────────────────────────────────────────────────────

DROP TABLE IF EXISTS contracts_staging;
CREATE TEMP TABLE contracts_staging (
    contract_id         TEXT,
    project_id          TEXT,
    contract_number     TEXT,
    contractor_name     TEXT,
    contractor_city     TEXT,
    contractor_state    TEXT,
    bid_amount          TEXT,
    engineer_estimate   TEXT,
    final_cost          TEXT,
    award_date          TEXT,
    work_start_date     TEXT,
    work_completion_date TEXT,
    acceptance_date     TEXT,
    num_bidders         TEXT,
    num_working_days    TEXT,
    contract_type       TEXT,
    status              TEXT
);

\COPY contracts_staging FROM 'data/contracts.csv' WITH (FORMAT csv, HEADER true, NULL '');

INSERT INTO contracts (
    contract_id, project_id, contract_number,
    contractor_name, contractor_city, contractor_state,
    bid_amount, engineer_estimate, final_cost,
    award_date, work_start_date, work_completion_date, acceptance_date,
    num_bidders, num_working_days, contract_type, status
)
SELECT
    TRIM(contract_id),
    TRIM(project_id),
    TRIM(contract_number),
    TRIM(contractor_name),
    TRIM(contractor_city),
    TRIM(contractor_state),
    NULLIF(TRIM(bid_amount),        '')::DECIMAL(15,2),
    NULLIF(TRIM(engineer_estimate), '')::DECIMAL(15,2),
    NULLIF(TRIM(final_cost),        '')::DECIMAL(15,2),
    NULLIF(TRIM(award_date),            '')::DATE,
    NULLIF(TRIM(work_start_date),       '')::DATE,
    NULLIF(TRIM(work_completion_date),  '')::DATE,
    NULLIF(TRIM(acceptance_date),       '')::DATE,
    NULLIF(TRIM(num_bidders),      '')::INTEGER,
    NULLIF(TRIM(num_working_days), '')::INTEGER,
    TRIM(contract_type),
    TRIM(status)
FROM contracts_staging
ON CONFLICT (contract_id) DO UPDATE SET
    project_id           = EXCLUDED.project_id,
    contract_number      = EXCLUDED.contract_number,
    contractor_name      = EXCLUDED.contractor_name,
    contractor_city      = EXCLUDED.contractor_city,
    contractor_state     = EXCLUDED.contractor_state,
    bid_amount           = EXCLUDED.bid_amount,
    engineer_estimate    = EXCLUDED.engineer_estimate,
    final_cost           = EXCLUDED.final_cost,
    award_date           = EXCLUDED.award_date,
    work_start_date      = EXCLUDED.work_start_date,
    work_completion_date = EXCLUDED.work_completion_date,
    acceptance_date      = EXCLUDED.acceptance_date,
    num_bidders          = EXCLUDED.num_bidders,
    num_working_days     = EXCLUDED.num_working_days,
    contract_type        = EXCLUDED.contract_type,
    status               = EXCLUDED.status;

DROP TABLE contracts_staging;
