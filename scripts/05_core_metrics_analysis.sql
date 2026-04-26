/*
===============================================================================
Core Metrics Analysis
===============================================================================
Objective:
    - Compute key summary values to understand overall esports performance.
    - Highlight important figures related to matches, players, and tournaments.
Functions Applied:
    - COUNT(), SUM(), AVG()
===============================================================================
*/

-- Find the total number of matches played
SELECT COUNT(stat_key) AS total_matches FROM esports.fact_matchstats;

-- Find the total kills across all matches
SELECT SUM(kills) AS total_kills FROM esports.fact_matchstats;

-- Find the total assists across all matches
SELECT SUM(assists) AS total_assists FROM esports.fact_matchstats;

-- Find the total damage dealt across all matches
SELECT SUM(damage_dealt) AS total_damage_dealt FROM esports.fact_matchstats;

-- Find the average KDA ratio across all matches
SELECT AVG(kda_ratio) AS avg_kda FROM esports.fact_matchstats;

-- Find the average ACS (Average Combat Score) across all matches
SELECT AVG(CAST(acs AS FLOAT)) AS avg_acs FROM esports.fact_matchstats;

-- Find the average headshot percentage across all matches
SELECT AVG(headshot_pct) AS avg_headshot_pct FROM esports.fact_matchstats;

-- Find the total number of unique matches played
SELECT COUNT(DISTINCT match_id) AS total_unique_matches FROM esports.fact_matchstats;

-- Find the total number of players in the roster
SELECT COUNT(player_key) AS total_players FROM esports.dim_players;

-- Find the total number of players that have appeared in a match
SELECT COUNT(DISTINCT player_key) AS total_active_players FROM esports.fact_matchstats;

-- Find the total number of tournaments
SELECT COUNT(tournament_key) AS total_tournaments FROM esports.dim_tournaments;

-- Find the total prize pool distributed across all tournaments
SELECT SUM(prize_pool_usd) AS total_prize_pool FROM esports.dim_tournaments;

-- Find the average prize pool per tournament
SELECT AVG(prize_pool_usd) AS avg_prize_pool FROM esports.dim_tournaments;

-- Find the total number of game titles covered
SELECT COUNT(DISTINCT game_title) AS total_game_titles FROM esports.dim_tournaments;

-- Generate a report that shows all key metrics of the esports project
SELECT 'Total Matches' AS measure_name, COUNT(DISTINCT match_id) AS measure_value FROM esports.fact_matchstats
UNION ALL
SELECT 'Total Kills', SUM(kills)  FROM esports.fact_matchstats
UNION ALL
SELECT 'Total Assists', SUM(assists)  FROM esports.fact_matchstats
UNION ALL
SELECT 'Total Damage Dealt', SUM(damage_dealt) FROM esports.fact_matchstats
UNION ALL
SELECT 'Average KDA', AVG(kda_ratio) FROM esports.fact_matchstats
UNION ALL
SELECT 'Average ACS', AVG(CAST(acs AS FLOAT)) FROM esports.fact_matchstats
UNION ALL
SELECT 'Total Players', COUNT(player_key) FROM esports.dim_players
UNION ALL
SELECT 'Active Players in Matches', COUNT(DISTINCT player_key) FROM esports.fact_matchstats
UNION ALL
SELECT 'Total Tournaments', COUNT(tournament_key) FROM esports.dim_tournaments
UNION ALL
SELECT 'Total Prize Pool', SUM(prize_pool_usd) FROM esports.dim_tournaments
UNION ALL
SELECT 'Average Prize Pool',AVG(prize_pool_usd) FROM esports.dim_tournaments
UNION ALL
SELECT 'Total Game Titles', COUNT(DISTINCT game_title) FROM esports.dim_tournaments;
