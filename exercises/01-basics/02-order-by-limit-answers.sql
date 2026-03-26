-- Answer Key for Exercise 1.2: ORDER BY, LIMIT, and NULL Handling

-- Q1
SELECT structure_number, county, facility_carried, year_built
FROM bridges
ORDER BY year_built ASC
LIMIT 15;

-- Q2
SELECT structure_number, facility_carried, county, adt, adt_year
FROM bridges
ORDER BY adt DESC NULLS LAST
LIMIT 20;

-- Q3
SELECT structure_number, facility_carried, county, deck_width_m
FROM bridges
ORDER BY deck_width_m ASC NULLS LAST
LIMIT 10;

-- Q4
SELECT structure_number, facility_carried, deck_condition, year_built
FROM bridges
WHERE county = 'LOS ANGELES'
ORDER BY deck_condition ASC NULLS LAST, year_built ASC
LIMIT 25;

-- Q5
SELECT structure_number, facility_carried, county, year_built, year_reconstructed
FROM bridges
WHERE year_reconstructed IS NOT NULL
ORDER BY year_reconstructed DESC
LIMIT 15;

-- Q6
SELECT structure_number, county, facility_carried, year_built
FROM bridges
ORDER BY county ASC, year_built ASC
LIMIT 30;

-- Q7
SELECT structure_number, county, facility_carried, deck_condition, total_length_m
FROM bridges
ORDER BY deck_condition ASC NULLS LAST, total_length_m DESC NULLS LAST
LIMIT 20;

-- Q8
SELECT structure_number, county, facility_carried, year_built, adt
FROM bridges
WHERE year_built < 1960
  AND adt > 50000
ORDER BY year_built ASC, adt DESC;
