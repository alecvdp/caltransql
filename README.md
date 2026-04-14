# CaltransSQL

A hands-on SQL practice environment using real California transportation data. Uses a remote PostgreSQL server with JetBrains DataGrip as the query editor.

## Prerequisites

- **PostgreSQL server** accessible on your network
- **JetBrains DataGrip** (or any SQL client)
- **psql CLI** for running setup scripts (`brew install libpq` on macOS, then add to PATH)
- **PostGIS extension available on your server** (required for the optional spatial module in `exercises/09-spatial-postgis/`)

## Quick Start

```bash
# 1. Clone and configure
cp .env.example .env
# Edit .env with your server connection details

# 2. Create the database and tables
#    (also attempts to enable PostGIS if available)
./scripts/setup-database.sh

# 3. Download public datasets
./scripts/download-data.sh

# 4. Load data into PostgreSQL
./scripts/load-data.sh

# 5. Validate the loaded data
./scripts/validate-data.sh
```

## Connecting DataGrip

1. Open DataGrip and click **+** > **Data Source** > **PostgreSQL**
2. Fill in the connection settings from your `.env`:
   - **Host:** your server IP
   - **Port:** your server port
   - **Database:** `caltransql`
   - **User:** your username
   - **Password:** your password
3. Click **Test Connection**, then **OK**
4. Open exercise `.sql` files directly in DataGrip and run queries with Ctrl+Enter (Cmd+Enter on Mac)

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

| #   | Topic               | Folder                  | Skill Level        |
|-----|---------------------|-------------------------|--------------------|
| 01  | SELECT basics, ORDER BY, LIMIT | `exercises/01-basics/`  | Beginner |
| 02  | WHERE, LIKE, IN, CASE, NULL handling | `exercises/02-filtering/` | Beginner |
| 03  | GROUP BY, HAVING, conditional aggregation | `exercises/03-aggregations/` | Beginner/Intermediate |
| 04  | JOINs and join grain | `exercises/04-joins/`   | Intermediate |
| 04b | UNION, INTERSECT, EXCEPT, and self-joins | `exercises/04b-set-operations/` | Intermediate |
| 05  | Subqueries, EXISTS, NOT EXISTS | `exercises/05-subqueries/` | Intermediate |
| 06  | Window Functions, running totals, percentiles | `exercises/06-window-functions/` | Intermediate/Advanced |
| 07  | CTEs, recursive CTEs, and multi-step analysis | `exercises/07-ctes/`    | Intermediate/Advanced |
| 08  | Practice Projects   | `exercises/08-practice-projects/` | All levels  |
| 09  | Spatial analysis with PostGIS | `exercises/09-spatial-postgis/` | Advanced |

### Recently Added Exercises

- `exercises/01-basics/02-order-by-limit.sql`
- `exercises/02-filtering/03-case-and-null-handling.sql`
- `exercises/03-aggregations/02-conditional-aggregation.sql`
- `exercises/04-joins/02-join-grain-and-duplicates.sql`
- `exercises/04b-set-operations/01-union-and-set-operations.sql`
- `exercises/04b-set-operations/02-self-joins.sql`
- `exercises/05-subqueries/02-exists-and-not-exists.sql`
- `exercises/06-window-functions/02-running-stats-and-percentiles.sql`
- `exercises/07-ctes/02-multi-step-analysis.sql`
- `exercises/07-ctes/03-recursive.sql`
- `exercises/09-spatial-postgis/01-postgis-spatial-analysis.sql`

### Expanded Practice Projects

- `exercises/08-practice-projects/01-bridge-report-card.sql`
  Broad bridge inventory analysis using the core `bridges` table.
- `exercises/08-practice-projects/02-contractor-performance.sql`
  Contractor scorecards, estimate comparisons, and spend concentration.
- `exercises/08-practice-projects/03-corridor-traffic-safety.sql`
  Corridor-level traffic, truck exposure, and crash pattern analysis.
- `exercises/08-practice-projects/04-inflation-adjusted-costs.sql`
  Adjust historical contract values using the highway construction cost index.

## Hints and Answer Keys

- All exercise and project files in `exercises/` now have companion files in the same folder:
  `*-hints.sql` and `*-answers.sql`
- Use the main `.sql` file first, then open the hint file only if you are stuck.
- The answer key files show one valid approach. They are not the only correct solutions.
- Answer key files include compact `-- Expected output (first 5 rows, illustrative)` comment blocks
  after each query so you can quickly compare result shape and column order.
- The practice project answer files are sample solutions for key deliverables rather than exhaustive solutions to every sub-step.

## Suggested Learning Path

1. Start with `01-basics` and `02-filtering` until writing SELECT/WHERE queries feels automatic.
2. Move into `03-aggregations` and `04-joins` to learn row-level vs grouped thinking.
3. Work through `04b-set-operations` to practice UNION, INTERSECT, EXCEPT, and self-joins.
4. Use `05-subqueries`, `06-window-functions`, and `07-ctes` to solve the same question in multiple ways.
5. After that, pick one practice project and treat it like a mini analysis assignment:
   define the business question, build a clean base dataset, then produce a final summary table.

## How to Use the Projects

- Treat each project file like a guided notebook rather than a quiz.
- Write your solution under each prompt, then rerun and refine it.
- Save especially useful final queries as views so you can build on them later.
- For the more advanced projects, sketch the table grain first so you do not accidentally multiply rows with the wrong join.

## Project Structure

```
caltransql/
├── .env.example                # Connection settings template
├── schemas/                    # Table definitions
│   ├── 00-postgis.sql
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
│   ├── 04b-set-operations/
│   ├── 05-subqueries/
│   ├── 06-window-functions/
│   ├── 07-ctes/
│   ├── 08-practice-projects/
│   └── 09-spatial-postgis/
├── data/                       # Downloaded CSV files (git-ignored)
└── scripts/
    ├── setup-database.sh       # Create database and tables
    ├── download-data.sh        # Fetch public datasets
    ├── load-data.sh            # Load CSVs into PostgreSQL
    ├── validate-data.sh        # Data health check (shell wrapper)
    └── validate-data.sql       # Data health check (SQL queries)
```

## Tips

- **DataGrip:** Open `.sql` files from the `exercises/` folder directly. Highlight a query and press Ctrl+Enter (Cmd+Enter) to run it.
- **Run one query at a time:** Highlight a single statement before executing
- **psql from terminal:** `psql -h $PGHOST -p $PGPORT -U $PGUSER -d $PGDATABASE`
- **Schema explorer:** Use DataGrip's database tree to browse tables, columns, and relationships
