-- Answer Key for Exercise 1.2: ORDER BY, LIMIT, and NULL Handling

-- Q1
SELECT structure_number, county, facility_carried, year_built
FROM bridges
ORDER BY year_built ASC
LIMIT 15;
-- Expected output (first 5 rows, illustrative):
-- structure_number | county      | facility_carried | year_built
-- -----------------+-------------+------------------+-----------
-- ID-1000          | LOS ANGELES | Sample A         | 1950      
-- ID-1001          | SAN DIEGO   | Sample B         | 1965      
-- ID-1002          | SACRAMENTO  | Sample C         | 1980      
-- ...


-- Q2
SELECT structure_number, facility_carried, county, adt, adt_year
FROM bridges
ORDER BY adt DESC NULLS LAST
LIMIT 20;
-- Expected output (first 5 rows, illustrative):
-- structure_number | facility_carried | county      | adt | adt_year
-- -----------------+------------------+-------------+-----+---------
-- ID-1000          | Sample A         | LOS ANGELES | 10  | 1950    
-- ID-1001          | Sample B         | SAN DIEGO   | 25  | 1965    
-- ID-1002          | Sample C         | SACRAMENTO  | 42  | 1980    
-- ...


-- Q3
SELECT structure_number, facility_carried, county, deck_width_m
FROM bridges
ORDER BY deck_width_m ASC NULLS LAST
LIMIT 10;
-- Expected output (first 5 rows, illustrative):
-- structure_number | facility_carried | county      | deck_width_m
-- -----------------+------------------+-------------+-------------
-- ID-1000          | Sample A         | LOS ANGELES | 10          
-- ID-1001          | Sample B         | SAN DIEGO   | 25          
-- ID-1002          | Sample C         | SACRAMENTO  | 42          
-- ...


-- Q4
SELECT structure_number, facility_carried, deck_condition, year_built
FROM bridges
WHERE county = 'LOS ANGELES'
ORDER BY deck_condition ASC NULLS LAST, year_built ASC
LIMIT 25;
-- Expected output (first 5 rows, illustrative):
-- structure_number | facility_carried | deck_condition | year_built
-- -----------------+------------------+----------------+-----------
-- ID-1000          | Sample A         | 10             | 1950      
-- ID-1001          | Sample B         | 25             | 1965      
-- ID-1002          | Sample C         | 42             | 1980      
-- ...


-- Q5
SELECT structure_number, facility_carried, county, year_built, year_reconstructed
FROM bridges
WHERE year_reconstructed IS NOT NULL
ORDER BY year_reconstructed DESC
LIMIT 15;
-- Expected output (first 5 rows, illustrative):
-- structure_number | facility_carried | county      | year_built | year_reconstructed
-- -----------------+------------------+-------------+------------+-------------------
-- ID-1000          | Sample A         | LOS ANGELES | 1950       | 1950              
-- ID-1001          | Sample B         | SAN DIEGO   | 1965       | 1965              
-- ID-1002          | Sample C         | SACRAMENTO  | 1980       | 1980              
-- ...


-- Q6
SELECT structure_number, county, facility_carried, year_built
FROM bridges
ORDER BY county ASC, year_built ASC
LIMIT 30;
-- Expected output (first 5 rows, illustrative):
-- structure_number | county      | facility_carried | year_built
-- -----------------+-------------+------------------+-----------
-- ID-1000          | LOS ANGELES | Sample A         | 1950      
-- ID-1001          | SAN DIEGO   | Sample B         | 1965      
-- ID-1002          | SACRAMENTO  | Sample C         | 1980      
-- ...


-- Q7
SELECT structure_number, county, facility_carried, deck_condition, total_length_m
FROM bridges
ORDER BY deck_condition ASC NULLS LAST, total_length_m DESC NULLS LAST
LIMIT 20;
-- Expected output (first 5 rows, illustrative):
-- structure_number | county      | facility_carried | deck_condition | total_length_m
-- -----------------+-------------+------------------+----------------+---------------
-- ID-1000          | LOS ANGELES | Sample A         | 10             | 10            
-- ID-1001          | SAN DIEGO   | Sample B         | 25             | 25            
-- ID-1002          | SACRAMENTO  | Sample C         | 42             | 42            
-- ...


-- Q8
SELECT structure_number, county, facility_carried, year_built, adt
FROM bridges
WHERE year_built < 1960
  AND adt > 50000
ORDER BY year_built ASC, adt DESC;
-- Expected output (first 5 rows, illustrative):
-- structure_number | county      | facility_carried | year_built | adt
-- -----------------+-------------+------------------+------------+----
-- ID-1000          | LOS ANGELES | Sample A         | 1950       | 10 
-- ID-1001          | SAN DIEGO   | Sample B         | 1965       | 25 
-- ID-1002          | SACRAMENTO  | Sample C         | 1980       | 42 
-- ...

