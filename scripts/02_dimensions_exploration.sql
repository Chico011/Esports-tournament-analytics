/*
===============================================================================
Dimensions Exploration
===============================================================================
Purpose:
    - Dig into the dimension tables to understand the unique values and 
      categories they contain.
SQL Functions Used:
    - DISTINCT
    - ORDER BY
===============================================================================
*/

-- Find all the distinct countries represented in the player records
SELECT DISTINCT 
    country 
FROM esports.dim_players
ORDER BY country;

-- Find all the distinct regions players are competing from
SELECT DISTINCT 
    region 
FROM esports.dim_players
ORDER BY region;

-- Break down the player roster by game title, role, and organisation
SELECT DISTINCT 
    game_title, 
    role, 
    org_name 
FROM esports.dim_players
ORDER BY game_title, role, org_name;

-- Find all the distinct player statuses in the roster
SELECT DISTINCT 
    status 
FROM esports.dim_players
ORDER BY status;

-- Break down the tournament catalog by game title, format, and stage
SELECT DISTINCT 
    game_title, 
    format, 
    stage 
FROM esports.dim_tournaments
ORDER BY game_title, format, stage;

-- Find all the distinct venues used to host tournaments
SELECT DISTINCT 
    venue 
FROM esports.dim_tournaments
ORDER BY venue;

-- Find all the distinct sponsors backing the tournaments
SELECT DISTINCT 
    sponsor 
FROM esports.dim_tournaments
ORDER BY sponsor;

-- Find all the distinct maps played across all matches
SELECT DISTINCT 
    map_played 
FROM esports.fact_matchstats
ORDER BY map_played;

-- Find all the distinct match outcomes recorded
SELECT DISTINCT 
    match_outcome 
FROM esports.fact_matchstats
ORDER BY match_outcome;
