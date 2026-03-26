-- Hints for Practice Project: California Bridge Report Card

-- Part 1 hint:
-- Start with a few clean summary queries:
-- total bridges, owner breakdown, and decade counts.

-- Part 2 hint:
-- Distribution questions usually mean GROUP BY plus COUNT and percentage.

-- Part 3 hint:
-- Use ORDER BY year_built ASC for the oldest bridges and
-- ORDER BY total_length_m DESC for the longest.

-- Part 3C hint:
-- Use ROW_NUMBER() partitioned by county, or a correlated subquery on MIN(year_built).

-- Part 4 hint:
-- Aggregate projects by county first, then compare with bridge counts.

-- Part 5 hint:
-- Good custom questions often compare age, condition, traffic, and ownership.
