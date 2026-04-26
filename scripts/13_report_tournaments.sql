/*
===============================================================================
Tournament Report
===============================================================================
Purpose:
    - Brings together key tournament metrics and performance patterns into one view.
Highlights:
    1. Pulls essential fields such as tournament name, game title, format, and prize pool.
    2. Classifies tournaments by prize pool into Major, Mid-Tier, or Minor events.
    3. Aggregates tournament-level metrics:
       - total matches
       - total players involved
       - total kills
       - total damage dealt
       - lifespan (in days)
    4. Derives key KPIs:
       - recency (months since last match in tournament)
       - average kills per match
       - average damage per match
       - average KDA across tournament
===============================================================================
*/

IF OBJECT_ID('esports.report_tournaments', 'V') IS NOT NULL
    DROP VIEW esports.report_tournaments;
GO

CREATE VIEW esports.report_tournaments AS

WITH base_query AS (
/*---------------------------------------------------------------------------
1) Base Query: Pulls core columns from fact_matchstats and dim_tournaments
---------------------------------------------------------------------------*/
    SELECT
        f.stat_key,
        f.match_id,
        f.match_date,
        f.player_key,
        f.kills,
        f.deaths,
        f.assists,
        f.kda_ratio,
        f.damage_dealt,
        f.acs,
        f.match_outcome,
        f.duration_minutes,
        t.tournament_key,
        t.tournament_id,
        t.tournament_name,
        t.game_title,
        t.region,
        t.format,
        t.stage,
        t.venue,
        t.sponsor,
        t.prize_pool_usd,
        t.team_count,
        t.start_date,
        t.end_date
    FROM esports.fact_matchstats f
    LEFT JOIN esports.dim_tournaments t
        ON f.tournament_key = t.tournament_key
    WHERE f.match_date IS NOT NULL
),

tournament_aggregations AS (
/*---------------------------------------------------------------------------
2) Tournament Aggregations: Summarizes key metrics at the tournament level
---------------------------------------------------------------------------*/
    SELECT
        tournament_key,
        tournament_id,
        tournament_name,
        game_title,
        region,
        format,
        stage,
        venue,
        sponsor,
        prize_pool_usd,
        team_count,
        start_date,
        end_date,
        DATEDIFF(day, MIN(match_date), MAX(match_date))     AS lifespan,
        MAX(match_date)                                     AS last_match_date,
        COUNT(DISTINCT match_id)                            AS total_matches,
        COUNT(DISTINCT player_key)                          AS total_players,
        SUM(kills)                                          AS total_kills,
        SUM(damage_dealt)                                   AS total_damage,
        SUM(duration_minutes)                               AS total_duration_minutes,
        AVG(kda_ratio)                                      AS avg_kda,
        AVG(CAST(acs AS FLOAT))                             AS avg_acs,
        ROUND(AVG(CAST(kills AS FLOAT) / NULLIF(duration_minutes, 0)), 2) AS avg_kills_per_minute
    FROM base_query
    GROUP BY
        tournament_key,
        tournament_id,
        tournament_name,
        game_title,
        region,
        format,
        stage,
        venue,
        sponsor,
        prize_pool_usd,
        team_count,
        start_date,
        end_date
)

/*---------------------------------------------------------------------------
3) Final Query: Combines all tournament results into one output
---------------------------------------------------------------------------*/
SELECT
    tournament_key,
    tournament_id,
    tournament_name,
    game_title,
    region,
    format,
    stage,
    venue,
    sponsor,
    prize_pool_usd,
    team_count,
    start_date,
    end_date,
    last_match_date,
    DATEDIFF(month, last_match_date, GETDATE())             AS recency_in_months,
    CASE
        WHEN prize_pool_usd >= 500000   THEN 'Major'
        WHEN prize_pool_usd >= 100000   THEN 'Mid-Tier'
        ELSE                                 'Minor'
    END AS tournament_segment,
    lifespan,
    total_matches,
    total_players,
    total_kills,
    total_damage,
    total_duration_minutes,
    avg_kda,
    avg_acs,
    avg_kills_per_minute,
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
    END AS avg_daily_kills
FROM tournament_aggregations;
GO
