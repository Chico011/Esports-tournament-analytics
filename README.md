# 🎮 Esports Tournament Analytics

> An end-to-end SQL analytics project built on a custom esports data warehouse — exploring player performance, tournament trends, and competitive insights across multiple game titles.

---

## 📌 Project Overview

This project simulates a real-world data analytics workflow applied to the esports industry. Using a star schema data warehouse built in SQL Server, it covers the full analytics lifecycle — from raw data exploration all the way through to structured performance reports.

The goal is to extract meaningful insights from esports match data, including player KDA trends, tournament prize pool distribution, regional competitiveness, and year-over-year performance shifts.

---

## 🗂️ Database Schema

```
ESportsTournamentDW
 [esports]
   > dim_players       — Player profiles, roles, orgs, salaries
   > dim_tournaments   — Tournament details, formats, prize pools
   > fact_matchstats   — Match-level performance stats per player
```

**Relationships:**
```
dim_players ──────────┐
                       ├──► fact_matchstats
dim_tournaments ───────┘
```

---

## 📁 Repository Structure

```
esports-tournament-analytics/
 [datasets]
   [csv-files]
     > esports.dim_players.csv
     > esports.dim_tournaments.csv
     > esports.fact_matchstats.csv
 [scripts]
     > 00_init_database.sql
     > 01_database_exploration.sql
     > 02_dimensions_exploration.sql
     > 03_date_range_exploration.sql
     > 04_measures_exploration.sql
     > 05_core_metrics_analysis.sql
     > 06_ranking_analysis.sql
     > 07_change_over_time_analysis.sql
     > 08_cumulative_analysis.sql
     > 09_performance_analysis.sql
     > 10_data_segmentation.sql
     > 11_part_to_whole_analysis.sql
     > 12_report_players.sql
     > 13_report_tournaments.sql
 > LICENSE
 > README.md
```

---

## 📊 What Each Script Does

| # | Script | Description |
|---|--------|-------------|
| 00 | `init_database` | Creates the database, schema, tables and loads CSV data |
| 01 | `database_exploration` | Explores table structures and column details |
| 02 | `dimensions_exploration` | Examines distinct values across dimension tables |
| 03 | `date_range_exploration` | Identifies time spans across matches, tournaments and players |
| 04 | `measures_exploration` | Analyses distribution across players, regions and game titles |
| 05 | `core_metrics_analysis` | Computes key summary KPIs across the full dataset |
| 06 | `ranking_analysis` | Ranks players and tournaments by performance indicators |
| 07 | `change_over_time_analysis` | Tracks metric trends across months and years |
| 08 | `cumulative_analysis` | Calculates running totals and moving averages over time |
| 09 | `performance_analysis` | Year-over-year benchmarking using LAG and window functions |
| 10 | `data_segmentation` | Classifies players and tournaments into meaningful tiers |
| 11 | `part_to_whole_analysis` | Measures each segment's percentage contribution to totals |
| 12 | `report_players` | Full player performance report view with KPIs and segments |
| 13 | `report_tournaments` | Full tournament summary report view with KPIs and segments |

---

## 🛠️ Tools & Technologies

| Tool | Purpose |
|------|---------|
| SQL Server (SSMS) | Database engine and query execution |
| T-SQL | All data transformation and analysis |
| CSV Files | Raw data source for bulk loading |
| GitHub | Version control and project showcase |

---

## 💡 Key Analytical Techniques Used

- ⚙️ **Window Functions** — `RANK()`, `LAG()`, `SUM() OVER()`, `AVG() OVER()`
- 🧠 **CTEs** — Multi-step logic using `WITH` clauses
- 📅 **Date Intelligence** — `DATETRUNC()`, `DATEDIFF()`, `FORMAT()`
- 🔀 **Segmentation** — Custom `CASE` logic for player and tournament tiers
- 📐 **Part-to-Whole** — Percentage contribution analysis
- 📈 **Year-over-Year** — Growth and decline tracking with `LAG()`
- 🏗️ **Star Schema** — Fact and dimension table design

---

## 🌟 About Me

Hi there! I'm **Collins Odoh**, a Computer and Information Systems student from BYU–Pathway Worldwide with a background in cybersecurity and an interest in data analytics. I use SQL and other data tools to work with data in a clear and structured way. I am currently developing my skills to apply data analytics to real-world problems and support better decision-making.

📎 [LinkedIn](https://www.linkedin.com/in/collins-odoh-97b497382) — feel free to connect!

---

## 🛡️ License

This project is licensed under the MIT License. You are free to use, modify, and share it with proper attribution.

---

*Built with curiosity, structure, and a love for the game. 🎮*
