/*
=============================================================
Create Database and Schemas
=============================================================
Script Purpose:
    This script creates a new database named 'ESportsTournamentDW' after checking
    if it already exists. If the database exists, it is dropped and recreated.
    Additionally, this script creates a schema called 'gold' and loads three
    dimension/fact tables: dim_players, dim_tournaments, and fact_matchstats.

WARNING:
    Running this script will drop the entire 'ESportsTournamentDW' database if it exists.
    All data in the database will be permanently deleted. Proceed with caution
    and ensure you have proper backups before running this script.
=============================================================
*/

USE master;
GO

-- Drop and recreate the 'ESportsTournamentDW' database
IF EXISTS (SELECT 1 FROM sys.databases WHERE name = 'ESportsTournamentDW')
BEGIN
    ALTER DATABASE ESportsTournamentDW SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
    DROP DATABASE ESportsTournamentDW;
END;
GO

-- Create the 'ESportsTournamentDW' database
CREATE DATABASE ESportsTournamentDW;
GO

USE ESportsTournamentDW;
GO

-- Create Schemas
CREATE SCHEMA esports;
GO

/*
=============================================================
Table: esports.dim_players
Description: Player dimension — one row per registered pro player.
Rows: 220
=============================================================
*/
CREATE TABLE esports.dim_players (
    player_key          INT,
    player_id           NVARCHAR(50),
    gamertag            NVARCHAR(100),
    first_name          NVARCHAR(50),
    last_name           NVARCHAR(50),
    country             NVARCHAR(50),
    game_title          NVARCHAR(100),
    role                NVARCHAR(50),
    org_name            NVARCHAR(100),
    region              NVARCHAR(20),
    date_of_birth       DATE,
    joined_date         DATE,
    annual_salary_usd   INT,
    status              NVARCHAR(20)
);
GO

/*
=============================================================
Table: esports.dim_tournaments
Description: Tournament dimension — one row per esports event.
Rows: 210
=============================================================
*/
CREATE TABLE esports.dim_tournaments (
    tournament_key      INT,
    tournament_id       NVARCHAR(50),
    tournament_name     NVARCHAR(200),
    game_title          NVARCHAR(100),
    region              NVARCHAR(20),
    start_date          DATE,
    end_date            DATE,
    prize_pool_usd      INT,
    team_count          TINYINT,
    format              NVARCHAR(50),
    stage               NVARCHAR(50),
    venue               NVARCHAR(100),
    sponsor             NVARCHAR(100)
);
GO

/*
=============================================================
Table: esports.fact_matchstats
Description: Fact table — individual player performance per match.
Rows: 240
=============================================================
*/
CREATE TABLE esports.fact_matchstats (
    stat_key            INT,
    match_id            NVARCHAR(50),
    tournament_key      INT,
    player_key          INT,
    map_played          NVARCHAR(50),
    match_date          DATE,
    kills               TINYINT,
    deaths              TINYINT,
    assists             TINYINT,
    kda_ratio           DECIMAL(5,2),
    damage_dealt        INT,
    headshot_pct        DECIMAL(5,1),
    first_bloods        TINYINT,
    clutches            TINYINT,
    acs                 INT,
    match_outcome       NVARCHAR(10),
    duration_minutes    TINYINT
);
GO

-- =============================================================
-- Load: esports.dim_players
-- =============================================================
TRUNCATE TABLE esports.dim_players;
GO

BULK INSERT esports.dim_players
FROM 'C:\sql\esports-tournament-project\datasets\csv-files\esports.dim_players.csv'
WITH (
    FIRSTROW        = 2,
    FIELDTERMINATOR = ',',
    TABLOCK
);
GO

-- =============================================================
-- Load: esports.dim_tournaments
-- =============================================================
TRUNCATE TABLE esports.dim_tournaments;
GO

BULK INSERT esports.dim_tournaments
FROM 'C:\sql\esports-tournament-project\datasets\csv-files\esports.dim_tournaments.csv'
WITH (
    FIRSTROW        = 2,
    FIELDTERMINATOR = ',',
    TABLOCK
);
GO

-- =============================================================
-- Load: esports.fact_matchstats
-- =============================================================
TRUNCATE TABLE esports.fact_matchstats;
GO

BULK INSERT esports.fact_matchstats
FROM 'C:\sql\esports-tournament-project\datasets\csv-files\esports.fact_matchstats.csv'
WITH (
    FIRSTROW        = 2,
    FIELDTERMINATOR = ',',
    TABLOCK
);
GO
