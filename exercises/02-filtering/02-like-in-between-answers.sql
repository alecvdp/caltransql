-- Answer Key for Exercise 2.2: LIKE, IN, BETWEEN

-- Q1
SELECT structure_number, facility_carried, county
FROM bridges
WHERE facility_carried LIKE 'STATE%';

-- Q2
SELECT structure_number, facility_carried, county
FROM bridges
WHERE facility_carried LIKE '%CREEK%';

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

-- Q4
SELECT structure_number, facility_carried, county, year_built
FROM bridges
WHERE year_built BETWEEN 1930 AND 1940;

-- Q5
SELECT structure_number, facility_carried, features_intersected
FROM bridges
WHERE features_intersected LIKE '%RAILROAD%';

-- Q6
SELECT structure_number, facility_carried, county, year_reconstructed
FROM bridges
WHERE year_reconstructed IS NOT NULL;

-- Q7
SELECT structure_number, facility_carried, county, deck_condition
FROM bridges
WHERE deck_condition IS NULL;

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
