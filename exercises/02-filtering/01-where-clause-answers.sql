-- Answer Key for Exercise 2.1: WHERE Clause

-- Q1
SELECT *
FROM bridges
WHERE county = 'SACRAMENTO';

-- Q2
SELECT structure_number, facility_carried, county, year_built
FROM bridges
WHERE year_built < 1950;

-- Q3
SELECT structure_number, facility_carried, owner
FROM bridges
WHERE owner = 'State Highway Agency';

-- Q4
SELECT structure_number, facility_carried, deck_condition
FROM bridges
WHERE deck_condition = 9;

-- Q5
SELECT structure_number, facility_carried, county, total_length_m
FROM bridges
WHERE total_length_m > 1000
ORDER BY total_length_m DESC;

-- Q6
SELECT structure_number, facility_carried, year_built
FROM bridges
WHERE year_built <> 2010;

-- Q7
SELECT structure_number, facility_carried, year_built
FROM bridges
WHERE year_built >= 1990
  AND year_built <= 2000;

-- Q8
SELECT structure_number, facility_carried, county, year_built
FROM bridges
WHERE county = 'SAN FRANCISCO'
  AND year_built > 2000;

-- Q9
SELECT structure_number, facility_carried, owner
FROM bridges
WHERE owner = 'City or Municipal Highway Agency'
   OR owner = 'County Highway Agency';

-- Q10
SELECT structure_number, facility_carried, county, deck_condition
FROM bridges
WHERE county = 'LOS ANGELES'
  AND deck_condition >= 7;
