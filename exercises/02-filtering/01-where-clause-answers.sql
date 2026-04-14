-- Answer Key for Exercise 2.1: WHERE Clause

-- Q1
SELECT *
FROM bridges
WHERE county = 'SACRAMENTO';
-- Expected output (first 5 rows, illustrative):
-- *             
-- --------------
-- <many columns>
-- <many columns>
-- <many columns>
-- ...


-- Q2
SELECT structure_number, facility_carried, county, year_built
FROM bridges
WHERE year_built < 1950;
-- Expected output (first 5 rows, illustrative):
-- structure_number | facility_carried | county      | year_built
-- -----------------+------------------+-------------+-----------
-- ID-1000          | Sample A         | LOS ANGELES | 1950      
-- ID-1001          | Sample B         | SAN DIEGO   | 1965      
-- ID-1002          | Sample C         | SACRAMENTO  | 1980      
-- ...


-- Q3
SELECT structure_number, facility_carried, owner
FROM bridges
WHERE owner = 'State Highway Agency';
-- Expected output (first 5 rows, illustrative):
-- structure_number | facility_carried | owner                           
-- -----------------+------------------+---------------------------------
-- ID-1000          | Sample A         | State Highway Agency            
-- ID-1001          | Sample B         | County Highway Agency           
-- ID-1002          | Sample C         | City or Municipal Highway Agency
-- ...


-- Q4
SELECT structure_number, facility_carried, deck_condition
FROM bridges
WHERE deck_condition = 9;
-- Expected output (first 5 rows, illustrative):
-- structure_number | facility_carried | deck_condition
-- -----------------+------------------+---------------
-- ID-1000          | Sample A         | 10            
-- ID-1001          | Sample B         | 25            
-- ID-1002          | Sample C         | 42            
-- ...


-- Q5
SELECT structure_number, facility_carried, county, total_length_m
FROM bridges
WHERE total_length_m > 1000
ORDER BY total_length_m DESC;
-- Expected output (first 5 rows, illustrative):
-- structure_number | facility_carried | county      | total_length_m
-- -----------------+------------------+-------------+---------------
-- ID-1000          | Sample A         | LOS ANGELES | 10            
-- ID-1001          | Sample B         | SAN DIEGO   | 25            
-- ID-1002          | Sample C         | SACRAMENTO  | 42            
-- ...


-- Q6
SELECT structure_number, facility_carried, year_built
FROM bridges
WHERE year_built <> 2010;
-- Expected output (first 5 rows, illustrative):
-- structure_number | facility_carried | year_built
-- -----------------+------------------+-----------
-- ID-1000          | Sample A         | 1950      
-- ID-1001          | Sample B         | 1965      
-- ID-1002          | Sample C         | 1980      
-- ...


-- Q7
SELECT structure_number, facility_carried, year_built
FROM bridges
WHERE year_built >= 1990
  AND year_built <= 2000;
-- Expected output (first 5 rows, illustrative):
-- structure_number | facility_carried | year_built
-- -----------------+------------------+-----------
-- ID-1000          | Sample A         | 1950      
-- ID-1001          | Sample B         | 1965      
-- ID-1002          | Sample C         | 1980      
-- ...


-- Q8
SELECT structure_number, facility_carried, county, year_built
FROM bridges
WHERE county = 'SAN FRANCISCO'
  AND year_built > 2000;
-- Expected output (first 5 rows, illustrative):
-- structure_number | facility_carried | county      | year_built
-- -----------------+------------------+-------------+-----------
-- ID-1000          | Sample A         | LOS ANGELES | 1950      
-- ID-1001          | Sample B         | SAN DIEGO   | 1965      
-- ID-1002          | Sample C         | SACRAMENTO  | 1980      
-- ...


-- Q9
SELECT structure_number, facility_carried, owner
FROM bridges
WHERE owner = 'City or Municipal Highway Agency'
   OR owner = 'County Highway Agency';
-- Expected output (first 5 rows, illustrative):
-- structure_number | facility_carried | owner                           
-- -----------------+------------------+---------------------------------
-- ID-1000          | Sample A         | State Highway Agency            
-- ID-1001          | Sample B         | County Highway Agency           
-- ID-1002          | Sample C         | City or Municipal Highway Agency
-- ...


-- Q10
SELECT structure_number, facility_carried, county, deck_condition
FROM bridges
WHERE county = 'LOS ANGELES'
  AND deck_condition >= 7;
-- Expected output (first 5 rows, illustrative):
-- structure_number | facility_carried | county      | deck_condition
-- -----------------+------------------+-------------+---------------
-- ID-1000          | Sample A         | LOS ANGELES | 10            
-- ID-1001          | Sample B         | SAN DIEGO   | 25            
-- ID-1002          | Sample C         | SACRAMENTO  | 42            
-- ...

