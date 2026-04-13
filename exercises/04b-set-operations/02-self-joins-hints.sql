-- Hints for Exercise 4b.2: Self-Joins

-- Q1 hint:
-- FROM bridges a JOIN bridges b ON a.county = b.county
-- Add WHERE a.deck_condition <= 4 AND b.deck_condition <= 4
-- and the anti-duplication guard: AND a.structure_number < b.structure_number

-- Q2 hint:
-- Join on a.county = b.county AND a.facility_carried = b.facility_carried
-- Use a directional comparison to keep only pairs where b is newer:
--   b.year_built - a.year_built >= 30
-- This naturally avoids duplicate pairs (b is always the newer bridge),
-- so the a.structure_number < b.structure_number guard is not needed.
-- Computed column: b.year_built - a.year_built AS year_diff

-- Q3 hint:
-- Join on county and features_intersected, then filter:
-- ABS(a.deck_condition - b.deck_condition) >= 3
-- Make sure features_intersected IS NOT NULL in the join condition or WHERE clause.

-- Q4 hint:
-- Join on county and facility_carried. Add:
--   b.year_built - a.year_built >= 20   (b is newer)
--   a.deck_condition <= 5               (older bridge is in poorer shape)
-- Use a.structure_number < b.structure_number OR rely on the year direction
-- to avoid duplicates.

-- Q5 hint:
-- Start with all pairs: a.structure_number < b.structure_number, same county.
-- Compute ABS(a.deck_condition - b.deck_condition) AS condition_gap.
-- Wrap in a CTE, then use ROW_NUMBER() OVER (PARTITION BY county ORDER BY condition_gap DESC)
-- to pick the top pair per county.

-- Q6 hint:
-- This one does NOT actually require a self-join — a simple GROUP BY works:
--   SELECT facility_carried, county, COUNT(*) AS bridge_count,
--          MIN(deck_condition), MAX(deck_condition),
--          MAX(deck_condition) - MIN(deck_condition) AS condition_gap
--   FROM bridges
--   WHERE facility_carried IS NOT NULL
--   GROUP BY facility_carried, county
--   HAVING COUNT(*) > 1
-- The challenge question is designed to make you think about when a
-- self-join is necessary versus when aggregation alone suffices.
