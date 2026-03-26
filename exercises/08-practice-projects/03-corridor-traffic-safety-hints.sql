-- Hints for Practice Project: Corridor Traffic and Safety Analysis

-- Part 1 hint:
-- traffic_counts and truck_traffic share a clean composite key:
-- (station_id, count_year).

-- Part 2 hint:
-- Build the station-level join first, then roll up to route + county.

-- Part 3 hint:
-- Start crash analysis at county + primary_road grain.

-- Part 4 hint:
-- County is the safest common grain for combining traffic and crashes here.

-- Deliverable hint:
-- It is okay if the final output is county-level instead of exact route-level crash matching.
