-- Answer Key for Exercise 5.1: Subqueries

-- Q1
SELECT structure_number, facility_carried, county, total_length_m
FROM bridges
WHERE total_length_m = (
    SELECT MAX(total_length_m)
    FROM bridges
);

-- Q2
SELECT structure_number, facility_carried, county, year_built
FROM bridges
WHERE year_built < (
    SELECT AVG(year_built)
    FROM bridges
);

-- Q3
SELECT structure_number, facility_carried, county, deck_condition
FROM bridges
WHERE county IN (
    SELECT county
    FROM bridges
    GROUP BY county
    HAVING AVG(deck_condition) < 6
);

-- Q4
SELECT DISTINCT contractor_name
FROM contracts
WHERE bid_amount > (
    SELECT AVG(bid_amount)
    FROM contracts
);

-- Q5
SELECT b.structure_number, b.facility_carried, b.county, b.total_length_m
FROM bridges b
WHERE b.total_length_m > (
    SELECT AVG(b2.total_length_m)
    FROM bridges b2
    WHERE b2.county = b.county
);

-- Q6
SELECT c.contract_id, c.contractor_name, c.bid_amount
FROM contracts c
WHERE c.bid_amount = (
    SELECT MAX(c2.bid_amount)
    FROM contracts c2
    WHERE c2.contractor_name = c.contractor_name
);

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
