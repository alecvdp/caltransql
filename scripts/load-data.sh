#!/usr/bin/env bash
# ============================================================
# Load downloaded CSV data into PostgreSQL
# ============================================================
# Prerequisites:
#   1. Database created (./scripts/setup-database.sh)
#   2. Data files downloaded (./scripts/download-data.sh)
#   3. psql CLI installed locally
#
# Usage:
#   ./scripts/load-data.sh
# ============================================================

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
REPO_DIR="$(cd "$SCRIPT_DIR/.." && pwd)"
DATA_DIR="$REPO_DIR/data"

# Load connection settings from .env
if [ -f "$REPO_DIR/.env" ]; then
    set -a
    source "$REPO_DIR/.env"
    set +a
else
    echo "ERROR: .env file not found. Copy .env.example to .env and configure it."
    exit 1
fi

run_sql() {
    psql -h "$PGHOST" -p "$PGPORT" -U "$PGUSER" -d "$PGDATABASE" "$@"
}

echo "=== Loading data into PostgreSQL ==="
echo "Server: $PGHOST:$PGPORT/$PGDATABASE"
echo ""

# Check psql is available
if ! command -v psql &>/dev/null; then
    echo "ERROR: psql not found. Install it with: brew install libpq"
    exit 1
fi

# Check connectivity
if ! run_sql -c "SELECT 1;" &>/dev/null; then
    echo "ERROR: Cannot connect to $PGDATABASE at $PGHOST:$PGPORT"
    echo "Run ./scripts/setup-database.sh first."
    exit 1
fi

# Ensure schemas exist
echo "Creating tables (if needed)..."
for schema_file in "$REPO_DIR"/schemas/*.sql; do
    echo "  Running: $(basename "$schema_file")"
    run_sql -f "$schema_file" 2>&1 | grep -v "^NOTICE:" || true
done
echo ""

# ------------------------------------------------------------
# Load NBI Bridge Data
# ------------------------------------------------------------
NBI_FILE="$DATA_DIR/nbi_california.csv"
if [ -f "$NBI_FILE" ]; then
    echo "Loading NBI bridge data (staging + transform)..."
    # The load-nbi.sql script uses \COPY with a relative path,
    # so we run psql from the repo root
    cd "$REPO_DIR"
    run_sql -f "$REPO_DIR/scripts/load-nbi.sql"
    if [ $? -eq 0 ]; then
        BRIDGE_COUNT=$(run_sql -t -c "SELECT COUNT(*) FROM bridges;" | tr -d ' ')
        echo "  Loaded $BRIDGE_COUNT bridges."
    else
        echo "  Load failed. Check scripts/load-nbi.sql for details."
    fi
else
    echo "Skipping NBI data (file not found: $NBI_FILE)"
    echo "  Run ./scripts/download-data.sh first"
fi


# ------------------------------------------------------------
# Load AADT traffic data
# ------------------------------------------------------------
TRAFFIC_FILE="$DATA_DIR/traffic_aadt.csv"
TRUCK_FILE="$DATA_DIR/truck_aadt.csv"
if [ -f "$TRAFFIC_FILE" ] && [ -f "$TRUCK_FILE" ]; then
    echo "Loading AADT + truck traffic data (staging + transform + upsert)..."
    cd "$REPO_DIR"
    if run_sql -v ON_ERROR_STOP=1 -f "$REPO_DIR/scripts/load-traffic.sql"; then
        TRAFFIC_COUNT=$(run_sql -t -c "SELECT COUNT(*) FROM traffic_counts;" | tr -d ' ')
        TRUCK_COUNT=$(run_sql -t -c "SELECT COUNT(*) FROM truck_traffic;" | tr -d ' ')
        echo "  Loaded traffic_counts=$TRAFFIC_COUNT truck_traffic=$TRUCK_COUNT"
    else
        echo "  Traffic load failed. Check scripts/load-traffic.sql for details."
    fi
else
    echo "Skipping traffic data (missing one or more files):"
    echo "  $TRAFFIC_FILE"
    echo "  $TRUCK_FILE"
    echo "  Run ./scripts/download-data.sh first"
fi

# ------------------------------------------------------------
# Load CCRS crash data
# ------------------------------------------------------------
CCRS_CRASHES_FILE="$DATA_DIR/ccrs_crashes.csv"
CCRS_PARTIES_FILE="$DATA_DIR/ccrs_parties.csv"
CCRS_VICTIMS_FILE="$DATA_DIR/ccrs_victims.csv"
if [ -f "$CCRS_CRASHES_FILE" ] && [ -f "$CCRS_PARTIES_FILE" ] && [ -f "$CCRS_VICTIMS_FILE" ]; then
    echo "Loading CCRS crash data (staging + transform + validation)..."
    cd "$REPO_DIR"
    run_sql -f "$REPO_DIR/scripts/load-ccrs.sql"
    if [ $? -eq 0 ]; then
        CRASH_COUNT=$(run_sql -t -c "SELECT COUNT(*) FROM crashes;" | tr -d ' ')
        PARTY_COUNT=$(run_sql -t -c "SELECT COUNT(*) FROM crash_parties;" | tr -d ' ')
        VICTIM_COUNT=$(run_sql -t -c "SELECT COUNT(*) FROM crash_victims;" | tr -d ' ')
        echo "  Loaded crashes=$CRASH_COUNT parties=$PARTY_COUNT victims=$VICTIM_COUNT"
    else
        echo "  CCRS load failed. Check scripts/load-ccrs.sql for details."
    fi
else
    echo "Skipping CCRS data (missing one or more files):"
    echo "  $CCRS_CRASHES_FILE"
    echo "  $CCRS_PARTIES_FILE"
    echo "  $CCRS_VICTIMS_FILE"
    echo "  Run ./scripts/download-data.sh first"
fi

# ------------------------------------------------------------
# Load construction projects + contracts (synthetic data)
# ------------------------------------------------------------
PROJECTS_FILE="$DATA_DIR/construction_projects.csv"
CONTRACTS_FILE="$DATA_DIR/contracts.csv"
if [ -f "$PROJECTS_FILE" ] && [ -f "$CONTRACTS_FILE" ]; then
    echo "Loading construction projects + contracts..."
    cd "$REPO_DIR"
    if run_sql -v ON_ERROR_STOP=1 -f "$REPO_DIR/scripts/load-contracts.sql"; then
        PROJECT_COUNT=$(run_sql -t -c "SELECT COUNT(*) FROM construction_projects;" | tr -d ' ')
        CONTRACT_COUNT=$(run_sql -t -c "SELECT COUNT(*) FROM contracts;" | tr -d ' ')
        echo "  Loaded construction_projects=$PROJECT_COUNT contracts=$CONTRACT_COUNT"
    else
        echo "  Contract data load failed. Check scripts/load-contracts.sql for details."
    fi
else
    echo "Skipping construction projects + contracts (files not found)."
    echo "  Generate them with: python3 scripts/generate-contract-data.py"
fi

echo ""
echo "=== Data loading complete ==="
echo ""
echo "Connect with DataGrip or psql:"
echo "  psql -h $PGHOST -p $PGPORT -U $PGUSER -d $PGDATABASE"
