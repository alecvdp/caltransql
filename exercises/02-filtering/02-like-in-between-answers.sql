-- Answer Key for Exercise 2.2: LIKE, IN, BETWEEN

-- Q1
SELECT structure_number, facility_carried, county
FROM bridges
WHERE facility_carried LIKE 'STATE%';
-- Expected output (first 5 rows, illustrative):
-- structure_number | facility_carried | county     
-- -----------------+------------------+------------
-- ID-1000          | Sample A         | LOS ANGELES
-- ID-1001          | Sample B         | SAN DIEGO  
-- ID-1002          | Sample C         | SACRAMENTO 
-- ...


-- Q2
SELECT structure_number, facility_carried, county
FROM bridges
WHERE facility_carried LIKE '%CREEK%';
-- Expected output (first 5 rows, illustrative):
-- structure_number | facility_carried | county     
-- -----------------+------------------+------------
-- ID-1000          | Sample A         | LOS ANGELES
-- ID-1001          | Sample B         | SAN DIEGO  
-- ID-1002          | Sample C         | SACRAMENTO 
-- ...


-- Q3
SELECT structure_number, county, facility_carried
FROM bridges
WHERE county IN (
    'SAN FRANCISCO',
    'SAN MATEO',
    'SANTA CLARA',
    'ALAMEDA',
    'CONTRA COSTA',
    'MARIN'
);
-- Expected output (first 5 rows, illustrative):
-- structure_number | county      | facility_carried
-- -----------------+-------------+-----------------
-- ID-1000          | LOS ANGELES | Sample A        
-- ID-1001          | SAN DIEGO   | Sample B        
-- ID-1002          | SACRAMENTO  | Sample C        
-- ...


-- Q4
SELECT structure_number, facility_carried, county, year_built
FROM bridges
WHERE year_built BETWEEN 1930 AND 1940;
-- Expected output (first 5 rows, illustrative):
-- structure_number | facility_carried | county      | year_built
-- -----------------+------------------+-------------+-----------
-- ID-1000          | Sample A         | LOS ANGELES | 1950      
-- ID-1001          | Sample B         | SAN DIEGO   | 1965      
-- ID-1002          | Sample C         | SACRAMENTO  | 1980      
-- ...


-- Q5
SELECT structure_number, facility_carried, features_intersected
FROM bridges
WHERE features_intersected LIKE '%RAILROAD%';
-- Expected output (first 5 rows, illustrative):
-- structure_number | facility_carried | features_intersected
-- -----------------+------------------+---------------------
-- ID-1000          | Sample A         | Sample A            
-- ID-1001          | Sample B         | Sample B            
-- ID-1002          | Sample C         | Sample C            
-- ...


-- Q6
SELECT structure_number, facility_carried, county, year_reconstructed
FROM bridges
WHERE year_reconstructed IS NOT NULL;
-- Expected output (first 5 rows, illustrative):
-- structure_number | facility_carried | county      | year_reconstructed
-- -----------------+------------------+-------------+-------------------
-- ID-1000          | Sample A         | LOS ANGELES | 1950              
-- ID-1001          | Sample B         | SAN DIEGO   | 1965              
-- ID-1002          | Sample C         | SACRAMENTO  | 1980              
-- ...


-- Q7
SELECT structure_number, facility_carried, county, deck_condition
FROM bridges
WHERE deck_condition IS NULL;
-- Expected output (first 5 rows, illustrative):
-- structure_number | facility_carried | county      | deck_condition
-- -----------------+------------------+-------------+---------------
-- ID-1000          | Sample A         | LOS ANGELES | 10            
-- ID-1001          | Sample B         | SAN DIEGO   | 25            
-- ID-1002          | Sample C         | SACRAMENTO  | 42            
-- ...


-- Q8
SELECT
    structure_number,
    facility_carried,
    county,
    year_built,
    deck_condition
FROM bridges
WHERE county = 'LOS ANGELES'
  AND year_built < 1950
  AND facility_carried LIKE '%HIGHWAY%'
  AND deck_condition <= 5;
-- Expected output (first 5 rows, illustrative):
-- structure_number | facility_carried | county      | year_built | deck_condition
-- -----------------+------------------+-------------+------------+---------------
-- ID-1000          | Sample A         | LOS ANGELES | 1950       | 10            
-- ID-1001          | Sample B         | SAN DIEGO   | 1965       | 25            
-- ID-1002          | Sample C         | SACRAMENTO  | 1980       | 42            
-- ...

