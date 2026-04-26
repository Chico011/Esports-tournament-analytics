/*
===============================================================================
Category Contribution Analysis
===============================================================================
Objective:
    - Evaluate how each category contributes to overall esports performance.
    - Identify dominant game titles, regions, and maps by their relative impact.
    - Support decision-making for resource allocation and strategy focus.
Techniques Used:
    - Aggregation (SUM)
    - Window functions (SUM() OVER())
    - Percentage calculations
Summary:
    These queries break down total kills, damage, and prize pools by category
    and calculate each segment's share of the overall total to highlight
    performance weight across the esports dataset.
===============================================================================
*/

-- Which game title contributes the most to total kills across all matches?
WITH game_kills AS (
    SELECT
        p.game_title,
        SUM(f.kills) AS total_kills
    FROM esports.fact_matchstats f
    LEFT JOIN esports.dim_players p
        ON p.player_key = f.player_key
    GROUP BY p.game_title
)
SELECT
    game_title,
    total_kills,
    SUM(total_kills) OVER ()                                                    AS overall_kills,
    ROUND((CAST(total_kills AS FLOAT) / SUM(total_kills) OVER ()) * 100, 2)    AS percentage_of_total
FROM game_kills
ORDER BY total_kills DESC;

-- Which region contributes the most to total damage dealt?
WITH region_damage AS (
    SELECT
        p.region,
        SUM(f.damage_dealt) AS total_damage
    FROM esports.fact_matchstats f
    LEFT JOIN esports.dim_players p
        ON p.player_key = f.player_key
    GROUP BY p.region
)
SELECT
    region,
    total_damage,
    SUM(total_damage) OVER ()                                                   AS overall_damage,
    ROUND((CAST(total_damage AS FLOAT) / SUM(total_damage) OVER ()) * 100, 2)  AS percentage_of_total
FROM region_damage
ORDER BY total_damage DESC;

-- Which game title contributes the most to the total prize pool?
WITH game_prize AS (
    SELECT
        game_title,
        SUM(prize_pool_usd) AS total_prize_pool
    FROM esports.dim_tournaments
    GROUP BY game_title
)
SELECT
    game_title,
    total_prize_pool,
    SUM(total_prize_pool) OVER ()                                                       AS overall_prize_pool,
    ROUND((CAST(total_prize_pool AS FLOAT) / SUM(total_prize_pool) OVER ()) * 100, 2)  AS percentage_of_total
FROM game_prize
ORDER BY total_prize_pool DESC;

-- Which map contributes the most to total matches played?
WITH map_matches AS (
    SELECT
        map_played,
        COUNT(DISTINCT match_id) AS total_matches
    FROM esports.fact_matchstats
    GROUP BY map_played
)
SELECT
    map_played,
    total_matches,
    SUM(total_matches) OVER ()                                                      AS overall_matches,
    ROUND((CAST(total_matches AS FLOAT) / SUM(total_matches) OVER ()) * 100, 2)    AS percentage_of_total
FROM map_matches
ORDER BY total_matches DESC;

-- Which organisation contributes the most players to the roster?
WITH org_players AS (
    SELECT
        org_name,
        COUNT(player_key) AS total_players
    FROM esports.dim_players
    GROUP BY org_name
)
SELECT
    org_name,
    total_players,
    SUM(total_players) OVER ()                                                      AS overall_players,
    ROUND((CAST(total_players AS FLOAT) / SUM(total_players) OVER ()) * 100, 2)    AS percentage_of_total
FROM org_players
ORDER BY total_players DESC;
