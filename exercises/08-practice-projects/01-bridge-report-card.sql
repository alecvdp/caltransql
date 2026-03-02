-- ============================================================
-- Practice Project: California Bridge Report Card
-- ============================================================
-- Build a comprehensive "report card" for California's bridges.
-- This project ties together many SQL concepts.
--
-- Work through each section to build up a full analysis.
-- There are no "right answers" - explore and discover!
-- ============================================================


-- ============================================================
-- PART 1: The Big Picture
-- ============================================================

-- 1A: How many bridges total are in California?


-- 1B: What's the breakdown of bridges by owner type?
--     Show count and percentage of total.


-- 1C: What decade has the most bridges? Group year_built by decade.
--     (Hint: use integer division: (year_built / 10) * 10)


-- ============================================================
-- PART 2: Condition Assessment
-- ============================================================

-- 2A: What is the distribution of deck_condition ratings?
--     Show each rating, count, and percentage.


-- 2B: Which 10 counties have the lowest average deck_condition?


-- 2C: How does bridge condition correlate with age?
--     Group bridges by decade built and show average deck_condition.
--     Do older bridges have worse conditions?


-- ============================================================
-- PART 3: The Oldest & Longest
-- ============================================================

-- 3A: Find the 10 oldest bridges still in service.
--     Show their location, what they carry, and condition.


-- 3B: Find the 10 longest bridges.
--     Show county, facility_carried, and total_length_m.


-- 3C: For each county, find the oldest bridge.
--     Use a window function or correlated subquery.


-- ============================================================
-- PART 4: Construction Trends (uses construction_projects table)
-- ============================================================

-- 4A: How many construction projects are there per county?
--     How does this compare to the number of bridges?


-- 4B: What is the total and average cost of projects per county?


-- 4C: Find the top 10 most expensive construction projects.
--     What types of work are they?


-- ============================================================
-- PART 5: Your Own Analysis
-- ============================================================

-- Come up with 3 questions of your own and write queries
-- to answer them. Think about what would be useful to know
-- from a construction engineering perspective!

-- Your Question 1:
-- Your Query:


-- Your Question 2:
-- Your Query:


-- Your Question 3:
-- Your Query:

