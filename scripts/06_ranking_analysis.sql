/*
===============================================================================
Performance Ranking Insights
===============================================================================
Objective:
    - Evaluate and rank players and tournaments based on key performance indicators.
    - Highlight both high-performing and underperforming entities.
Techniques Used:
    - Ranking functions (RANK, ROW_NUMBER)
    - Aggregation (SUM, COUNT, AVG)
    - GROUP BY and ORDER BY
Summary:
    The queries below focus on ranking players and tournaments by match
    performance and prize pool activity, helping to identify top contributors
    as well as areas with lower performance.
===============================================================================
*/

-- Which 5 players generated the highest total kills?
-- Simple Ranking
SELECT TOP 5
    p.gamertag,
    p.game_title,
    SUM(f.kills) AS total_kills
FROM esports.fact_matchstats f
LEFT JOIN esports.dim_players p
    ON p.player_key = f.player_key
GROUP BY p.gamertag, p.game_title
ORDER BY total_kills DESC;

-- Complex but Flexible Ranking Using Window Functions
SELECT *
FROM (
    SELECT
        p.gamertag,
        p.game_title,
        SUM(f.kills)  AS total_kills,
        RANK() OVER (ORDER BY SUM(f.kills) DESC) AS rank_players
    FROM esports.fact_matchstats f
    LEFT JOIN esports.dim_players p
        ON p.player_key = f.player_key
    GROUP BY p.gamertag, p.game_title
) AS ranked_players
WHERE rank_players <= 5;

-- What are the 5 lowest performing players in terms of total kills?
SELECT TOP 5
    p.gamertag,
    p.game_title,
    SUM(f.kills) AS total_kills
FROM esports.fact_matchstats f
LEFT JOIN esports.dim_players p
    ON p.player_key = f.player_key
GROUP BY p.gamertag, p.game_title
ORDER BY total_kills;

-- Find the top 10 players with the highest average KDA ratio
SELECT TOP 10
    p.player_key,
    p.gamertag,
    p.game_title,
    p.org_name,
    AVG(f.kda_ratio) AS avg_kda
FROM esports.fact_matchstats f
LEFT JOIN esports.dim_players p
    ON p.player_key = f.player_key
GROUP BY
    p.player_key,
    p.gamertag,
    p.game_title,
    p.org_name
ORDER BY avg_kda DESC;

-- Find the top 10 players with the highest average ACS
SELECT TOP 10
    p.player_key,
    p.gamertag,
    p.game_title,
    p.region,
    AVG(CAST(f.acs AS FLOAT)) AS avg_acs
FROM esports.fact_matchstats f
LEFT JOIN esports.dim_players p
    ON p.player_key = f.player_key
GROUP BY
    p.player_key,
    p.gamertag,
    p.game_title,
    p.region
ORDER BY avg_acs DESC;

-- Rank tournaments by total prize pool offered
SELECT *
FROM (
    SELECT
        tournament_name,
        game_title,
        region,
        prize_pool_usd,
        RANK() OVER (ORDER BY prize_pool_usd DESC) AS rank_tournaments
    FROM esports.dim_tournaments
) AS ranked_tournaments
WHERE rank_tournaments <= 10;

-- The 3 players with the fewest matches played
SELECT TOP 3
    p.player_key,
    p.gamertag,
    p.game_title,
    COUNT(DISTINCT f.match_id) AS total_matches
FROM esports.fact_matchstats f
LEFT JOIN esports.dim_players p
    ON p.player_key = f.player_key
GROUP BY
    p.player_key,
    p.gamertag,
    p.game_title
ORDER BY total_matches;
