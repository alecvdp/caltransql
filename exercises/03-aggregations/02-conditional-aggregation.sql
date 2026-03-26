-- ============================================================
-- Exercise 3.2: Conditional Aggregation
-- ============================================================
-- These exercises use the 'bridges' table.
-- Learn how to count subsets of rows with CASE inside aggregates.
-- ============================================================


-- ----- EXAMPLES -----

-- Count bridges in each county and how many are poor condition
SELECT
    county,
    COUNT(*) AS total_bridges,
    COUNT(CASE WHEN deck_condition <= 5 THEN 1 END) AS poor_condition_bridges
FROM bridges
GROUP BY county
ORDER BY poor_condition_bridges DESC;

-- Calculate percentages with conditional aggregation
SELECT
    owner,
    COUNT(*) AS total_bridges,
    ROUND(
        100.0 * COUNT(CASE WHEN year_reconstructed IS NOT NULL THEN 1 END) / COUNT(*),
        1
    ) AS pct_reconstructed
FROM bridges
GROUP BY owner
ORDER BY pct_reconstructed DESC;


-- ----- YOUR TURN -----

-- Q1: For each county, count:
--     - total bridges
--     - bridges built before 1950
--     - bridges built in 2000 or later
--     Order by total bridges descending.


-- Q2: For each county, count how many bridges fall into:
--     - good condition (deck_condition >= 7)
--     - fair condition (deck_condition 5-6)
--     - poor condition (deck_condition <= 4)
--     Limit to the top 20 counties by bridge count.


-- Q3: For each owner, calculate the percentage of bridges with
--     non-null year_reconstructed.
--     Order from highest percentage to lowest.


-- Q4: For each county, count how many bridges have:
--     - ADT >= 50000
--     - truck_adt_pct >= 10
--     - total_length_m >= 500
--     Order by the high-ADT count descending.


-- ============================================================
-- Conditional sums and averages
-- ============================================================

-- Q5: For each county, calculate the average total_length_m for:
--     - all bridges
--     - only bridges with deck_condition <= 5
--     Compare the two values.


-- Q6: For each owner, calculate the average sufficiency_rating for:
--     - reconstructed bridges
--     - non-reconstructed bridges


-- ============================================================
-- Challenge
-- ============================================================

-- Q7: Build a county summary table with:
--     - total bridges
--     - poor_condition_pct
--     - reconstructed_pct
--     - avg_adt for bridges with non-null ADT
--     Filter to counties with at least 100 bridges.
--     Order by poor_condition_pct descending.
