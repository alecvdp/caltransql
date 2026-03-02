-- ============================================================
-- Caltrans Truck Volumes AADT
-- Source: data.ca.gov / Caltrans GIS Open Data
-- ============================================================
-- Truck traffic with axle-class breakdown.
-- The EAL (Equivalent Axle Load) field is used in pavement
-- thickness design - directly relevant to construction engineering.
-- ============================================================

CREATE TABLE IF NOT EXISTS truck_traffic (
    station_id          VARCHAR(20),
    count_year          INTEGER,
    district            VARCHAR(5),
    county              VARCHAR(50),
    route               VARCHAR(20),
    post_mile           DECIMAL(8, 3),
    description         VARCHAR(200),

    -- Total volumes
    vehicle_aadt_total  INTEGER,
    truck_aadt_total    INTEGER,
    truck_pct_total     DECIMAL(5, 2),

    -- Axle class breakdown
    truck_2_axle        INTEGER,
    truck_2_axle_pct    DECIMAL(5, 2),
    truck_3_axle        INTEGER,
    truck_3_axle_pct    DECIMAL(5, 2),
    truck_4_axle        INTEGER,
    truck_4_axle_pct    DECIMAL(5, 2),
    truck_5_axle        INTEGER,
    truck_5_axle_pct    DECIMAL(5, 2),

    -- Equivalent Axle Load (for pavement design)
    eal                 DECIMAL(15, 2),

    -- Location
    latitude            DECIMAL(10, 7),
    longitude           DECIMAL(10, 7),

    PRIMARY KEY (station_id, count_year)
);

CREATE INDEX IF NOT EXISTS idx_truck_county ON truck_traffic(county);
CREATE INDEX IF NOT EXISTS idx_truck_route ON truck_traffic(route);
