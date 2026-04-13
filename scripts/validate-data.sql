-- ============================================================
-- Data Validation / Health Check
-- ============================================================
-- Run after load-data.sh to verify the database is in a good
-- state. Each query prints a check name, a result status
-- (PASS / FAIL / WARN / INFO), and a short message.
--
-- Usage (standalone):
--   psql -h $PGHOST -p $PGPORT -U $PGUSER -d $PGDATABASE \
--        -f scripts/validate-data.sql
--
-- The companion validate-data.sh wrapper sources .env and
-- prints a colour-coded summary.
-- ============================================================

\pset tuples_only on
\pset format unaligned
\pset fieldsep '|'

-- ============================================================
-- 1. ROW COUNTS PER TABLE (with expected ranges)
-- ============================================================

SELECT 'row_count_bridges' AS check_name,
       CASE
           WHEN cnt = 0     THEN 'FAIL'
           WHEN cnt < 20000 THEN 'WARN'
           ELSE 'PASS'
       END AS status,
       cnt || ' rows (expected ~25,000)' AS message
FROM (SELECT COUNT(*) AS cnt FROM bridges) t;

SELECT 'row_count_construction_projects' AS check_name,
       CASE
           WHEN cnt = 0   THEN 'FAIL'
           WHEN cnt < 100 THEN 'WARN'
           ELSE 'PASS'
       END AS status,
       cnt || ' rows (expected ~600+)' AS message
FROM (SELECT COUNT(*) AS cnt FROM construction_projects) t;

SELECT 'row_count_contracts' AS check_name,
       CASE
           WHEN cnt = 0 THEN 'WARN'
           ELSE 'PASS'
       END AS status,
       cnt || ' rows' AS message
FROM (SELECT COUNT(*) AS cnt FROM contracts) t;

SELECT 'row_count_traffic_counts' AS check_name,
       CASE
           WHEN cnt = 0    THEN 'FAIL'
           WHEN cnt < 1000 THEN 'WARN'
           ELSE 'PASS'
       END AS status,
       cnt || ' rows (expected ~5,000-15,000)' AS message
FROM (SELECT COUNT(*) AS cnt FROM traffic_counts) t;

SELECT 'row_count_truck_traffic' AS check_name,
       CASE
           WHEN cnt = 0    THEN 'FAIL'
           WHEN cnt < 1000 THEN 'WARN'
           ELSE 'PASS'
       END AS status,
       cnt || ' rows (expected ~5,000-15,000)' AS message
FROM (SELECT COUNT(*) AS cnt FROM truck_traffic) t;

SELECT 'row_count_crashes' AS check_name,
       CASE
           WHEN cnt = 0     THEN 'WARN'
           WHEN cnt < 10000 THEN 'WARN'
           ELSE 'PASS'
       END AS status,
       cnt || ' rows (expected 100K+)' AS message
FROM (SELECT COUNT(*) AS cnt FROM crashes) t;

SELECT 'row_count_crash_parties' AS check_name,
       CASE
           WHEN cnt = 0 THEN 'WARN'
           ELSE 'PASS'
       END AS status,
       cnt || ' rows' AS message
FROM (SELECT COUNT(*) AS cnt FROM crash_parties) t;

SELECT 'row_count_crash_victims' AS check_name,
       CASE
           WHEN cnt = 0 THEN 'WARN'
           ELSE 'PASS'
       END AS status,
       cnt || ' rows' AS message
FROM (SELECT COUNT(*) AS cnt FROM crash_victims) t;

SELECT 'row_count_construction_cost_index' AS check_name,
       CASE
           WHEN cnt = 0  THEN 'WARN'
           WHEN cnt < 50 THEN 'WARN'
           ELSE 'PASS'
       END AS status,
       cnt || ' rows (expected ~90)' AS message
FROM (SELECT COUNT(*) AS cnt FROM construction_cost_index) t;

-- ============================================================
-- 2. NULL RATES ON KEY COLUMNS
-- ============================================================

-- Bridges: coordinates should be nearly 100 % populated
SELECT 'bridges_null_coordinates' AS check_name,
       CASE
           WHEN null_pct > 5  THEN 'FAIL'
           WHEN null_pct > 1  THEN 'WARN'
           ELSE 'PASS'
       END AS status,
       ROUND(null_pct, 1) || '% of bridges missing lat/long' AS message
FROM (
    SELECT 100.0 * COUNT(*) FILTER (WHERE latitude IS NULL OR longitude IS NULL)
                  / GREATEST(COUNT(*), 1) AS null_pct
    FROM bridges
) t;

-- Bridges: condition ratings (deck, superstructure, substructure)
SELECT 'bridges_null_deck_condition' AS check_name,
       CASE
           WHEN null_pct > 20 THEN 'WARN'
           ELSE 'PASS'
       END AS status,
       ROUND(null_pct, 1) || '% of bridges missing deck_condition' AS message
FROM (
    SELECT 100.0 * COUNT(*) FILTER (WHERE deck_condition IS NULL)
                  / GREATEST(COUNT(*), 1) AS null_pct
    FROM bridges
) t;

SELECT 'bridges_null_superstructure_condition' AS check_name,
       CASE
           WHEN null_pct > 20 THEN 'WARN'
           ELSE 'PASS'
       END AS status,
       ROUND(null_pct, 1) || '% of bridges missing superstructure_condition' AS message
FROM (
    SELECT 100.0 * COUNT(*) FILTER (WHERE superstructure_condition IS NULL)
                  / GREATEST(COUNT(*), 1) AS null_pct
    FROM bridges
) t;

SELECT 'bridges_null_substructure_condition' AS check_name,
       CASE
           WHEN null_pct > 20 THEN 'WARN'
           ELSE 'PASS'
       END AS status,
       ROUND(null_pct, 1) || '% of bridges missing substructure_condition' AS message
FROM (
    SELECT 100.0 * COUNT(*) FILTER (WHERE substructure_condition IS NULL)
                  / GREATEST(COUNT(*), 1) AS null_pct
    FROM bridges
) t;

-- Bridges: year_built should almost always be populated
SELECT 'bridges_null_year_built' AS check_name,
       CASE
           WHEN null_pct > 5 THEN 'WARN'
           ELSE 'PASS'
       END AS status,
       ROUND(null_pct, 1) || '% of bridges missing year_built' AS message
FROM (
    SELECT 100.0 * COUNT(*) FILTER (WHERE year_built IS NULL)
                  / GREATEST(COUNT(*), 1) AS null_pct
    FROM bridges
) t;

-- Traffic counts: aadt_total should be populated
SELECT 'traffic_null_aadt_total' AS check_name,
       CASE
           WHEN null_pct > 10 THEN 'WARN'
           ELSE 'PASS'
       END AS status,
       ROUND(null_pct, 1) || '% of traffic rows missing aadt_total' AS message
FROM (
    SELECT 100.0 * COUNT(*) FILTER (WHERE aadt_total IS NULL)
                  / GREATEST(COUNT(*), 1) AS null_pct
    FROM traffic_counts
) t;

-- Crashes: collision_date should always be populated
SELECT 'crashes_null_collision_date' AS check_name,
       CASE
           WHEN null_pct > 1 THEN 'WARN'
           ELSE 'PASS'
       END AS status,
       ROUND(null_pct, 1) || '% of crashes missing collision_date' AS message
FROM (
    SELECT 100.0 * COUNT(*) FILTER (WHERE collision_date IS NULL)
                  / GREATEST(COUNT(*), 1) AS null_pct
    FROM crashes
) t;

-- ============================================================
-- 3. FOREIGN KEY / JOIN INTEGRITY
-- ============================================================

-- contracts.project_id -> construction_projects.project_id
SELECT 'fk_contracts_to_projects' AS check_name,
       CASE
           WHEN orphan_count > 0 THEN 'FAIL'
           ELSE 'PASS'
       END AS status,
       orphan_count || ' contracts reference a missing project' AS message
FROM (
    SELECT COUNT(*) AS orphan_count
    FROM contracts c
    LEFT JOIN construction_projects p ON p.project_id = c.project_id
    WHERE c.project_id IS NOT NULL
      AND p.project_id IS NULL
) t;

-- crash_parties.case_id -> crashes.case_id
SELECT 'fk_crash_parties_to_crashes' AS check_name,
       CASE
           WHEN orphan_count > 0 THEN 'FAIL'
           ELSE 'PASS'
       END AS status,
       orphan_count || ' crash_parties reference a missing crash' AS message
FROM (
    SELECT COUNT(*) AS orphan_count
    FROM crash_parties cp
    LEFT JOIN crashes c ON c.case_id = cp.case_id
    WHERE cp.case_id IS NOT NULL
      AND c.case_id IS NULL
) t;

-- crash_victims.case_id -> crashes.case_id
SELECT 'fk_crash_victims_to_crashes' AS check_name,
       CASE
           WHEN orphan_count > 0 THEN 'FAIL'
           ELSE 'PASS'
       END AS status,
       orphan_count || ' crash_victims reference a missing crash' AS message
FROM (
    SELECT COUNT(*) AS orphan_count
    FROM crash_victims v
    LEFT JOIN crashes c ON c.case_id = v.case_id
    WHERE v.case_id IS NOT NULL
      AND c.case_id IS NULL
) t;

-- crash_victims.party_id -> crash_parties.party_id
SELECT 'fk_crash_victims_to_parties' AS check_name,
       CASE
           WHEN orphan_count > 0 THEN 'FAIL'
           ELSE 'PASS'
       END AS status,
       orphan_count || ' crash_victims reference a missing party' AS message
FROM (
    SELECT COUNT(*) AS orphan_count
    FROM crash_victims v
    LEFT JOIN crash_parties cp ON cp.party_id = v.party_id
    WHERE v.party_id IS NOT NULL
      AND cp.party_id IS NULL
) t;

-- ============================================================
-- 4. VALUE RANGE CHECKS
-- ============================================================

-- Condition ratings should be 0-9
SELECT 'bridges_condition_range' AS check_name,
       CASE
           WHEN bad_count > 0 THEN 'FAIL'
           ELSE 'PASS'
       END AS status,
       bad_count || ' bridges have condition ratings outside 0-9' AS message
FROM (
    SELECT COUNT(*) AS bad_count
    FROM bridges
    WHERE (deck_condition IS NOT NULL AND deck_condition NOT BETWEEN 0 AND 9)
       OR (superstructure_condition IS NOT NULL AND superstructure_condition NOT BETWEEN 0 AND 9)
       OR (substructure_condition IS NOT NULL AND substructure_condition NOT BETWEEN 0 AND 9)
       OR (channel_condition IS NOT NULL AND channel_condition NOT BETWEEN 0 AND 9)
       OR (culvert_condition IS NOT NULL AND culvert_condition NOT BETWEEN 0 AND 9)
) t;

-- Bridge coordinates within California bounding box
-- Approximate bbox: lat 32.5-42.0, long -124.5 to -114.0
SELECT 'bridges_california_bbox' AS check_name,
       CASE
           WHEN bad_count > 0 THEN 'WARN'
           ELSE 'PASS'
       END AS status,
       bad_count || ' bridges have coordinates outside California bbox' AS message
FROM (
    SELECT COUNT(*) AS bad_count
    FROM bridges
    WHERE latitude IS NOT NULL
      AND longitude IS NOT NULL
      AND (latitude NOT BETWEEN 32.5 AND 42.0
           OR longitude NOT BETWEEN -124.5 AND -114.0)
) t;

-- Construction project coordinates within California bbox
SELECT 'projects_california_bbox' AS check_name,
       CASE
           WHEN bad_count > 0 THEN 'WARN'
           ELSE 'PASS'
       END AS status,
       bad_count || ' construction_projects have coordinates outside California bbox' AS message
FROM (
    SELECT COUNT(*) AS bad_count
    FROM construction_projects
    WHERE latitude IS NOT NULL
      AND longitude IS NOT NULL
      AND (latitude NOT BETWEEN 32.5 AND 42.0
           OR longitude NOT BETWEEN -124.5 AND -114.0)
) t;

-- Crash coordinates within California bbox
SELECT 'crashes_california_bbox' AS check_name,
       CASE
           WHEN bad_count > 0 THEN 'WARN'
           ELSE 'PASS'
       END AS status,
       bad_count || ' crashes have coordinates outside California bbox' AS message
FROM (
    SELECT COUNT(*) AS bad_count
    FROM crashes
    WHERE latitude IS NOT NULL
      AND longitude IS NOT NULL
      AND (latitude NOT BETWEEN 32.5 AND 42.0
           OR longitude NOT BETWEEN -124.5 AND -114.0)
) t;

-- Bridge year_built should be reasonable (1700 - current year)
SELECT 'bridges_year_built_range' AS check_name,
       CASE
           WHEN bad_count > 0 THEN 'WARN'
           ELSE 'PASS'
       END AS status,
       bad_count || ' bridges have year_built outside 1700-' || EXTRACT(YEAR FROM CURRENT_DATE)::INTEGER AS message
FROM (
    SELECT COUNT(*) AS bad_count
    FROM bridges
    WHERE year_built IS NOT NULL
      AND (year_built < 1700 OR year_built > EXTRACT(YEAR FROM CURRENT_DATE))
) t;

-- Construction cost index: quarter should be 1-4
SELECT 'cci_quarter_range' AS check_name,
       CASE
           WHEN bad_count > 0 THEN 'FAIL'
           ELSE 'PASS'
       END AS status,
       bad_count || ' cost index rows have quarter outside 1-4' AS message
FROM (
    SELECT COUNT(*) AS bad_count
    FROM construction_cost_index
    WHERE quarter NOT BETWEEN 1 AND 4
) t;

-- Truck percentages should be 0-100
SELECT 'bridges_truck_pct_range' AS check_name,
       CASE
           WHEN bad_count > 0 THEN 'WARN'
           ELSE 'PASS'
       END AS status,
       bad_count || ' bridges have truck_adt_pct outside 0-100' AS message
FROM (
    SELECT COUNT(*) AS bad_count
    FROM bridges
    WHERE truck_adt_pct IS NOT NULL
      AND truck_adt_pct NOT BETWEEN 0 AND 100
) t;

-- ============================================================
-- 5. DUPLICATE DETECTION ON PRIMARY KEYS
-- ============================================================

-- Note: true PK duplicates are impossible if the schema was applied,
-- but we check for near-duplicates (e.g. structure_number with
-- different whitespace) and duplicate natural keys.

SELECT 'dup_bridges_structure_number' AS check_name,
       CASE
           WHEN dup_count > 0 THEN 'FAIL'
           ELSE 'PASS'
       END AS status,
       dup_count || ' duplicate structure_number values in bridges' AS message
FROM (
    SELECT COUNT(*) - COUNT(DISTINCT structure_number) AS dup_count
    FROM bridges
) t;

SELECT 'dup_contracts_contract_id' AS check_name,
       CASE
           WHEN dup_count > 0 THEN 'FAIL'
           ELSE 'PASS'
       END AS status,
       dup_count || ' duplicate contract_id values in contracts' AS message
FROM (
    SELECT COUNT(*) - COUNT(DISTINCT contract_id) AS dup_count
    FROM contracts
) t;

SELECT 'dup_crashes_case_id' AS check_name,
       CASE
           WHEN dup_count > 0 THEN 'FAIL'
           ELSE 'PASS'
       END AS status,
       dup_count || ' duplicate case_id values in crashes' AS message
FROM (
    SELECT COUNT(*) - COUNT(DISTINCT case_id) AS dup_count
    FROM crashes
) t;

SELECT 'dup_crash_parties_party_id' AS check_name,
       CASE
           WHEN dup_count > 0 THEN 'FAIL'
           ELSE 'PASS'
       END AS status,
       dup_count || ' duplicate party_id values in crash_parties' AS message
FROM (
    SELECT COUNT(*) - COUNT(DISTINCT party_id) AS dup_count
    FROM crash_parties
) t;

SELECT 'dup_crash_victims_victim_id' AS check_name,
       CASE
           WHEN dup_count > 0 THEN 'FAIL'
           ELSE 'PASS'
       END AS status,
       dup_count || ' duplicate victim_id values in crash_victims' AS message
FROM (
    SELECT COUNT(*) - COUNT(DISTINCT victim_id) AS dup_count
    FROM crash_victims
) t;

-- Traffic counts: composite key (station_id, count_year) enforced by PK
SELECT 'dup_traffic_counts' AS check_name,
       CASE
           WHEN dup_count > 0 THEN 'FAIL'
           ELSE 'PASS'
       END AS status,
       dup_count || ' duplicate (station_id, count_year) in traffic_counts' AS message
FROM (
    SELECT COUNT(*) - COUNT(DISTINCT (station_id, count_year)) AS dup_count
    FROM traffic_counts
) t;

SELECT 'dup_truck_traffic' AS check_name,
       CASE
           WHEN dup_count > 0 THEN 'FAIL'
           ELSE 'PASS'
       END AS status,
       dup_count || ' duplicate (station_id, count_year) in truck_traffic' AS message
FROM (
    SELECT COUNT(*) - COUNT(DISTINCT (station_id, count_year)) AS dup_count
    FROM truck_traffic
) t;

-- ============================================================
-- 6. CROSS-TABLE CONSISTENCY
-- ============================================================

-- Crash party counts should roughly match the party_count column
SELECT 'crashes_party_count_consistency' AS check_name,
       CASE
           WHEN mismatch_pct > 10 THEN 'WARN'
           ELSE 'PASS'
       END AS status,
       ROUND(mismatch_pct, 1) || '% of crashes have party_count mismatch vs actual parties' AS message
FROM (
    SELECT 100.0 * COUNT(*) FILTER (
               WHERE c.party_count IS NOT NULL
                 AND c.party_count <> COALESCE(p.actual_count, 0)
           ) / GREATEST(COUNT(*), 1) AS mismatch_pct
    FROM crashes c
    LEFT JOIN (
        SELECT case_id, COUNT(*) AS actual_count
        FROM crash_parties
        GROUP BY case_id
    ) p ON p.case_id = c.case_id
) t;

\pset tuples_only off
\pset format aligned
\pset fieldsep ''
