-- Hints for Exercise 9.1: Spatial Analysis with PostGIS

-- Q1 hint:
-- Build params once, then CROSS JOIN it to your bridge points.
-- Convert radius_km to meters by multiplying by 1000.

-- Q2 hint:
-- ST_ClusterDBSCAN runs as a window function.
-- Use ST_Transform(..., 3310) so eps=5000 means 5 km.

-- Q3 hint:
-- Use CROSS JOIN LATERAL to find one nearest neighbor per bridge
-- after filtering candidates to the same facility_carried.

-- Q4 hint:
-- Build bridge_points and crash_points CTEs first, then ST_DWithin
-- at 1000 meters. Aggregate by bridge structure_number.

-- Q5 hint:
-- Similar to Q3, but project_points -> station_points using a
-- lateral subquery ordered by ST_Distance(...).
