-- ============================================================
-- Exercise 9.1: Spatial Analysis with PostGIS
-- ============================================================
-- Goal:
-- Practice real GIS workflows with transportation data that already
-- includes latitude/longitude columns.
--
-- Tables used:
--   bridges
--   traffic_counts
--   crashes
--   construction_projects
--
-- Important:
-- 1) These exercises require PostGIS.
-- 2) Distances are measured in meters when you cast to geography.
-- ============================================================

-- Optional check:
-- SELECT PostGIS_Version();


-- ----- EXAMPLE -----
-- Find bridges within 10 km of downtown Sacramento.

WITH params AS (
    SELECT ST_SetSRID(ST_MakePoint(-121.4944, 38.5816), 4326)::geography AS center_geog
),
bridge_points AS (
    SELECT
        structure_number,
        county,
        facility_carried,
        ST_SetSRID(ST_MakePoint(longitude, latitude), 4326)::geography AS geog
    FROM bridges
    WHERE latitude IS NOT NULL
      AND longitude IS NOT NULL
)
SELECT
    b.structure_number,
    b.county,
    b.facility_carried,
    ROUND(ST_Distance(b.geog, p.center_geog) / 1000.0, 2) AS distance_km
FROM bridge_points b
CROSS JOIN params p
WHERE ST_DWithin(b.geog, p.center_geog, 10000)
ORDER BY distance_km
LIMIT 25;


-- ----- YOUR TURN -----

-- Q1: Parameterize the "bridges within X km" query.
--     Create a params CTE with:
--       input_latitude, input_longitude, radius_km
--     Return all bridges within radius_km of that point.
--     Include distance_km and sort nearest first.


-- Q2: Cluster bridges by geographic proximity.
--     Use ST_ClusterDBSCAN with:
--       eps = 5000 meters
--       minpoints = 5
--     Return one row per cluster with:
--       cluster_id, bridge_count, avg_deck_condition
--
--     Hint: transform to EPSG:3310 before clustering so units are meters.


-- Q3: For each bridge, find the nearest other bridge on the same
--     facility_carried route.
--     Return:
--       structure_number
--       facility_carried
--       nearest_structure_number
--       nearest_distance_km
--     Limit to 50 rows.


-- Q4: Spatial join crashes near bridges.
--     Count crashes within 1 km of each bridge and include:
--       nearby_crash_count
--       nearby_fatal_crash_count
--       nearby_killed
--       nearby_injured
--     Return the top 25 bridges by nearby_fatal_crash_count.


-- Q5: Find the nearest traffic station for each construction project.
--     Return:
--       project_id
--       county
--       route
--       nearest_station_id
--       nearest_station_route
--       nearest_station_distance_km
--     Limit to 100 rows.


-- ============================================================
-- Stretch Goals
-- ============================================================

-- Stretch 1:
-- Build a county-level "spatial risk" table by combining:
--   - poor bridge counts (deck_condition <= 4)
--   - crashes within 1 km of bridges
--   - average distance from projects to nearest traffic station

-- Stretch 2:
-- Create a simple heatmap grid with ST_SnapToGrid over bridge points.
-- Summarize bridge counts and average condition by grid cell.
