/*
===============================================================================
Change Over Time Analysis
===============================================================================
Objective:
    - Examine how key esports metrics evolve over time.
    - Detect trends, growth patterns, and possible seasonal effects.
Techniques Used:
    - Date functions (YEAR, MONTH, DATETRUNC, FORMAT)
    - Aggregation (SUM, COUNT, AVG)
Summary:
    The queries below evaluate match performance across different time
    intervals, providing insights into player activity, kill trends,
    damage output, and tournament engagement over time.
===============================================================================
*/

-- Analyse match performance over time
-- Quick Date Functions
SELECT
    YEAR(match_date)              AS match_year,
    MONTH(match_date)             AS match_month,
    COUNT(DISTINCT match_id)      AS total_matches,
    COUNT(DISTINCT player_key)    AS total_players,
    SUM(kills)                    AS total_kills,
    SUM(damage_dealt)             AS total_damage,
    AVG(kda_ratio)                AS avg_kda,
    AVG(CAST(acs AS FLOAT))       AS avg_acs
FROM esports.fact_matchstats
WHERE match_date IS NOT NULL
GROUP BY YEAR(match_date), MONTH(match_date)
ORDER BY YEAR(match_date), MONTH(match_date);

-- DATETRUNC()
SELECT
    DATETRUNC(month, match_date)  AS match_date,
    COUNT(DISTINCT match_id)      AS total_matches,
    COUNT(DISTINCT player_key)    AS total_players,
    SUM(kills)                    AS total_kills,
    SUM(damage_dealt)             AS total_damage,
    AVG(kda_ratio)                AS avg_kda
FROM esports.fact_matchstats
WHERE match_date IS NOT NULL
GROUP BY DATETRUNC(month, match_date)
ORDER BY DATETRUNC(month, match_date);

-- FORMAT()
SELECT
    FORMAT(match_date, 'yyyy-MMM') AS match_date,
    COUNT(DISTINCT match_id)       AS total_matches,
    COUNT(DISTINCT player_key)     AS total_players,
    SUM(kills)                     AS total_kills,
    SUM(damage_dealt)              AS total_damage,
    AVG(kda_ratio)                 AS avg_kda
FROM esports.fact_matchstats
WHERE match_date IS NOT NULL
GROUP BY FORMAT(match_date, 'yyyy-MMM')
ORDER BY FORMAT(match_date, 'yyyy-MMM');

-- Analyse tournament prize pool growth over time by year
SELECT
    YEAR(start_date)          AS tournament_year,
    COUNT(tournament_key)     AS total_tournaments,
    SUM(prize_pool_usd)       AS total_prize_pool,
    AVG(prize_pool_usd)       AS avg_prize_pool
FROM esports.dim_tournaments
WHERE start_date IS NOT NULL
GROUP BY YEAR(start_date)
ORDER BY YEAR(start_date);

-- Track how many new players joined the roster each year
SELECT
    YEAR(joined_date)         AS join_year,
    COUNT(player_key)         AS new_players
FROM esports.dim_players
WHERE joined_date IS NOT NULL
GROUP BY YEAR(joined_date)
ORDER BY YEAR(joined_date);
