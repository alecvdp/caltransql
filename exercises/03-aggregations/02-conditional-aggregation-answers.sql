-- Answer Key for Exercise 3.2: Conditional Aggregation

-- Q1
SELECT
    county,
    COUNT(*) AS total_bridges,
    COUNT(CASE WHEN year_built < 1950 THEN 1 END) AS built_before_1950,
    COUNT(CASE WHEN year_built >= 2000 THEN 1 END) AS built_2000_or_later
FROM bridges
GROUP BY county
ORDER BY total_bridges DESC;

-- Q2
SELECT
    county,
    COUNT(*) AS bridge_count,
    COUNT(CASE WHEN deck_condition >= 7 THEN 1 END) AS good_condition,
    COUNT(CASE WHEN deck_condition IN (5, 6) THEN 1 END) AS fair_condition,
    COUNT(CASE WHEN deck_condition <= 4 THEN 1 END) AS poor_condition
FROM bridges
GROUP BY county
ORDER BY bridge_count DESC
LIMIT 20;

-- Q3
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

-- Q4
SELECT
    county,
    COUNT(CASE WHEN adt >= 50000 THEN 1 END) AS high_adt_bridges,
    COUNT(CASE WHEN truck_adt_pct >= 10 THEN 1 END) AS high_truck_pct_bridges,
    COUNT(CASE WHEN total_length_m >= 500 THEN 1 END) AS long_bridges
FROM bridges
GROUP BY county
ORDER BY high_adt_bridges DESC;

-- Q5
SELECT
    county,
    AVG(total_length_m) AS avg_length_all_bridges,
    AVG(CASE WHEN deck_condition <= 5 THEN total_length_m END) AS avg_length_poor_condition
FROM bridges
GROUP BY county
ORDER BY avg_length_poor_condition DESC NULLS LAST;

-- Q6
SELECT
    owner,
    AVG(CASE WHEN year_reconstructed IS NOT NULL THEN sufficiency_rating END) AS avg_rating_reconstructed,
    AVG(CASE WHEN year_reconstructed IS NULL THEN sufficiency_rating END) AS avg_rating_not_reconstructed
FROM bridges
GROUP BY owner
ORDER BY owner;

-- Q7
SELECT
    county,
    COUNT(*) AS total_bridges,
    ROUND(
        100.0 * COUNT(CASE WHEN deck_condition <= 4 THEN 1 END) / COUNT(*),
        1
    ) AS poor_condition_pct,
    ROUND(
        100.0 * COUNT(CASE WHEN year_reconstructed IS NOT NULL THEN 1 END) / COUNT(*),
        1
    ) AS reconstructed_pct,
    AVG(CASE WHEN adt IS NOT NULL THEN adt END) AS avg_adt
FROM bridges
GROUP BY county
HAVING COUNT(*) >= 100
ORDER BY poor_condition_pct DESC;
