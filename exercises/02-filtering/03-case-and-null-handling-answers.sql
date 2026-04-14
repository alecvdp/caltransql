-- Answer Key for Exercise 2.3: CASE, COALESCE, and NULL Handling

-- Q1
SELECT
    structure_number,
    county,
    year_built,
    CASE
        WHEN year_built < 1940 THEN 'Historic'
        WHEN year_built BETWEEN 1940 AND 1979 THEN 'Mid-century'
        WHEN year_built >= 1980 THEN 'Modern'
        ELSE 'Unknown'
    END AS age_bucket
FROM bridges
LIMIT 20;
-- Expected output (first 5 rows, illustrative):
-- structure_number | county      | year_built | age_bucket
-- -----------------+-------------+------------+-----------
-- ID-1000          | LOS ANGELES | 1950       | Sample A  
-- ID-1001          | SAN DIEGO   | 1965       | Sample B  
-- ID-1002          | SACRAMENTO  | 1980       | Sample C  
-- ...


-- Q2
SELECT
    structure_number,
    county,
    adt,
    CASE
        WHEN adt IS NULL THEN 'Unknown'
        WHEN adt >= 100000 THEN 'Very High'
        WHEN adt >= 50000 THEN 'High'
        WHEN adt >= 10000 THEN 'Moderate'
        ELSE 'Low'
    END AS traffic_bucket
FROM bridges
LIMIT 25;
-- Expected output (first 5 rows, illustrative):
-- structure_number | county      | adt | traffic_bucket
-- -----------------+-------------+-----+---------------
-- ID-1000          | LOS ANGELES | 10  | Sample A      
-- ID-1001          | SAN DIEGO   | 25  | Sample B      
-- ID-1002          | SACRAMENTO  | 42  | Sample C      
-- ...


-- Q3
SELECT
    structure_number,
    county,
    year_built,
    year_reconstructed,
    COALESCE(year_reconstructed, year_built) AS effective_service_year
FROM bridges
ORDER BY effective_service_year DESC NULLS LAST
LIMIT 20;
-- Expected output (first 5 rows, illustrative):
-- structure_number | county      | year_built | year_reconstructed | effective_service_year
-- -----------------+-------------+------------+--------------------+-----------------------
-- ID-1000          | LOS ANGELES | 1950       | 1950               | 1950                  
-- ID-1001          | SAN DIEGO   | 1965       | 1965               | 1965                  
-- ID-1002          | SACRAMENTO  | 1980       | 1980               | 1980                  
-- ...


-- Q4
SELECT
    structure_number,
    county,
    deck_condition,
    CASE
        WHEN deck_condition IS NULL THEN 'Unknown'
        WHEN deck_condition <= 4 THEN 'Urgent'
        WHEN deck_condition IN (5, 6) THEN 'Monitor'
        ELSE 'Stable'
    END AS maintenance_priority
FROM bridges
LIMIT 25;
-- Expected output (first 5 rows, illustrative):
-- structure_number | county      | deck_condition | maintenance_priority
-- -----------------+-------------+----------------+---------------------
-- ID-1000          | LOS ANGELES | 10             | Sample A            
-- ID-1001          | SAN DIEGO   | 25             | Sample B            
-- ID-1002          | SACRAMENTO  | 42             | Sample C            
-- ...


-- Q5
SELECT structure_number, county, facility_carried, deck_condition
FROM bridges
WHERE deck_condition <= 4;
-- Expected output (first 5 rows, illustrative):
-- structure_number | county      | facility_carried | deck_condition
-- -----------------+-------------+------------------+---------------
-- ID-1000          | LOS ANGELES | Sample A         | 10            
-- ID-1001          | SAN DIEGO   | Sample B         | 25            
-- ID-1002          | SACRAMENTO  | Sample C         | 42            
-- ...


-- Q6
SELECT
    structure_number,
    county,
    deck_condition,
    CASE
        WHEN deck_condition IS NULL THEN 'Unknown'
        WHEN deck_condition <= 4 THEN 'Urgent'
        WHEN deck_condition IN (5, 6) THEN 'Monitor'
        ELSE 'Stable'
    END AS maintenance_priority
FROM bridges
ORDER BY CASE
    WHEN deck_condition <= 4 THEN 1
    WHEN deck_condition IN (5, 6) THEN 2
    WHEN deck_condition >= 7 THEN 3
    ELSE 4
END
LIMIT 30;
-- Expected output (first 5 rows, illustrative):
-- structure_number | county      | deck_condition | maintenance_priority
-- -----------------+-------------+----------------+---------------------
-- ID-1000          | LOS ANGELES | 10             | Sample A            
-- ID-1001          | SAN DIEGO   | 25             | Sample B            
-- ID-1002          | SACRAMENTO  | 42             | Sample C            
-- ...


-- Q7
SELECT
    structure_number,
    county,
    year_built,
    data_year,
    data_year - year_built AS bridge_age,
    COALESCE(year_reconstructed, year_built) AS effective_year,
    CASE
        WHEN deck_condition >= 8 THEN 'Good'
        WHEN deck_condition >= 6 THEN 'Fair'
        WHEN deck_condition IS NULL THEN 'Unrated'
        ELSE 'Poor'
    END AS condition_bucket,
    CASE
        WHEN adt IS NULL THEN 'Unknown'
        WHEN adt >= 100000 THEN 'Very High'
        WHEN adt >= 50000 THEN 'High'
        WHEN adt >= 10000 THEN 'Moderate'
        ELSE 'Low'
    END AS traffic_bucket
FROM bridges
LIMIT 20;
-- Expected output (first 5 rows, illustrative):
-- structure_number | county      | year_built | data_year | bridge_age | effective_year | condition_bucket | ...     
-- -----------------+-------------+------------+-----------+------------+----------------+------------------+---------
-- ID-1000          | LOS ANGELES | 1950       | 1950      | Sample A   | 1950           | 10               | Sample A
-- ID-1001          | SAN DIEGO   | 1965       | 1965      | Sample B   | 1965           | 25               | Sample B
-- ID-1002          | SACRAMENTO  | 1980       | 1980      | Sample C   | 1980           | 42               | Sample C
-- ...

