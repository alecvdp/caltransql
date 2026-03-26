-- Answer Key for Exercise 3.1: Aggregate Functions and GROUP BY

-- Q1
SELECT COUNT(*) AS total_bridges
FROM bridges;

-- Q2
SELECT
    MIN(year_built) AS oldest_bridge_year,
    MAX(year_built) AS newest_bridge_year
FROM bridges;

-- Q3
SELECT AVG(year_built) AS avg_year_built
FROM bridges;

-- Q4
SELECT owner, COUNT(*) AS bridge_count
FROM bridges
GROUP BY owner
ORDER BY bridge_count DESC;

-- Q5
SELECT
    county,
    COUNT(*) AS bridge_count,
    MIN(year_built) AS oldest_bridge_year,
    MAX(year_built) AS newest_bridge_year,
    AVG(year_built) AS avg_year_built
FROM bridges
GROUP BY county
ORDER BY bridge_count DESC;

-- Q6
SELECT county, AVG(total_length_m) AS avg_total_length_m
FROM bridges
GROUP BY county
ORDER BY avg_total_length_m DESC NULLS LAST;

-- Q7
SELECT owner, COUNT(*) AS bridge_count
FROM bridges
GROUP BY owner
HAVING COUNT(*) > 1000
ORDER BY bridge_count DESC;

-- Q8
SELECT county, AVG(year_built) AS avg_year_built
FROM bridges
GROUP BY county
HAVING AVG(year_built) < 1960
ORDER BY avg_year_built;

-- Q9
SELECT county, AVG(deck_condition) AS avg_deck_condition
FROM bridges
GROUP BY county
HAVING AVG(deck_condition) < 6
ORDER BY avg_deck_condition;
