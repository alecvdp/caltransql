-- Answer Key for Exercise 3.1: Aggregate Functions and GROUP BY

-- Q1
SELECT COUNT(*) AS total_bridges
FROM bridges;
-- Expected output (first 5 rows, illustrative):
-- total_bridges
-- -------------
-- 10           
-- 25           
-- 42           
-- ...


-- Q2
SELECT
    MIN(year_built) AS oldest_bridge_year,
    MAX(year_built) AS newest_bridge_year
FROM bridges;
-- Expected output (first 5 rows, illustrative):
-- oldest_bridge_year | newest_bridge_year
-- -------------------+-------------------
-- 1950               | 1950              
-- 1965               | 1965              
-- 1980               | 1980              
-- ...


-- Q3
SELECT AVG(year_built) AS avg_year_built
FROM bridges;
-- Expected output (first 5 rows, illustrative):
-- avg_year_built
-- --------------
-- 1950          
-- 1965          
-- 1980          
-- ...


-- Q4
SELECT owner, COUNT(*) AS bridge_count
FROM bridges
GROUP BY owner
ORDER BY bridge_count DESC;
-- Expected output (first 5 rows, illustrative):
-- owner                            | bridge_count
-- ---------------------------------+-------------
-- State Highway Agency             | 10          
-- County Highway Agency            | 25          
-- City or Municipal Highway Agency | 42          
-- ...


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
-- Expected output (first 5 rows, illustrative):
-- county      | bridge_count | oldest_bridge_year | newest_bridge_year | avg_year_built
-- ------------+--------------+--------------------+--------------------+---------------
-- LOS ANGELES | 10           | 1950               | 1950               | 1950          
-- SAN DIEGO   | 25           | 1965               | 1965               | 1965          
-- SACRAMENTO  | 42           | 1980               | 1980               | 1980          
-- ...


-- Q6
SELECT county, AVG(total_length_m) AS avg_total_length_m
FROM bridges
GROUP BY county
ORDER BY avg_total_length_m DESC NULLS LAST;
-- Expected output (first 5 rows, illustrative):
-- county      | avg_total_length_m
-- ------------+-------------------
-- LOS ANGELES | 10                
-- SAN DIEGO   | 25                
-- SACRAMENTO  | 42                
-- ...


-- Q7
SELECT owner, COUNT(*) AS bridge_count
FROM bridges
GROUP BY owner
HAVING COUNT(*) > 1000
ORDER BY bridge_count DESC;
-- Expected output (first 5 rows, illustrative):
-- owner                            | bridge_count
-- ---------------------------------+-------------
-- State Highway Agency             | 10          
-- County Highway Agency            | 25          
-- City or Municipal Highway Agency | 42          
-- ...


-- Q8
SELECT county, AVG(year_built) AS avg_year_built
FROM bridges
GROUP BY county
HAVING AVG(year_built) < 1960
ORDER BY avg_year_built;
-- Expected output (first 5 rows, illustrative):
-- county      | avg_year_built
-- ------------+---------------
-- LOS ANGELES | 1950          
-- SAN DIEGO   | 1965          
-- SACRAMENTO  | 1980          
-- ...


-- Q9
SELECT county, AVG(deck_condition) AS avg_deck_condition
FROM bridges
GROUP BY county
HAVING AVG(deck_condition) < 6
ORDER BY avg_deck_condition;
-- Expected output (first 5 rows, illustrative):
-- county      | avg_deck_condition
-- ------------+-------------------
-- LOS ANGELES | 10                
-- SAN DIEGO   | 25                
-- SACRAMENTO  | 42                
-- ...

