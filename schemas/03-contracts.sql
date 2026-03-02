-- ============================================================
-- Caltrans Contract & Bid Data
-- ============================================================
-- Tracks contract awards for construction projects.
-- Joins with construction_projects on project_id.
-- ============================================================

CREATE TABLE IF NOT EXISTS contracts (
    contract_id         VARCHAR(30) PRIMARY KEY,
    project_id          VARCHAR(30) REFERENCES construction_projects(project_id),
    contract_number     VARCHAR(30),

    -- Contractor info
    contractor_name     VARCHAR(200),
    contractor_city     VARCHAR(100),
    contractor_state    VARCHAR(5),

    -- Financial
    bid_amount          DECIMAL(15, 2),
    engineer_estimate   DECIMAL(15, 2),
    final_cost          DECIMAL(15, 2),

    -- Dates
    award_date          DATE,
    work_start_date     DATE,
    work_completion_date DATE,
    acceptance_date     DATE,

    -- Details
    num_bidders         INTEGER,
    num_working_days    INTEGER,
    contract_type       VARCHAR(50),
    status              VARCHAR(30)
);

CREATE INDEX IF NOT EXISTS idx_contracts_project ON contracts(project_id);
CREATE INDEX IF NOT EXISTS idx_contracts_contractor ON contracts(contractor_name);
CREATE INDEX IF NOT EXISTS idx_contracts_award_date ON contracts(award_date);
