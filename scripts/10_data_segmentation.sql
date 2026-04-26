/*
===============================================================================
Data Segmentation Analysis
===============================================================================
Purpose:
    - Group data into meaningful categories for targeted insights.
    - Covers player segmentation, tournament categorization, and regional analysis.
SQL Functions Used:
    - CASE: Defines custom segmentation logic.
    - GROUP BY: Groups data into segments.
===============================================================================
*/

/* Segment tournaments into prize pool ranges and
count how many tournaments fall into each segment */
WITH tournament_segments AS (
    SELECT
        tournament_key,
        tournament_name,
        game_title,
        prize_pool_usd,
        CASE
            WHEN prize_pool_usd < 25000                        THEN 'Below $25K'
            WHEN prize_pool_usd BETWEEN 25000 AND 100000       THEN '$25K - $100K'
            WHEN prize_pool_usd BETWEEN 100001 AND 500000      THEN '$100K - $500K'
            WHEN prize_pool_usd BETWEEN 500001 AND 1000000     THEN '$500K - $1M'
            ELSE 'Above $1M'
        END AS prize_range
    FROM esports.dim_tournaments
)
SELECT
    prize_range,
    COUNT(tournament_key) AS total_tournaments
FROM tournament_segments
GROUP BY prize_range
ORDER BY total_tournaments DESC;

/* Segment players into salary ranges and
count how many players fall into each segment */
WITH salary_segments AS (
    SELECT
        player_key,
        gamertag,
        game_title,
        annual_salary_usd,
        CASE
            WHEN annual_salary_usd < 50000                      THEN 'Below $50K'
            WHEN annual_salary_usd BETWEEN 50000 AND 150000     THEN '$50K - $150K'
            WHEN annual_salary_usd BETWEEN 150001 AND 300000    THEN '$150K - $300K'
            ELSE 'Above $300K'
        END AS salary_range
    FROM esports.dim_players
)
SELECT
    salary_range,
    COUNT(player_key) AS total_players
FROM salary_segments
GROUP BY salary_range
ORDER BY total_players DESC;

/* Classify players into three segments based on match history and total kills:
    - Elite:   At least 6 months of activity and total kills above 200.
    - Regular: At least 6 months of activity but total kills 200 or below.
    - Rookie:  Active for less than 6 months.
*/
WITH player_activity AS (
    SELECT
        p.player_key,
        p.gamertag,
        p.game_title,
        SUM(f.kills)                                        AS total_kills,
        MIN(f.match_date)                                   AS first_match,
        MAX(f.match_date)                                   AS last_match,
        DATEDIFF(month, MIN(f.match_date), MAX(f.match_date)) AS lifespan
    FROM esports.fact_matchstats f
    LEFT JOIN esports.dim_players p
        ON f.player_key = p.player_key
    GROUP BY
        p.player_key,
        p.gamertag,
        p.game_title
)
SELECT
    player_segment,
    COUNT(player_key) AS total_players
FROM (
    SELECT
        player_key,
        CASE
            WHEN lifespan >= 6 AND total_kills > 200 THEN 'Elite'
            WHEN lifespan >= 6 AND total_kills <= 200 THEN 'Regular'
            ELSE 'Rookie'
        END AS player_segment
    FROM player_activity
) AS segmented_players
GROUP BY player_segment
ORDER BY total_players DESC;

/* Segment players by KDA performance tier */
WITH kda_segments AS (
    SELECT
        p.player_key,
        p.gamertag,
        p.game_title,
        AVG(f.kda_ratio) AS avg_kda,
        CASE
            WHEN AVG(f.kda_ratio) >= 3.0  THEN 'S-Tier (3.0+)'
            WHEN AVG(f.kda_ratio) >= 2.0  THEN 'A-Tier (2.0 - 2.99)'
            WHEN AVG(f.kda_ratio) >= 1.0  THEN 'B-Tier (1.0 - 1.99)'
            ELSE                               'C-Tier (Below 1.0)'
        END AS kda_tier
    FROM esports.fact_matchstats f
    LEFT JOIN esports.dim_players p
        ON f.player_key = p.player_key
    GROUP BY
        p.player_key,
        p.gamertag,
        p.game_title
)
SELECT
    kda_tier,
    COUNT(player_key) AS total_players
FROM kda_segments
GROUP BY kda_tier
ORDER BY total_players DESC;
