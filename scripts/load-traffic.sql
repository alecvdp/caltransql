-- ============================================================
-- Load Caltrans AADT + truck AADT data
-- ============================================================
-- Expected files (downloaded by scripts/download-data.sh):
--   data/traffic_aadt.csv
--   data/truck_aadt.csv
--
-- Strategy:
--   1) Load CSVs into all-text staging tables
--   2) Transform/cast into typed production tables
--   3) Upsert on (station_id, count_year)
-- ============================================================

DROP TABLE IF EXISTS traffic_counts_staging;
DROP TABLE IF EXISTS truck_traffic_staging;

CREATE TEMP TABLE traffic_counts_staging (
    objectid TEXT,
    district TEXT,
    rte TEXT,
    rte_sfx TEXT,
    cnty TEXT,
    pm_pfx TEXT,
    pm TEXT,
    pm_sfx TEXT,
    description TEXT,
    back_peak_hour TEXT,
    back_peak_madt TEXT,
    back_aadt TEXT,
    ahead_peak_hour TEXT,
    ahead_peak_madt TEXT,
    ahead_aadt TEXT
);

CREATE TEMP TABLE truck_traffic_staging (
    objectid TEXT,
    rte TEXT,
    rte_sfx TEXT,
    dist TEXT,
    cnty TEXT,
    pm_pfx TEXT,
    postmile TEXT,
    pm_sfx TEXT,
    leg TEXT,
    description TEXT,
    vehicle_aadt_total TEXT,
    tot_trk_aadt TEXT,
    trk_percent_tot TEXT,
    trk_2_axle TEXT,
    trk_2_axle_pct TEXT,
    trk_3_axle TEXT,
    trk_3_axle_pct TEXT,
    trk_4_axle TEXT,
    trk_4_axle_pct TEXT,
    trk_5_axle TEXT,
    trk_5_axle_pct TEXT,
    eal TEXT,
    est_year TEXT,
    est_code TEXT
);

\COPY traffic_counts_staging FROM 'data/traffic_aadt.csv' WITH (FORMAT csv, HEADER true, NULL '');
\COPY truck_traffic_staging FROM 'data/truck_aadt.csv' WITH (FORMAT csv, HEADER true, NULL '');

-- Flexible numeric parsing helpers (created in pg_temp so they auto-drop at session end).
DROP FUNCTION IF EXISTS pg_temp.parse_int(TEXT);
CREATE FUNCTION pg_temp.parse_int(v TEXT)
RETURNS INTEGER
LANGUAGE SQL
IMMUTABLE
AS $$
    SELECT CASE
        WHEN v IS NULL THEN NULL
        WHEN trim(v) = '' THEN NULL
        WHEN regexp_replace(v, '[^0-9\-]', '', 'g') = '' THEN NULL
        ELSE regexp_replace(v, '[^0-9\-]', '', 'g')::INTEGER
    END;
$$;

DROP FUNCTION IF EXISTS pg_temp.parse_dec(TEXT);
CREATE FUNCTION pg_temp.parse_dec(v TEXT)
RETURNS DECIMAL
LANGUAGE SQL
IMMUTABLE
AS $$
    SELECT CASE
        WHEN v IS NULL THEN NULL
        WHEN trim(v) = '' THEN NULL
        WHEN regexp_replace(v, '[^0-9\.\-]', '', 'g') IN ('', '-', '.', '-.') THEN NULL
        ELSE regexp_replace(v, '[^0-9\.\-]', '', 'g')::DECIMAL
    END;
$$;

-- Traffic AADT source currently publishes one snapshot year.
-- Allow override from shell: TRAFFIC_COUNT_YEAR=2025 ./scripts/load-data.sh
\getenv traffic_count_year TRAFFIC_COUNT_YEAR
\if :{?traffic_count_year}
\else
\set traffic_count_year 2025
\endif

INSERT INTO traffic_counts (
    station_id,
    count_year,
    district,
    county,
    route,
    post_mile,
    description,
    aadt_total,
    aadt_peak_hour,
    peak_hour,
    aadt_truck,
    truck_pct,
    latitude,
    longitude
)
SELECT
    LEFT(
        md5(
            concat_ws(
                '|',
                NULLIF(TRIM(rte), ''),
                NULLIF(TRIM(rte_sfx), ''),
                NULLIF(TRIM(cnty), ''),
                NULLIF(TRIM(pm_pfx), ''),
                NULLIF(TRIM(pm), ''),
                NULLIF(TRIM(pm_sfx), '')
            )
        ),
        20
    ) AS station_id,
    :'traffic_count_year'::INTEGER AS count_year,
    NULLIF(TRIM(district), ''),
    NULLIF(TRIM(cnty), ''),
    NULLIF(TRIM(rte), ''),
    pg_temp.parse_dec(pm)::DECIMAL(8, 3),
    NULLIF(TRIM(description), ''),
    pg_temp.parse_int(ahead_aadt),
    pg_temp.parse_int(ahead_peak_madt),
    NULLIF(TRIM(ahead_peak_hour), ''),
    NULL,
    NULL,
    NULL,
    NULL
FROM traffic_counts_staging
WHERE COALESCE(NULLIF(TRIM(rte), ''), NULLIF(TRIM(description), '')) IS NOT NULL
ON CONFLICT (station_id, count_year) DO UPDATE SET
    district = EXCLUDED.district,
    county = EXCLUDED.county,
    route = EXCLUDED.route,
    post_mile = EXCLUDED.post_mile,
    description = EXCLUDED.description,
    aadt_total = EXCLUDED.aadt_total,
    aadt_peak_hour = EXCLUDED.aadt_peak_hour,
    peak_hour = EXCLUDED.peak_hour,
    aadt_truck = EXCLUDED.aadt_truck,
    truck_pct = EXCLUDED.truck_pct,
    latitude = EXCLUDED.latitude,
    longitude = EXCLUDED.longitude;

INSERT INTO truck_traffic (
    station_id,
    count_year,
    district,
    county,
    route,
    post_mile,
    description,
    vehicle_aadt_total,
    truck_aadt_total,
    truck_pct_total,
    truck_2_axle,
    truck_2_axle_pct,
    truck_3_axle,
    truck_3_axle_pct,
    truck_4_axle,
    truck_4_axle_pct,
    truck_5_axle,
    truck_5_axle_pct,
    eal,
    latitude,
    longitude
)
SELECT
    LEFT(
        md5(
            concat_ws(
                '|',
                NULLIF(TRIM(rte), ''),
                NULLIF(TRIM(rte_sfx), ''),
                NULLIF(TRIM(cnty), ''),
                NULLIF(TRIM(pm_pfx), ''),
                NULLIF(TRIM(postmile), ''),
                NULLIF(TRIM(pm_sfx), '')
            )
        ),
        20
    ) AS station_id,
    pg_temp.parse_int(est_year) AS count_year,
    NULLIF(TRIM(dist), ''),
    NULLIF(TRIM(cnty), ''),
    NULLIF(TRIM(rte), ''),
    pg_temp.parse_dec(postmile)::DECIMAL(8, 3),
    NULLIF(TRIM(description), ''),
    pg_temp.parse_int(vehicle_aadt_total),
    pg_temp.parse_int(tot_trk_aadt),
    pg_temp.parse_dec(trk_percent_tot)::DECIMAL(5, 2),
    pg_temp.parse_int(trk_2_axle),
    pg_temp.parse_dec(trk_2_axle_pct)::DECIMAL(5, 2),
    pg_temp.parse_int(trk_3_axle),
    pg_temp.parse_dec(trk_3_axle_pct)::DECIMAL(5, 2),
    pg_temp.parse_int(trk_4_axle),
    pg_temp.parse_dec(trk_4_axle_pct)::DECIMAL(5, 2),
    pg_temp.parse_int(trk_5_axle),
    pg_temp.parse_dec(trk_5_axle_pct)::DECIMAL(5, 2),
    pg_temp.parse_dec(eal)::DECIMAL(15, 2),
    NULL,
    NULL
FROM truck_traffic_staging
WHERE pg_temp.parse_int(est_year) IS NOT NULL
ON CONFLICT (station_id, count_year) DO UPDATE SET
    district = EXCLUDED.district,
    county = EXCLUDED.county,
    route = EXCLUDED.route,
    post_mile = EXCLUDED.post_mile,
    description = EXCLUDED.description,
    vehicle_aadt_total = EXCLUDED.vehicle_aadt_total,
    truck_aadt_total = EXCLUDED.truck_aadt_total,
    truck_pct_total = EXCLUDED.truck_pct_total,
    truck_2_axle = EXCLUDED.truck_2_axle,
    truck_2_axle_pct = EXCLUDED.truck_2_axle_pct,
    truck_3_axle = EXCLUDED.truck_3_axle,
    truck_3_axle_pct = EXCLUDED.truck_3_axle_pct,
    truck_4_axle = EXCLUDED.truck_4_axle,
    truck_4_axle_pct = EXCLUDED.truck_4_axle_pct,
    truck_5_axle = EXCLUDED.truck_5_axle,
    truck_5_axle_pct = EXCLUDED.truck_5_axle_pct,
    eal = EXCLUDED.eal,
    latitude = EXCLUDED.latitude,
    longitude = EXCLUDED.longitude;

SELECT 'traffic_counts' AS table_name, COUNT(*)::BIGINT AS row_count FROM traffic_counts
UNION ALL
SELECT 'truck_traffic', COUNT(*)::BIGINT FROM truck_traffic;

DROP TABLE IF EXISTS traffic_counts_staging;
DROP TABLE IF EXISTS truck_traffic_staging;
DROP FUNCTION IF EXISTS pg_temp.parse_int(TEXT);
DROP FUNCTION IF EXISTS pg_temp.parse_dec(TEXT);
