/*
===============================================================================
Cumulative Performance Analysis
===============================================================================
Objective:
    - Compute progressive totals and rolling averages for key indicators.
    - Monitor how performance builds over time.
    - Reveal long-term patterns using cumulative calculations.
Techniques Used:
    - Window functions: SUM() OVER(), AVG() OVER()
    - Running totals and moving averages
Summary:
    The queries below evaluate aggregated match performance over time and
    apply window functions to highlight overall growth in kills, damage,
    and KDA trends across the esports dataset.
===============================================================================
*/

-- Calculate the total kills per year
-- and the running total of kills over time
SELECT
    match_date,
    total_kills,
    SUM(total_kills) OVER (ORDER BY match_date) AS running_total_kills,
    AVG(avg_kda) OVER (ORDER BY match_date) AS moving_average_kda
FROM
(
    SELECT
        DATETRUNC(year, match_date)       AS match_date,
        SUM(kills)                        AS total_kills,
        AVG(kda_ratio)                    AS avg_kda
    FROM esports.fact_matchstats
    WHERE match_date IS NOT NULL
    GROUP BY DATETRUNC(year, match_date)
) t;

-- Calculate the total damage dealt per year
-- and the running total of damage over time
SELECT
    match_date,
    total_damage,
    SUM(total_damage) OVER (ORDER BY match_date) AS running_total_damage,
    AVG(avg_acs) OVER (ORDER BY match_date) AS moving_average_acs
FROM
(
    SELECT
        DATETRUNC(year, match_date)   AS match_date,
        SUM(damage_dealt)             AS total_damage,
        AVG(CAST(acs AS FLOAT))       AS avg_acs
    FROM esports.fact_matchstats
    WHERE match_date IS NOT NULL
    GROUP BY DATETRUNC(year, match_date)
) t;

-- Calculate the total prize pool distributed per year
-- and the running total of prize pool over time
SELECT
    tournament_year,
    total_prize_pool,
    SUM(total_prize_pool) OVER (ORDER BY tournament_year) AS running_total_prize_pool,
    AVG(avg_prize_pool) OVER (ORDER BY tournament_year) AS moving_average_prize_pool
FROM
(
    SELECT
        DATETRUNC(year, start_date)   AS tournament_year,
        SUM(prize_pool_usd)           AS total_prize_pool,
        AVG(prize_pool_usd)           AS avg_prize_pool
    FROM esports.dim_tournaments
    WHERE start_date IS NOT NULL
    GROUP BY DATETRUNC(year, start_date)
) t;
