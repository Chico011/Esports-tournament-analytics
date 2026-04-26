/*
===============================================================================
Player Report
===============================================================================
Purpose:
    - Consolidates key player metrics and behavioral patterns into one view.
Highlights:
    1. Pulls essential fields such as gamertag, age, game title, and match details.
    2. Classifies players into segments (Elite, Regular, Rookie) and age groups.
    3. Aggregates player-level metrics:
       - total matches
       - total kills
       - total assists
       - total damage dealt
       - total clutches
       - lifespan (in months)
    4. Derives key KPIs:
       - recency (months since last match)
       - average kills per match
       - average KDA ratio
       - average damage per match
===============================================================================
*/

IF OBJECT_ID('esports.report_players', 'V') IS NOT NULL
    DROP VIEW esports.report_players;
GO

CREATE VIEW esports.report_players AS

WITH base_query AS (
/*---------------------------------------------------------------------------
1) Base Query: Pulls core columns from the match stats and player tables
---------------------------------------------------------------------------*/
SELECT
    f.stat_key,
    f.match_id,
    f.match_date,
    f.kills,
    f.deaths,
    f.assists,
    f.kda_ratio,
    f.damage_dealt,
    f.acs,
    f.clutches,
    f.match_outcome,
    p.player_key,
    p.player_id,
    p.gamertag,
    p.game_title,
    p.role,
    p.org_name,
    p.region,
    p.country,
    p.status,
    DATEDIFF(year, p.date_of_birth, GETDATE()) AS age
FROM esports.fact_matchstats f
LEFT JOIN esports.dim_players p
    ON p.player_key = f.player_key
WHERE f.match_date IS NOT NULL
),

player_aggregation AS (
/*---------------------------------------------------------------------------
2) Player Aggregations: Summarizes key metrics at the player level
---------------------------------------------------------------------------*/
SELECT
    player_key,
    player_id,
    gamertag,
    game_title,
    role,
    org_name,
    region,
    country,
    status,
    age,
    COUNT(DISTINCT match_id)          AS total_matches,
    SUM(kills)                        AS total_kills,
    SUM(assists)                      AS total_assists,
    SUM(damage_dealt)                 AS total_damage,
    SUM(clutches)                     AS total_clutches,
    AVG(kda_ratio)                    AS avg_kda,
    AVG(CAST(acs AS FLOAT))           AS avg_acs,
    MAX(match_date)                   AS last_match_date,
    DATEDIFF(month, MIN(match_date), MAX(match_date)) AS lifespan
FROM base_query
GROUP BY
    player_key,
    player_id,
    gamertag,
    game_title,
    role,
    org_name,
    region,
    country,
    status,
    age
)

SELECT
    player_key,
    player_id,
    gamertag,
    game_title,
    role,
    org_name,
    region,
    country,
    status,
    age,
    CASE
        WHEN age < 20                THEN 'Under 20'
        WHEN age BETWEEN 20 AND 23  THEN '20-23'
        WHEN age BETWEEN 24 AND 26  THEN '24-26'
        WHEN age BETWEEN 27 AND 29  THEN '27-29'
        ELSE '30 and above'
    END AS age_group,
    CASE
        WHEN lifespan >= 6 AND total_kills > 200  THEN 'Elite'
        WHEN lifespan >= 6 AND total_kills <= 200 THEN 'Regular'
        ELSE 'Rookie'
    END AS player_segment,
    last_match_date,
    DATEDIFF(month, last_match_date, GETDATE()) AS recency,
    total_matches,
    total_kills,
    total_assists,
    total_damage,
    total_clutches,
    avg_kda,
    avg_acs,
    lifespan,
    CASE
        WHEN total_matches = 0 THEN 0
        ELSE total_kills / total_matches
    END AS avg_kills_per_match,
    CASE
        WHEN total_matches = 0 THEN 0
        ELSE total_damage / total_matches
    END AS avg_damage_per_match,
    CASE
        WHEN lifespan = 0 THEN total_kills
        ELSE total_kills / lifespan
    END AS avg_monthly_kills
FROM player_aggregation;
GO
