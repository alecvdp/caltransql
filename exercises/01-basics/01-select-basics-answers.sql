-- Answer Key for Exercise 1.1: SELECT Basics

-- Q1
SELECT structure_number, owner, year_built
FROM bridges
LIMIT 20;

-- Q2
SELECT *
FROM bridges
LIMIT 5;

-- Q3
SELECT facility_carried, features_intersected
FROM bridges
LIMIT 15;

-- Q4
SELECT DISTINCT owner
FROM bridges
ORDER BY owner;

-- Q5
SELECT DISTINCT deck_condition
FROM bridges
ORDER BY deck_condition;

-- Q6
SELECT
    county AS county_name,
    facility_carried AS bridge_name,
    total_length_m AS length_meters
FROM bridges
LIMIT 10;
