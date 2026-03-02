# CaltransSQL

A hands-on SQL practice environment using real California transportation data. Built around PostgreSQL with pgAdmin and NocoDB for exploring data visually.

## Quick Start

```bash
# 1. Clone and configure
cp .env.example .env
# Edit .env to set your passwords

# 2. Start the database stack
docker compose up -d

# 3. Download public datasets
./scripts/download-data.sh

# 4. Load data into PostgreSQL
./scripts/load-data.sh
```

## Services

| Service  | URL                    | Description              |
|----------|------------------------|--------------------------|
| pgAdmin  | http://localhost:8080   | SQL query editor & admin |
| NocoDB   | http://localhost:8090   | Spreadsheet-style DB UI  |
| Postgres | localhost:5432         | Direct database access   |

### Connecting pgAdmin to the database

1. Open http://localhost:8080
2. Log in with your `PGADMIN_EMAIL` / `PGADMIN_PASSWORD`
3. Add a new server:
   - **Name:** CaltransSQL
   - **Host:** `postgres` (the Docker service name)
   - **Port:** `5432`
   - **Username:** `caltrans`
   - **Password:** your `POSTGRES_PASSWORD`

## Datasets

### National Bridge Inventory (NBI)
- **Source:** [FHWA](https://www.fhwa.dot.gov/bridge/nbi/ascii.cfm)
- **What:** Every bridge in California (25,000+) with condition ratings, age, dimensions, traffic, materials, and more
- **Table:** `bridges`
- **Great for:** Filtering, aggregations, window functions, condition analysis

### Construction Projects
- **Source:** [Caltrans Construction](https://dot.ca.gov/programs/construction)
- **What:** Highway construction and improvement projects with costs, schedules, and locations
- **Table:** `construction_projects`
- **Great for:** JOINs with bridges, cost analysis, project tracking

### Contract & Bid Data
- **Source:** [Caltrans Contract Cost Data](https://dot.ca.gov/programs/construction/contract-cost-data)
- **What:** Contract awards including contractor info, bid amounts, engineer estimates
- **Table:** `contracts`
- **Great for:** JOINs, financial analysis, bid vs estimate comparisons

### Traffic Counts
- **Source:** [Caltrans Traffic Census](https://dot.ca.gov/programs/traffic-operations/census)
- **What:** Annual Average Daily Traffic (AADT) at stations across the highway system
- **Table:** `traffic_counts`
- **Great for:** Time series, route analysis, truck traffic patterns

## Exercises

Work through the exercises in order. Each file has examples to study, then questions to solve on your own.

| #  | Topic               | Folder                  | Skill Level        |
|----|---------------------|-------------------------|--------------------|
| 01 | SELECT basics       | `exercises/01-basics/`  | Beginner           |
| 02 | WHERE, LIKE, IN     | `exercises/02-filtering/` | Beginner         |
| 03 | GROUP BY, HAVING    | `exercises/03-aggregations/` | Beginner/Intermediate |
| 04 | JOINs               | `exercises/04-joins/`   | Intermediate       |
| 05 | Subqueries          | `exercises/05-subqueries/` | Intermediate    |
| 06 | Window Functions    | `exercises/06-window-functions/` | Intermediate/Advanced |
| 07 | CTEs                | `exercises/07-ctes/`    | Intermediate/Advanced |
| 08 | Practice Projects   | `exercises/08-practice-projects/` | All levels  |

## Project Structure

```
caltransql/
├── docker-compose.yml          # PostgreSQL + pgAdmin + NocoDB
├── .env.example                # Environment variable template
├── schemas/                    # Table definitions (auto-run on first start)
│   ├── 01-bridges.sql
│   ├── 02-construction-projects.sql
│   ├── 03-contracts.sql
│   └── 04-traffic-counts.sql
├── exercises/                  # SQL practice files
│   ├── 01-basics/
│   ├── 02-filtering/
│   ├── 03-aggregations/
│   ├── 04-joins/
│   ├── 05-subqueries/
│   ├── 06-window-functions/
│   ├── 07-ctes/
│   └── 08-practice-projects/
├── data/                       # Downloaded CSV files (git-ignored)
└── scripts/                    # Data download & loading scripts
    ├── download-data.sh
    └── load-data.sh
```

## Tips

- **pgAdmin query tool:** Right-click your database > Query Tool to open a SQL editor
- **Run one query at a time:** Highlight a single query and press F5
- **NocoDB** is great for browsing data visually before writing queries
- **psql from terminal:** `docker exec -it caltransql-postgres psql -U caltrans -d caltransql`
