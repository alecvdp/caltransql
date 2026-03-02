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

### Core Tables (start here)

#### National Bridge Inventory (NBI)
- **Source:** [FHWA](https://www.fhwa.dot.gov/bridge/nbi/ascii.cfm)
- **What:** Every bridge in California (25,000+) with 115+ attributes - condition ratings, age, dimensions, traffic, materials, owner, and more
- **Table:** `bridges`
- **Size:** ~25,000 rows
- **Great for:** Filtering, aggregations, window functions, condition analysis

#### Construction Projects (SHOPP)
- **Source:** [Caltrans SB1 Program](https://dot.ca.gov/programs/asset-management/caltrans-project-portal)
- **What:** State Highway Operation & Protection Program projects - bridge rehab, pavement, safety improvements
- **Table:** `construction_projects`
- **Size:** ~600+ projects
- **Great for:** JOINs with bridges, cost analysis, project tracking

#### Contract & Bid Data
- **Source:** [Caltrans Contract Cost Data](https://sv08data.dot.ca.gov/contractcost/)
- **What:** Contract awards including contractor info, bid amounts, engineer estimates
- **Table:** `contracts`
- **Note:** Web search tool only (no bulk CSV). Sample data provided for exercises.
- **Great for:** JOINs, financial analysis, bid vs estimate comparisons

#### Traffic Counts (AADT)
- **Source:** [data.ca.gov](https://data.ca.gov/dataset/annual-average-daily-traffic)
- **What:** Annual Average Daily Traffic at stations across the highway system
- **Table:** `traffic_counts`
- **Size:** ~5,000-15,000 stations
- **Great for:** Time series, route analysis, aggregations

### Extended Tables (add when ready for more)

#### Truck Traffic (AADT)
- **Source:** [Caltrans GIS Open Data](https://gisdata-caltrans.opendata.arcgis.com/)
- **What:** Truck traffic with axle-class breakdown (2-axle through 5+ axle) and Equivalent Axle Load (EAL) data used in pavement thickness design
- **Table:** `truck_traffic`
- **Great for:** JOINs with traffic_counts, percentage calculations, CASE statements

#### Crash Data (CCRS)
- **Source:** [data.ca.gov](https://data.ca.gov/dataset/ccrs)
- **What:** California Crash Reporting System (replaced SWITRS in 2025). Three linked tables: crashes, parties, victims
- **Tables:** `crashes`, `crash_parties`, `crash_victims`
- **Size:** 100K+ records per year
- **Great for:** Multi-table JOINs (3-table hierarchy), filtering, aggregations

#### Construction Cost Index (NHCCI)
- **Source:** [FHWA / data.transportation.gov](https://data.transportation.gov/Research-and-Statistics/NHCCI/r94d-n4f9)
- **What:** Quarterly highway construction cost index since 2003. Used to adjust historical bid prices to current dollars.
- **Table:** `construction_cost_index`
- **Size:** ~90 rows
- **Great for:** Time series, window functions (LAG/LEAD), percent change calculations

### Other Data Sources Worth Exploring

| Dataset | Source | Notes |
|---------|--------|-------|
| State Highway Bridges | [data.ca.gov](https://data.ca.gov/dataset/state-highway-bridges) | Caltrans-specific bridge view (~13K records), complements NBI |
| Local Bridges | [data.ca.gov](https://data.ca.gov/dataset/local-bridges) | City/county bridges (~12.6K records), UNION with state bridges |
| PeMS Traffic | [pems.dot.ca.gov](https://pems.dot.ca.gov/) | Real-time + historical from 39K detectors. Requires free account |
| Crash Summaries (SHS) | [data.ca.gov](https://data.ca.gov/dataset/2023-crash-data-on-state-highway-system) | Curated annual summaries, small and clean |
| HPMS | [FHWA](https://www.fhwa.dot.gov/policyinformation/hpms/shapefiles.cfm) | Highway performance data with pavement condition (IRI) |
| LTPP | [infopave.fhwa.dot.gov](https://infopave.fhwa.dot.gov/) | Pavement performance data - highly relevant to construction engineering |
| Freight (FAF) | [bts.gov/faf](https://www.bts.gov/faf) | Freight flows by origin/destination/commodity/mode |
| Bottlenecks | [data.ca.gov](https://data.ca.gov/dataset/bottlenecks) | Freeway congestion bottleneck locations |
| Named Highways | [data.ca.gov](https://data.ca.gov/organization/caltrans) | Named freeways, highways, and structures in CA |

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
│   ├── 04-traffic-counts.sql
│   ├── 05-truck-traffic.sql
│   ├── 06-crash-data.sql
│   └── 07-construction-cost-index.sql
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
