-- Answer Key for Exercise 9.1: Spatial Analysis with PostGIS

-- Q1
WITH params AS (
    SELECT
        38.5816::DECIMAL AS input_latitude,
        -121.4944::DECIMAL AS input_longitude,
        15::DECIMAL AS radius_km
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
    ROUND(
        ST_Distance(
            b.geog,
            ST_SetSRID(ST_MakePoint(p.input_longitude, p.input_latitude), 4326)::geography
        ) / 1000.0,
        2
    ) AS distance_km
FROM bridge_points b
CROSS JOIN params p
WHERE ST_DWithin(
    b.geog,
    ST_SetSRID(ST_MakePoint(p.input_longitude, p.input_latitude), 4326)::geography,
    p.radius_km * 1000
)
ORDER BY distance_km;
-- Expected output (first 5 rows, illustrative):
-- structure_number | county      | facility_carried | distance_km
-- -----------------+-------------+------------------+------------
-- ID-1000          | LOS ANGELES | Sample A         | 10         
-- ID-1001          | SAN DIEGO   | Sample B         | 25         
-- ID-1002          | SACRAMENTO  | Sample C         | 42         
-- ...


-- Q2
WITH bridge_points AS (
    SELECT
        structure_number,
        county,
        deck_condition,
        ST_Transform(ST_SetSRID(ST_MakePoint(longitude, latitude), 4326), 3310) AS geom_3310
    FROM bridges
    WHERE latitude IS NOT NULL
      AND longitude IS NOT NULL
),
clustered AS (
    SELECT
        structure_number,
        county,
        deck_condition,
        ST_ClusterDBSCAN(geom_3310, eps := 5000, minpoints := 5) OVER () AS cluster_id
    FROM bridge_points
)
SELECT
    cluster_id,
    COUNT(*) AS bridge_count,
    ROUND(AVG(deck_condition)::NUMERIC, 2) AS avg_deck_condition
FROM clustered
WHERE cluster_id IS NOT NULL
GROUP BY cluster_id
ORDER BY bridge_count DESC, cluster_id;
-- Expected output (first 5 rows, illustrative):
-- cluster_id | bridge_count | avg_deck_condition
-- -----------+--------------+-------------------
-- ID-1000    | 10           | 10                
-- ID-1001    | 25           | 25                
-- ID-1002    | 42           | 42                
-- ...


-- Q3
WITH bridge_points AS (
    SELECT
        structure_number,
        facility_carried,
        ST_SetSRID(ST_MakePoint(longitude, latitude), 4326)::geography AS geog
    FROM bridges
    WHERE latitude IS NOT NULL
      AND longitude IS NOT NULL
      AND facility_carried IS NOT NULL
)
SELECT
    b.structure_number,
    b.facility_carried,
    n.nearest_structure_number,
    ROUND(n.distance_m / 1000.0, 2) AS nearest_distance_km
FROM bridge_points b
CROSS JOIN LATERAL (
    SELECT
        b2.structure_number AS nearest_structure_number,
        ST_Distance(b.geog, b2.geog) AS distance_m
    FROM bridge_points b2
    WHERE b2.facility_carried = b.facility_carried
      AND b2.structure_number <> b.structure_number
    ORDER BY ST_Distance(b.geog, b2.geog)
    LIMIT 1
) n
ORDER BY nearest_distance_km
LIMIT 50;
-- Expected output (first 5 rows, illustrative):
-- structure_number | facility_carried | nearest_structure_number | nearest_distance_km
-- -----------------+------------------+--------------------------+--------------------
-- ID-1000          | Sample A         | ID-1000                  | 10                 
-- ID-1001          | Sample B         | ID-1001                  | 25                 
-- ID-1002          | Sample C         | ID-1002                  | 42                 
-- ...


-- Q4
WITH bridge_points AS (
    SELECT
        structure_number,
        county,
        facility_carried,
        ST_SetSRID(ST_MakePoint(longitude, latitude), 4326)::geography AS geog
    FROM bridges
    WHERE latitude IS NOT NULL
      AND longitude IS NOT NULL
),
crash_points AS (
    SELECT
        case_id,
        collision_severity,
        COALESCE(num_killed, 0) AS num_killed,
        COALESCE(num_injured, 0) AS num_injured,
        ST_SetSRID(ST_MakePoint(longitude, latitude), 4326)::geography AS geog
    FROM crashes
    WHERE latitude IS NOT NULL
      AND longitude IS NOT NULL
),
nearby_crashes AS (
    SELECT
        b.structure_number,
        b.county,
        b.facility_carried,
        c.case_id,
        c.collision_severity,
        c.num_killed,
        c.num_injured
    FROM bridge_points b
    JOIN crash_points c
        ON ST_DWithin(b.geog, c.geog, 1000)
)
SELECT
    structure_number,
    county,
    facility_carried,
    COUNT(DISTINCT case_id) AS nearby_crash_count,
    COUNT(
        DISTINCT CASE
            WHEN collision_severity ILIKE '%fatal%' THEN case_id
            ELSE NULL
        END
    ) AS nearby_fatal_crash_count,
    SUM(num_killed) AS nearby_killed,
    SUM(num_injured) AS nearby_injured
FROM nearby_crashes
GROUP BY structure_number, county, facility_carried
ORDER BY nearby_fatal_crash_count DESC, nearby_crash_count DESC
LIMIT 25;
-- Expected output (first 5 rows, illustrative):
-- structure_number | county      | facility_carried | nearby_crash_count | nearby_fatal_crash_count | nearby_killed | nearby_injured
-- -----------------+-------------+------------------+--------------------+--------------------------+---------------+---------------
-- ID-1000          | LOS ANGELES | Sample A         | 10                 | 10                       | 10            | 10            
-- ID-1001          | SAN DIEGO   | Sample B         | 25                 | 25                       | 25            | 25            
-- ID-1002          | SACRAMENTO  | Sample C         | 42                 | 42                       | 42            | 42            
-- ...


-- Q5
WITH project_points AS (
    SELECT
        project_id,
        county,
        route,
        ST_SetSRID(ST_MakePoint(longitude, latitude), 4326)::geography AS geog
    FROM construction_projects
    WHERE latitude IS NOT NULL
      AND longitude IS NOT NULL
),
station_points AS (
    SELECT
        station_id,
        route,
        ST_SetSRID(ST_MakePoint(longitude, latitude), 4326)::geography AS geog
    FROM traffic_counts
    WHERE latitude IS NOT NULL
      AND longitude IS NOT NULL
)
SELECT
    p.project_id,
    p.county,
    p.route,
    n.nearest_station_id,
    n.nearest_station_route,
    ROUND(n.distance_m / 1000.0, 2) AS nearest_station_distance_km
FROM project_points p
CROSS JOIN LATERAL (
    SELECT
        s.station_id AS nearest_station_id,
        s.route AS nearest_station_route,
        ST_Distance(p.geog, s.geog) AS distance_m
    FROM station_points s
    ORDER BY ST_Distance(p.geog, s.geog)
    LIMIT 1
) n
ORDER BY nearest_station_distance_km
LIMIT 100;
-- Expected output (first 5 rows, illustrative):
-- project_id | county      | route | nearest_station_id | nearest_station_route | nearest_station_distance_km
-- -----------+-------------+-------+--------------------+-----------------------+----------------------------
-- ID-1000    | LOS ANGELES | 5     | ID-1000            | 5                     | 10                         
-- ID-1001    | SAN DIEGO   | 80    | ID-1001            | 80                    | 25                         
-- ID-1002    | SACRAMENTO  | 101   | ID-1002            | 101                   | 42                         
-- ...

