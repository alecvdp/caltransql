-- ============================================================
-- Load CCRS crash data into crashes / crash_parties / crash_victims
-- ============================================================
-- Expected files (downloaded by scripts/download-data.sh):
--   data/ccrs_crashes.csv
--   data/ccrs_parties.csv
--   data/ccrs_victims.csv
--
-- Strategy:
--   1) Load CSVs into all-text staging tables
--   2) Transform into typed production tables
--   3) Run validation checks (counts, nulls, FK integrity)
-- ============================================================

DROP TABLE IF EXISTS ccrs_crashes_staging;
DROP TABLE IF EXISTS ccrs_parties_staging;
DROP TABLE IF EXISTS ccrs_victims_staging;

CREATE TABLE ccrs_crashes_staging (
    case_id TEXT,
    collision_date TEXT,
    collision_time TEXT,
    county TEXT,
    city TEXT,
    jurisdiction TEXT,
    primary_road TEXT,
    secondary_road TEXT,
    distance TEXT,
    direction TEXT,
    latitude TEXT,
    longitude TEXT,
    collision_type TEXT,
    collision_severity TEXT,
    num_killed TEXT,
    num_injured TEXT,
    party_count TEXT,
    weather TEXT,
    road_surface TEXT,
    road_condition TEXT,
    lighting TEXT,
    primary_cause TEXT,
    pcf_violation TEXT,
    alcohol_involved TEXT,
    pedestrian_involved TEXT,
    bicycle_involved TEXT,
    motorcycle_involved TEXT,
    truck_involved TEXT
);

CREATE TABLE ccrs_parties_staging (
    party_id TEXT,
    case_id TEXT,
    party_number TEXT,
    party_type TEXT,
    at_fault TEXT,
    age TEXT,
    sex TEXT,
    sobriety TEXT,
    direction_of_travel TEXT,
    vehicle_year TEXT,
    vehicle_make TEXT,
    vehicle_type TEXT,
    movement_preceding TEXT,
    party_cause TEXT
);

CREATE TABLE ccrs_victims_staging (
    victim_id TEXT,
    case_id TEXT,
    party_id TEXT,
    victim_number TEXT,
    victim_role TEXT,
    victim_sex TEXT,
    victim_age TEXT,
    victim_degree_of_injury TEXT,
    victim_seating_position TEXT,
    victim_safety_equipment TEXT
);

\COPY ccrs_crashes_staging FROM 'data/ccrs_crashes.csv' WITH (FORMAT csv, HEADER true, NULL '');
\COPY ccrs_parties_staging FROM 'data/ccrs_parties.csv' WITH (FORMAT csv, HEADER true, NULL '');
\COPY ccrs_victims_staging FROM 'data/ccrs_victims.csv' WITH (FORMAT csv, HEADER true, NULL '');

-- Helper casting function for flexible boolean parsing.
DROP FUNCTION IF EXISTS parse_bool(TEXT);
CREATE FUNCTION parse_bool(v TEXT)
RETURNS BOOLEAN
LANGUAGE SQL
IMMUTABLE
AS $$
    SELECT CASE
        WHEN v IS NULL THEN NULL
        WHEN lower(trim(v)) IN ('1', 't', 'true', 'y', 'yes') THEN TRUE
        WHEN lower(trim(v)) IN ('0', 'f', 'false', 'n', 'no') THEN FALSE
        ELSE NULL
    END;
$$;

TRUNCATE TABLE crash_victims, crash_parties, crashes RESTART IDENTITY CASCADE;

INSERT INTO crashes (
    case_id,
    collision_date,
    collision_time,
    county,
    city,
    jurisdiction,
    primary_road,
    secondary_road,
    distance,
    direction,
    latitude,
    longitude,
    collision_type,
    collision_severity,
    num_killed,
    num_injured,
    party_count,
    weather,
    road_surface,
    road_condition,
    lighting,
    primary_cause,
    pcf_violation,
    alcohol_involved,
    pedestrian_involved,
    bicycle_involved,
    motorcycle_involved,
    truck_involved
)
SELECT
    NULLIF(TRIM(case_id), ''),
    NULLIF(TRIM(collision_date), '')::DATE,
    NULLIF(TRIM(collision_time), '')::TIME,
    NULLIF(TRIM(county), ''),
    NULLIF(TRIM(city), ''),
    NULLIF(TRIM(jurisdiction), ''),
    NULLIF(TRIM(primary_road), ''),
    NULLIF(TRIM(secondary_road), ''),
    NULLIF(TRIM(distance), '')::DECIMAL(8, 2),
    NULLIF(TRIM(direction), ''),
    NULLIF(TRIM(latitude), '')::DECIMAL(10, 7),
    NULLIF(TRIM(longitude), '')::DECIMAL(10, 7),
    NULLIF(TRIM(collision_type), ''),
    NULLIF(TRIM(collision_severity), ''),
    NULLIF(TRIM(num_killed), '')::INTEGER,
    NULLIF(TRIM(num_injured), '')::INTEGER,
    NULLIF(TRIM(party_count), '')::INTEGER,
    NULLIF(TRIM(weather), ''),
    NULLIF(TRIM(road_surface), ''),
    NULLIF(TRIM(road_condition), ''),
    NULLIF(TRIM(lighting), ''),
    NULLIF(TRIM(primary_cause), ''),
    NULLIF(TRIM(pcf_violation), ''),
    parse_bool(alcohol_involved),
    parse_bool(pedestrian_involved),
    parse_bool(bicycle_involved),
    parse_bool(motorcycle_involved),
    parse_bool(truck_involved)
FROM ccrs_crashes_staging
WHERE NULLIF(TRIM(case_id), '') IS NOT NULL;

INSERT INTO crash_parties (
    party_id,
    case_id,
    party_number,
    party_type,
    at_fault,
    age,
    sex,
    sobriety,
    direction_of_travel,
    vehicle_year,
    vehicle_make,
    vehicle_type,
    movement_preceding,
    party_cause
)
SELECT
    NULLIF(TRIM(party_id), ''),
    NULLIF(TRIM(case_id), ''),
    NULLIF(TRIM(party_number), '')::INTEGER,
    NULLIF(TRIM(party_type), ''),
    parse_bool(at_fault),
    NULLIF(TRIM(age), '')::INTEGER,
    NULLIF(TRIM(sex), ''),
    NULLIF(TRIM(sobriety), ''),
    NULLIF(TRIM(direction_of_travel), ''),
    NULLIF(TRIM(vehicle_year), '')::INTEGER,
    NULLIF(TRIM(vehicle_make), ''),
    NULLIF(TRIM(vehicle_type), ''),
    NULLIF(TRIM(movement_preceding), ''),
    NULLIF(TRIM(party_cause), '')
FROM ccrs_parties_staging
WHERE NULLIF(TRIM(party_id), '') IS NOT NULL
  AND NULLIF(TRIM(case_id), '') IS NOT NULL;

INSERT INTO crash_victims (
    victim_id,
    case_id,
    party_id,
    victim_number,
    victim_role,
    victim_sex,
    victim_age,
    victim_degree_of_injury,
    victim_seating_position,
    victim_safety_equipment
)
SELECT
    NULLIF(TRIM(victim_id), ''),
    NULLIF(TRIM(case_id), ''),
    NULLIF(TRIM(party_id), ''),
    NULLIF(TRIM(victim_number), '')::INTEGER,
    NULLIF(TRIM(victim_role), ''),
    NULLIF(TRIM(victim_sex), ''),
    NULLIF(TRIM(victim_age), '')::INTEGER,
    NULLIF(TRIM(victim_degree_of_injury), ''),
    NULLIF(TRIM(victim_seating_position), ''),
    NULLIF(TRIM(victim_safety_equipment), '')
FROM ccrs_victims_staging
WHERE NULLIF(TRIM(victim_id), '') IS NOT NULL
  AND NULLIF(TRIM(case_id), '') IS NOT NULL;

-- Validation checks
SELECT 'crashes_count' AS check_name, COUNT(*)::BIGINT AS value FROM crashes
UNION ALL
SELECT 'crash_parties_count', COUNT(*)::BIGINT FROM crash_parties
UNION ALL
SELECT 'crash_victims_count', COUNT(*)::BIGINT FROM crash_victims
UNION ALL
SELECT 'crashes_null_case_id', COUNT(*)::BIGINT FROM crashes WHERE case_id IS NULL
UNION ALL
SELECT 'crash_parties_null_party_id', COUNT(*)::BIGINT FROM crash_parties WHERE party_id IS NULL
UNION ALL
SELECT 'crash_victims_null_victim_id', COUNT(*)::BIGINT FROM crash_victims WHERE victim_id IS NULL
UNION ALL
SELECT 'orphan_parties_missing_crash', COUNT(*)::BIGINT
FROM crash_parties p
LEFT JOIN crashes c ON c.case_id = p.case_id
WHERE c.case_id IS NULL
UNION ALL
SELECT 'orphan_victims_missing_crash', COUNT(*)::BIGINT
FROM crash_victims v
LEFT JOIN crashes c ON c.case_id = v.case_id
WHERE c.case_id IS NULL
UNION ALL
SELECT 'orphan_victims_missing_party', COUNT(*)::BIGINT
FROM crash_victims v
LEFT JOIN crash_parties p ON p.party_id = v.party_id
WHERE p.party_id IS NULL;

DROP TABLE ccrs_crashes_staging;
DROP TABLE ccrs_parties_staging;
DROP TABLE ccrs_victims_staging;
DROP FUNCTION parse_bool(TEXT);
