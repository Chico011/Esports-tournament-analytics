/*
===============================================================================
Date Range Exploration
===============================================================================
Purpose:
    - Identify the earliest and latest dates across key data points.
    - Get a sense of how far back the historical data goes.
SQL Functions Used:
    - MIN(), MAX(), DATEDIFF()
===============================================================================
*/

-- Determine the first and last match date and the total duration in months
SELECT 
    MIN(match_date) AS first_match_date,
    MAX(match_date) AS last_match_date,
    DATEDIFF(MONTH, MIN(match_date), MAX(match_date)) AS match_range_months
FROM esports.fact_matchstats;

-- Determine the first and last tournament start date and total duration in months
SELECT 
    MIN(start_date) AS first_tournament_date,
    MAX(end_date)   AS last_tournament_date,
    DATEDIFF(MONTH, MIN(start_date), MAX(end_date)) AS tournament_range_months
FROM esports.dim_tournaments;

-- Find the youngest and oldest player based on their date of birth
SELECT
    MIN(date_of_birth) AS oldest_birthdate,
    DATEDIFF(YEAR, MIN(date_of_birth), GETDATE()) AS oldest_age,
    MAX(date_of_birth) AS youngest_birthdate,
    DATEDIFF(YEAR, MAX(date_of_birth), GETDATE()) AS youngest_age
FROM esports.dim_players;

-- Find the earliest and latest player join dates and how long the roster spans
SELECT
    MIN(joined_date) AS first_joined,
    MAX(joined_date) AS last_joined,
    DATEDIFF(YEAR, MIN(joined_date), MAX(joined_date)) AS roster_span_years
FROM esports.dim_players;
