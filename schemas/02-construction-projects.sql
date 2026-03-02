-- ============================================================
-- Caltrans Construction Projects
-- ============================================================
-- Tracks highway construction and improvement projects.
-- Can be joined with bridges on county or location.
-- ============================================================

CREATE TABLE IF NOT EXISTS construction_projects (
    project_id          VARCHAR(30) PRIMARY KEY,
    district            VARCHAR(5),
    county              VARCHAR(50),
    route               VARCHAR(20),
    post_mile_start     DECIMAL(8, 3),
    post_mile_end       DECIMAL(8, 3),

    -- Project details
    project_description TEXT,
    work_type           VARCHAR(100),   -- e.g., bridge repair, pavement rehab
    program             VARCHAR(100),   -- funding program

    -- Financial
    total_cost          DECIMAL(15, 2),
    engineer_estimate   DECIMAL(15, 2),

    -- Schedule
    approval_date       DATE,
    start_date          DATE,
    completion_date     DATE,
    status              VARCHAR(30),    -- planned, active, completed

    -- Location
    latitude            DECIMAL(10, 7),
    longitude           DECIMAL(10, 7)
);

CREATE INDEX IF NOT EXISTS idx_projects_county ON construction_projects(county);
CREATE INDEX IF NOT EXISTS idx_projects_district ON construction_projects(district);
CREATE INDEX IF NOT EXISTS idx_projects_status ON construction_projects(status);
CREATE INDEX IF NOT EXISTS idx_projects_work_type ON construction_projects(work_type);
