-- Sample Answer Key for Practice Project: Corridor Traffic and Safety Analysis
-- These are representative solutions, not the only correct ones.

-- Deliverable 1: top corridors by traffic and truck exposure
WITH station_base AS (
    SELECT
        t.station_id,
        t.count_year,
        t.route,
        t.county,
        t.aadt_total,
        tt.truck_aadt_total,
        tt.truck_pct_total,
        tt.eal
    FROM traffic_counts t
    LEFT JOIN truck_traffic tt
        ON t.station_id = tt.station_id
       AND t.count_year = tt.count_year
),
corridor_summary AS (
    SELECT
        route,
        county,
        COUNT(*) AS station_count,
        AVG(aadt_total) AS avg_aadt_total,
        AVG(truck_pct_total) AS avg_truck_pct_total,
        SUM(eal) AS total_eal
    FROM station_base
    GROUP BY route, county
)
SELECT
    route,
    county,
    station_count,
    avg_aadt_total,
    avg_truck_pct_total,
    total_eal
FROM corridor_summary
ORDER BY total_eal DESC NULLS LAST, avg_aadt_total DESC NULLS LAST
LIMIT 15;
-- Expected output (first 5 rows, illustrative):
-- route | county      | station_count | avg_aadt_total | avg_truck_pct_total | total_eal
-- ------+-------------+---------------+----------------+---------------------+----------
-- 5     | LOS ANGELES | 10            | 10             | 10                  | 10       
-- 80    | SAN DIEGO   | 25            | 25             | 25                  | 25       
-- 101   | SACRAMENTO  | 42            | 42             | 42                  | 42       
-- ...


-- Deliverable 2: county safety-risk table
WITH station_base AS (
    SELECT
        t.county,
        t.aadt_total,
        tt.truck_pct_total,
        tt.eal
    FROM traffic_counts t
    LEFT JOIN truck_traffic tt
        ON t.station_id = tt.station_id
       AND t.count_year = tt.count_year
),
county_traffic AS (
    SELECT
        county,
        AVG(aadt_total) AS avg_aadt_total,
        AVG(truck_pct_total) AS avg_truck_pct_total,
        SUM(eal) AS total_eal
    FROM station_base
    GROUP BY county
),
county_crashes AS (
    SELECT
        county,
        COUNT(*) AS crash_count,
        COUNT(CASE WHEN collision_severity = 'fatal' THEN 1 END) AS fatal_crash_count,
        SUM(num_killed) AS total_killed,
        SUM(num_injured) AS total_injured
    FROM crashes
    GROUP BY county
)
SELECT
    ct.county,
    ct.avg_aadt_total,
    ct.avg_truck_pct_total,
    ct.total_eal,
    COALESCE(cc.crash_count, 0) AS crash_count,
    COALESCE(cc.fatal_crash_count, 0) AS fatal_crash_count,
    COALESCE(cc.total_killed, 0) AS total_killed,
    COALESCE(cc.total_injured, 0) AS total_injured
FROM county_traffic ct
LEFT JOIN county_crashes cc
    ON ct.county = cc.county
ORDER BY fatal_crash_count DESC, avg_truck_pct_total DESC NULLS LAST;
-- Expected output (first 5 rows, illustrative):
-- county      | avg_aadt_total | avg_truck_pct_total | total_eal | crash_count | fatal_crash_count | total_killed | ...     
-- ------------+----------------+---------------------+-----------+-------------+-------------------+--------------+---------
-- LOS ANGELES | 10             | 10                  | 10        | 10          | 10                | 10           | Sample A
-- SAN DIEGO   | 25             | 25                  | 25        | 25          | 25                | 25           | Sample B
-- SACRAMENTO  | 42             | 42                  | 42        | 42          | 42                | 42           | Sample C
-- ...


-- Deliverable 3: fatal crash hotspots by county and road
SELECT
    county,
    primary_road,
    COUNT(*) AS crash_count,
    COUNT(CASE WHEN collision_severity = 'fatal' THEN 1 END) AS fatal_crash_count,
    SUM(num_killed) AS total_killed,
    SUM(num_injured) AS total_injured
FROM crashes
GROUP BY county, primary_road
ORDER BY fatal_crash_count DESC, total_killed DESC NULLS LAST
LIMIT 20;
-- Expected output (first 5 rows, illustrative):
-- county      | primary_road | crash_count | fatal_crash_count | total_killed | total_injured
-- ------------+--------------+-------------+-------------------+--------------+--------------
-- LOS ANGELES | Sample A     | 10          | 10                | 10           | 10           
-- SAN DIEGO   | Sample B     | 25          | 25                | 25           | 25           
-- SACRAMENTO  | Sample C     | 42          | 42                | 42           | 42           
-- ...

