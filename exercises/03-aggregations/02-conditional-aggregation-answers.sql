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
-- Expected output (first 5 rows, illustrative):
-- county      | total_bridges | built_before_1950 | built_2000_or_later
-- ------------+---------------+-------------------+--------------------
-- LOS ANGELES | 10            | Sample A          | Sample A           
-- SAN DIEGO   | 25            | Sample B          | Sample B           
-- SACRAMENTO  | 42            | Sample C          | Sample C           
-- ...


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
-- Expected output (first 5 rows, illustrative):
-- county      | bridge_count | good_condition | fair_condition | poor_condition
-- ------------+--------------+----------------+----------------+---------------
-- LOS ANGELES | 10           | 10             | 10             | 10            
-- SAN DIEGO   | 25           | 25             | 25             | 25            
-- SACRAMENTO  | 42           | 42             | 42             | 42            
-- ...


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
-- Expected output (first 5 rows, illustrative):
-- owner                            | total_bridges | pct_reconstructed
-- ---------------------------------+---------------+------------------
-- State Highway Agency             | 10            | 10               
-- County Highway Agency            | 25            | 25               
-- City or Municipal Highway Agency | 42            | 42               
-- ...


-- Q4
SELECT
    county,
    COUNT(CASE WHEN adt >= 50000 THEN 1 END) AS high_adt_bridges,
    COUNT(CASE WHEN truck_adt_pct >= 10 THEN 1 END) AS high_truck_pct_bridges,
    COUNT(CASE WHEN total_length_m >= 500 THEN 1 END) AS long_bridges
FROM bridges
GROUP BY county
ORDER BY high_adt_bridges DESC;
-- Expected output (first 5 rows, illustrative):
-- county      | high_adt_bridges | high_truck_pct_bridges | long_bridges
-- ------------+------------------+------------------------+-------------
-- LOS ANGELES | 10               | 10                     | Sample A    
-- SAN DIEGO   | 25               | 25                     | Sample B    
-- SACRAMENTO  | 42               | 42                     | Sample C    
-- ...


-- Q5
SELECT
    county,
    AVG(total_length_m) AS avg_length_all_bridges,
    AVG(CASE WHEN deck_condition <= 5 THEN total_length_m END) AS avg_length_poor_condition
FROM bridges
GROUP BY county
ORDER BY avg_length_poor_condition DESC NULLS LAST;
-- Expected output (first 5 rows, illustrative):
-- county      | avg_length_all_bridges | avg_length_poor_condition
-- ------------+------------------------+--------------------------
-- LOS ANGELES | 10                     | 10                       
-- SAN DIEGO   | 25                     | 25                       
-- SACRAMENTO  | 42                     | 42                       
-- ...


-- Q6
SELECT
    owner,
    AVG(CASE WHEN year_reconstructed IS NOT NULL THEN sufficiency_rating END) AS avg_rating_reconstructed,
    AVG(CASE WHEN year_reconstructed IS NULL THEN sufficiency_rating END) AS avg_rating_not_reconstructed
FROM bridges
GROUP BY owner
ORDER BY owner;
-- Expected output (first 5 rows, illustrative):
-- owner                            | avg_rating_reconstructed | avg_rating_not_reconstructed
-- ---------------------------------+--------------------------+-----------------------------
-- State Highway Agency             | 10                       | 10                          
-- County Highway Agency            | 25                       | 25                          
-- City or Municipal Highway Agency | 42                       | 42                          
-- ...


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
-- Expected output (first 5 rows, illustrative):
-- county      | total_bridges | poor_condition_pct | reconstructed_pct | avg_adt
-- ------------+---------------+--------------------+-------------------+--------
-- LOS ANGELES | 10            | 10                 | 10                | 10     
-- SAN DIEGO   | 25            | 25                 | 25                | 25     
-- SACRAMENTO  | 42            | 42                 | 42                | 42     
-- ...

