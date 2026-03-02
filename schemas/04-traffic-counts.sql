-- ============================================================
-- Traffic Count Data
-- ============================================================
-- Annual Average Daily Traffic (AADT) counts at stations
-- across the California highway system.
-- ============================================================

CREATE TABLE IF NOT EXISTS traffic_counts (
    station_id          VARCHAR(20),
    count_year          INTEGER,
    district            VARCHAR(5),
    county              VARCHAR(50),
    route               VARCHAR(20),
    post_mile           DECIMAL(8, 3),
    description         VARCHAR(200),

    -- Traffic volumes
    aadt_total          INTEGER,    -- annual average daily traffic
    aadt_peak_hour      INTEGER,    -- peak hour volume
    peak_hour           VARCHAR(10),

    -- Vehicle breakdown
    aadt_truck          INTEGER,    -- truck AADT
    truck_pct           DECIMAL(5, 2),

    -- Location
    latitude            DECIMAL(10, 7),
    longitude           DECIMAL(10, 7),

    PRIMARY KEY (station_id, count_year)
);

CREATE INDEX IF NOT EXISTS idx_traffic_county ON traffic_counts(county);
CREATE INDEX IF NOT EXISTS idx_traffic_route ON traffic_counts(route);
CREATE INDEX IF NOT EXISTS idx_traffic_year ON traffic_counts(count_year);
