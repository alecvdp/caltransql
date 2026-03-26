-- Hints for Practice Project: Inflation-Adjusted Construction Costs

-- Part 1 hint:
-- EXTRACT(YEAR FROM award_date) and EXTRACT(QUARTER FROM award_date)
-- can map a contract into the index table.

-- Part 2 hint:
-- Put the latest NHCCI value in its own one-row CTE and CROSS JOIN it.

-- Part 3 hint:
-- Compute adjusted contract values once in a base CTE, then aggregate by year.

-- Part 4 hint:
-- Join projects after you have contract-quarter matches working.

-- Deliverable hint:
-- It helps to keep a reusable `adjusted_contracts` CTE and build each final output from it.
