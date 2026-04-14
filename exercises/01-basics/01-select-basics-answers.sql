-- Answer Key for Exercise 1.1: SELECT Basics

-- Q1
SELECT structure_number, owner, year_built
FROM bridges
LIMIT 20;
-- Expected output (first 5 rows, illustrative):
-- structure_number | owner                            | year_built
-- -----------------+----------------------------------+-----------
-- ID-1000          | State Highway Agency             | 1950      
-- ID-1001          | County Highway Agency            | 1965      
-- ID-1002          | City or Municipal Highway Agency | 1980      
-- ...


-- Q2
SELECT *
FROM bridges
LIMIT 5;
-- Expected output (first 5 rows, illustrative):
-- *             
-- --------------
-- <many columns>
-- <many columns>
-- <many columns>
-- ...


-- Q3
SELECT facility_carried, features_intersected
FROM bridges
LIMIT 15;
-- Expected output (first 5 rows, illustrative):
-- facility_carried | features_intersected
-- -----------------+---------------------
-- Sample A         | Sample A            
-- Sample B         | Sample B            
-- Sample C         | Sample C            
-- ...


-- Q4
SELECT DISTINCT owner
FROM bridges
ORDER BY owner;
-- Expected output (first 5 rows, illustrative):
-- owner                           
-- --------------------------------
-- State Highway Agency            
-- County Highway Agency           
-- City or Municipal Highway Agency
-- ...


-- Q5
SELECT DISTINCT deck_condition
FROM bridges
ORDER BY deck_condition;
-- Expected output (first 5 rows, illustrative):
-- deck_condition
-- --------------
-- 10            
-- 25            
-- 42            
-- ...


-- Q6
SELECT
    county AS county_name,
    facility_carried AS bridge_name,
    total_length_m AS length_meters
FROM bridges
LIMIT 10;
-- Expected output (first 5 rows, illustrative):
-- county_name | bridge_name | length_meters
-- ------------+-------------+--------------
-- LOS ANGELES | Sample A    | 10           
-- SAN DIEGO   | Sample B    | 25           
-- SACRAMENTO  | Sample C    | 42           
-- ...

