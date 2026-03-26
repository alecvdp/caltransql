-- ============================================================
-- Practice Project: Corridor Traffic and Safety Analysis
-- ============================================================
-- Goal:
-- Identify high-volume, high-truck, and high-risk corridors using
-- traffic_counts, truck_traffic, and crashes.
--
-- This project is more advanced because the tables operate at
-- different grains. Be deliberate about your joins.
-- ============================================================


-- ============================================================
-- PART 1: Understand the Grain
-- ============================================================

-- 1A: Inspect the primary keys and likely join columns for:
--     - traffic_counts
--     - truck_traffic
--     - crashes
--
--     Write down:
--     - What makes one row unique in each table?
--     - Which joins are exact?
--     - Which joins are only approximate?


-- 1B: Join traffic_counts to truck_traffic on:
--     station_id and count_year
--     Return one row per station-year with route, county,
--     aadt_total, truck_aadt_total, truck_pct_total, and eal.


-- 1C: Count how many traffic stations have a matching truck_traffic row.
--     Also count how many do not.


-- ============================================================
-- PART 2: Corridor Traffic Profile
-- ============================================================

-- 2A: For each route and county, calculate:
--     - number of stations
--     - average aadt_total
--     - average truck_pct_total
--     - total eal


-- 2B: Rank route-county corridors by:
--     - highest average AADT
--     - highest average truck percentage
--     - highest total EAL


-- 2C: Create a corridor category:
--     - 'Freight-heavy' if truck_pct_total >= 15
--     - 'Commuter-heavy' if aadt_total >= 100000 and truck_pct_total < 15
--     - 'Mixed' otherwise


-- ============================================================
-- PART 3: Crash Patterns
-- ============================================================

-- 3A: Build a crash summary by county and primary_road:
--     - crash_count
--     - fatal_crash_count
--     - total_killed
--     - total_injured


-- 3B: Find the top 20 county-road combinations by fatal_crash_count.


-- 3C: Break down severe crashes by weather, lighting, and road_condition.


-- ============================================================
-- PART 4: Combine Traffic and Safety
-- ============================================================

-- 4A: Create a county-level traffic summary from traffic_counts
--     and truck_traffic.


-- 4B: Create a county-level crash summary from crashes.


-- 4C: Join the county-level summaries to identify counties with:
--     - high traffic volume
--     - high truck percentage
--     - high fatal/severe crash totals


-- ============================================================
-- PART 5: Final Deliverables
-- ============================================================

-- Deliverable 1:
-- A top-15 corridor table with:
-- route, county, avg_aadt_total, avg_truck_pct_total, total_eal.

-- Deliverable 2:
-- A county safety-risk table with:
-- county, avg_aadt_total, avg_truck_pct_total,
-- crash_count, fatal_crash_count, total_killed.

-- Deliverable 3:
-- A short written summary answering:
-- - Which corridors appear most freight-intensive?
-- - Which counties combine heavy traffic with severe crash outcomes?
-- - What extra data would help make this analysis more precise?


-- ============================================================
-- Stretch Goals
-- ============================================================

-- Stretch 1: Use NTILE(5) to split counties into quintiles
-- by traffic exposure or fatal crash totals.

-- Stretch 2: Compare multiple count_year values to see if
-- truck share is rising or falling on major routes.

-- Stretch 3: Build a view for your county risk table.
