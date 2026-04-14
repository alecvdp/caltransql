-- Answer Key for Exercise 5.1: Subqueries

-- Q1
SELECT structure_number, facility_carried, county, total_length_m
FROM bridges
WHERE total_length_m = (
    SELECT MAX(total_length_m)
    FROM bridges
);
-- Expected output (first 5 rows, illustrative):
-- structure_number | facility_carried | county      | total_length_m
-- -----------------+------------------+-------------+---------------
-- ID-1000          | Sample A         | LOS ANGELES | 10            
-- ID-1001          | Sample B         | SAN DIEGO   | 25            
-- ID-1002          | Sample C         | SACRAMENTO  | 42            
-- ...


-- Q2
SELECT structure_number, facility_carried, county, year_built
FROM bridges
WHERE year_built < (
    SELECT AVG(year_built)
    FROM bridges
);
-- Expected output (first 5 rows, illustrative):
-- structure_number | facility_carried | county      | year_built
-- -----------------+------------------+-------------+-----------
-- ID-1000          | Sample A         | LOS ANGELES | 1950      
-- ID-1001          | Sample B         | SAN DIEGO   | 1965      
-- ID-1002          | Sample C         | SACRAMENTO  | 1980      
-- ...


-- Q3
SELECT structure_number, facility_carried, county, deck_condition
FROM bridges
WHERE county IN (
    SELECT county
    FROM bridges
    GROUP BY county
    HAVING AVG(deck_condition) < 6
);
-- Expected output (first 5 rows, illustrative):
-- structure_number | facility_carried | county      | deck_condition
-- -----------------+------------------+-------------+---------------
-- ID-1000          | Sample A         | LOS ANGELES | 10            
-- ID-1001          | Sample B         | SAN DIEGO   | 25            
-- ID-1002          | Sample C         | SACRAMENTO  | 42            
-- ...


-- Q4
SELECT DISTINCT contractor_name
FROM contracts
WHERE bid_amount > (
    SELECT AVG(bid_amount)
    FROM contracts
);
-- Expected output (first 5 rows, illustrative):
-- contractor_name
-- ---------------
-- Sample A       
-- Sample B       
-- Sample C       
-- ...


-- Q5
SELECT b.structure_number, b.facility_carried, b.county, b.total_length_m
FROM bridges b
WHERE b.total_length_m > (
    SELECT AVG(b2.total_length_m)
    FROM bridges b2
    WHERE b2.county = b.county
);
-- Expected output (first 5 rows, illustrative):
-- structure_number | facility_carried | county      | total_length_m
-- -----------------+------------------+-------------+---------------
-- ID-1000          | Sample A         | LOS ANGELES | 10            
-- ID-1001          | Sample B         | SAN DIEGO   | 25            
-- ID-1002          | Sample C         | SACRAMENTO  | 42            
-- ...


-- Q6
SELECT c.contract_id, c.contractor_name, c.bid_amount
FROM contracts c
WHERE c.bid_amount = (
    SELECT MAX(c2.bid_amount)
    FROM contracts c2
    WHERE c2.contractor_name = c.contractor_name
);
-- Expected output (first 5 rows, illustrative):
-- contract_id | contractor_name | bid_amount
-- ------------+-----------------+-----------
-- ID-1000     | Sample A        | 10        
-- ID-1001     | Sample B        | 25        
-- ID-1002     | Sample C        | 42        
-- ...


-- Q7
SELECT
    b.structure_number,
    b.county,
    b.year_built,
    (
        SELECT AVG(b2.year_built)
        FROM bridges b2
        WHERE b2.county = b.county
    ) AS county_avg_year_built,
    b.year_built - (
        SELECT AVG(b2.year_built)
        FROM bridges b2
        WHERE b2.county = b.county
    ) AS difference_from_county_avg
FROM bridges b
LIMIT 20;
-- Expected output (first 5 rows, illustrative):
-- structure_number | county      | year_built | county_avg_year_built | difference_from_county_avg
-- -----------------+-------------+------------+-----------------------+---------------------------
-- ID-1000          | LOS ANGELES | 1950       | 1950                  | 10                        
-- ID-1001          | SAN DIEGO   | 1965       | 1965                  | 25                        
-- ID-1002          | SACRAMENTO  | 1980       | 1980                  | 42                        
-- ...

