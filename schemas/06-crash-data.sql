-- ============================================================
-- California Crash Reporting System (CCRS)
-- Source: data.ca.gov - https://data.ca.gov/dataset/ccrs
-- ============================================================
-- Three linked tables: crashes -> parties -> victims
-- Replaced SWITRS in January 2025.
-- Excellent for practicing multi-table JOINs.
-- ============================================================

CREATE TABLE IF NOT EXISTS crashes (
    case_id             VARCHAR(30) PRIMARY KEY,
    collision_date      DATE,
    collision_time      TIME,
    county              VARCHAR(50),
    city                VARCHAR(100),
    jurisdiction        VARCHAR(10),

    -- Location
    primary_road        VARCHAR(200),
    secondary_road      VARCHAR(200),
    distance            DECIMAL(8, 2),
    direction           VARCHAR(10),
    latitude            DECIMAL(10, 7),
    longitude           DECIMAL(10, 7),

    -- Collision details
    collision_type      VARCHAR(50),
    collision_severity  VARCHAR(30),   -- fatal, severe injury, etc.
    num_killed          INTEGER,
    num_injured         INTEGER,
    party_count         INTEGER,

    -- Conditions
    weather             VARCHAR(30),
    road_surface        VARCHAR(30),
    road_condition      VARCHAR(30),
    lighting            VARCHAR(30),

    -- Primary cause
    primary_cause       VARCHAR(100),
    pcf_violation       VARCHAR(20),   -- primary collision factor

    -- Flags
    alcohol_involved    BOOLEAN,
    pedestrian_involved BOOLEAN,
    bicycle_involved    BOOLEAN,
    motorcycle_involved BOOLEAN,
    truck_involved      BOOLEAN
);

CREATE TABLE IF NOT EXISTS crash_parties (
    party_id            VARCHAR(30) PRIMARY KEY,
    case_id             VARCHAR(30) REFERENCES crashes(case_id),
    party_number        INTEGER,

    party_type          VARCHAR(30),   -- driver, pedestrian, bicyclist, parked
    at_fault            BOOLEAN,
    age                 INTEGER,
    sex                 VARCHAR(10),
    sobriety            VARCHAR(30),
    direction_of_travel VARCHAR(20),

    vehicle_year        INTEGER,
    vehicle_make        VARCHAR(50),
    vehicle_type        VARCHAR(50),

    movement_preceding  VARCHAR(50),
    party_cause         VARCHAR(100)
);

CREATE TABLE IF NOT EXISTS crash_victims (
    victim_id           VARCHAR(30) PRIMARY KEY,
    case_id             VARCHAR(30) REFERENCES crashes(case_id),
    party_id            VARCHAR(30) REFERENCES crash_parties(party_id),
    victim_number       INTEGER,

    victim_role         VARCHAR(20),   -- driver, passenger, pedestrian
    victim_sex          VARCHAR(10),
    victim_age          INTEGER,
    victim_degree_of_injury VARCHAR(30),
    victim_seating_position VARCHAR(30),
    victim_safety_equipment VARCHAR(50)
);

CREATE INDEX IF NOT EXISTS idx_crashes_date ON crashes(collision_date);
CREATE INDEX IF NOT EXISTS idx_crashes_county ON crashes(county);
CREATE INDEX IF NOT EXISTS idx_crashes_severity ON crashes(collision_severity);
CREATE INDEX IF NOT EXISTS idx_crash_parties_case ON crash_parties(case_id);
CREATE INDEX IF NOT EXISTS idx_crash_victims_case ON crash_victims(case_id);
