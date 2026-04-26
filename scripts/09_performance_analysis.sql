/*
===============================================================================
Performance Analysis (Year-over-Year & Benchmarking)
===============================================================================
Purpose:
    - To measure performance trends across time periods.
    - To compare current performance with historical results.
    - To identify growth, decline, and top-performing entities.
Key Concepts:
    - Window functions: LAG(), AVG() OVER()
    - Year-over-year comparisons
    - Conditional logic using CASE statements
Overview:
    These queries evaluate player performance by comparing yearly KDA
    and kill counts against previous years and overall player averages.
===============================================================================
*/

-- Year-over-Year KDA Performance per Player
WITH yearly_player_kda AS (
    SELECT
        YEAR(f.match_date)        AS match_year,
        p.gamertag,
        p.game_title,
        AVG(f.kda_ratio)          AS current_kda
    FROM esports.fact_matchstats f
    LEFT JOIN esports.dim_players p
        ON f.player_key = p.player_key
    WHERE f.match_date IS NOT NULL
    GROUP BY
        YEAR(f.match_date),
        p.gamertag,
        p.game_title
)
SELECT
    match_year,
    gamertag,
    game_title,
    current_kda,
    AVG(current_kda) OVER (PARTITION BY gamertag)                                      AS avg_kda,
    current_kda - AVG(current_kda) OVER (PARTITION BY gamertag)                        AS diff_avg,
    CASE
        WHEN current_kda - AVG(current_kda) OVER (PARTITION BY gamertag) > 0 THEN 'Above Avg'
        WHEN current_kda - AVG(current_kda) OVER (PARTITION BY gamertag) < 0 THEN 'Below Avg'
        ELSE 'Avg'
    END AS avg_change,
    -- Year-over-Year Analysis
    LAG(current_kda) OVER (PARTITION BY gamertag ORDER BY match_year)                  AS py_kda,
    current_kda - LAG(current_kda) OVER (PARTITION BY gamertag ORDER BY match_year)    AS diff_py,
    CASE
        WHEN current_kda - LAG(current_kda) OVER (PARTITION BY gamertag ORDER BY match_year) > 0 THEN 'Increase'
        WHEN current_kda - LAG(current_kda) OVER (PARTITION BY gamertag ORDER BY match_year) < 0 THEN 'Decrease'
        ELSE 'No Change'
    END AS py_change
FROM yearly_player_kda
ORDER BY gamertag, match_year;

-- Year-over-Year Kill Performance per Player
WITH yearly_player_kills AS (
    SELECT
        YEAR(f.match_date)   AS match_year,
        p.gamertag,
        p.game_title,
        SUM(f.kills)         AS current_kills
    FROM esports.fact_matchstats f
    LEFT JOIN esports.dim_players p
        ON f.player_key = p.player_key
    WHERE f.match_date IS NOT NULL
    GROUP BY
        YEAR(f.match_date),
        p.gamertag,
        p.game_title
)
SELECT
    match_year,
    gamertag,
    game_title,
    current_kills,
    AVG(current_kills) OVER (PARTITION BY gamertag)                                                 AS avg_kills,
    current_kills - AVG(current_kills) OVER (PARTITION BY gamertag)                                 AS diff_avg,
    CASE
        WHEN current_kills - AVG(current_kills) OVER (PARTITION BY gamertag) > 0 THEN 'Above Avg'
        WHEN current_kills - AVG(current_kills) OVER (PARTITION BY gamertag) < 0 THEN 'Below Avg'
        ELSE 'Avg'
    END AS avg_change,
    -- Year-over-Year Analysis
    LAG(current_kills) OVER (PARTITION BY gamertag ORDER BY match_year)                    AS py_kills,
    current_kills - LAG(current_kills) OVER (PARTITION BY gamertag ORDER BY match_year)    AS diff_py,
    CASE
        WHEN current_kills - LAG(current_kills) OVER (PARTITION BY gamertag ORDER BY match_year) > 0 THEN 'Increase'
        WHEN current_kills - LAG(current_kills) OVER (PARTITION BY gamertag ORDER BY match_year) < 0 THEN 'Decrease'
        ELSE 'No Change'
    END AS py_change
FROM yearly_player_kills
ORDER BY gamertag, match_year;

-- Year-over-Year Prize Pool per Tournament Game Title
WITH yearly_prize_pool AS (
    SELECT
        YEAR(start_date)       AS tournament_year,
        game_title,
        SUM(prize_pool_usd)    AS current_prize_pool
    FROM esports.dim_tournaments
    WHERE start_date IS NOT NULL
    GROUP BY
        YEAR(start_date),
        game_title
)
SELECT
    tournament_year,
    game_title,
    current_prize_pool,
    AVG(current_prize_pool) OVER (PARTITION BY game_title)                                                      AS avg_prize_pool,
    current_prize_pool - AVG(current_prize_pool) OVER (PARTITION BY game_title)                                 AS diff_avg,
    CASE
        WHEN current_prize_pool - AVG(current_prize_pool) OVER (PARTITION BY game_title) > 0 THEN 'Above Avg'
        WHEN current_prize_pool - AVG(current_prize_pool) OVER (PARTITION BY game_title) < 0 THEN 'Below Avg'
        ELSE 'Avg'
    END AS avg_change,
    -- Year-over-Year Analysis
    LAG(current_prize_pool) OVER (PARTITION BY game_title ORDER BY tournament_year)                             AS py_prize_pool,
    current_prize_pool - LAG(current_prize_pool) OVER (PARTITION BY game_title ORDER BY tournament_year)        AS diff_py,
    CASE
        WHEN current_prize_pool - LAG(current_prize_pool) OVER (PARTITION BY game_title ORDER BY tournament_year) > 0 THEN 'Increase'
        WHEN current_prize_pool - LAG(current_prize_pool) OVER (PARTITION BY game_title ORDER BY tournament_year) < 0 THEN 'Decrease'
        ELSE 'No Change'
    END AS py_change
FROM yearly_prize_pool
ORDER BY game_title, tournament_year;
