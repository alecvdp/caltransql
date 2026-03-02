#!/usr/bin/env bash
# ============================================================
# Load downloaded CSV data into PostgreSQL
# ============================================================
# Prerequisites:
#   1. Docker containers running (docker compose up -d)
#   2. Data files downloaded (./scripts/download-data.sh)
#
# Usage:
#   ./scripts/load-data.sh
# ============================================================

set -euo pipefail

# Database connection (matches docker-compose.yml defaults)
DB_CONTAINER="caltransql-postgres"
DB_NAME="caltransql"
DB_USER="caltrans"

DATA_DIR="$(cd "$(dirname "$0")/../data" && pwd)"

run_sql() {
    docker exec -i "$DB_CONTAINER" psql -U "$DB_USER" -d "$DB_NAME" "$@"
}

run_sql_file() {
    docker exec -i "$DB_CONTAINER" psql -U "$DB_USER" -d "$DB_NAME" -f "$1"
}

echo "=== Loading data into PostgreSQL ==="
echo ""

# Check if container is running
if ! docker ps --format '{{.Names}}' | grep -q "$DB_CONTAINER"; then
    echo "ERROR: Container '$DB_CONTAINER' is not running."
    echo "Start it with: docker compose up -d"
    exit 1
fi

# Create schemas (idempotent - uses IF NOT EXISTS)
echo "Creating tables..."
for schema_file in /docker-entrypoint-initdb.d/*.sql; do
    echo "  Running: $(basename "$schema_file")"
    run_sql < "/home/user/caltransql/schemas/$(basename "$schema_file")" 2>/dev/null || true
done

# Wait for schemas to be created
echo ""

# ------------------------------------------------------------
# Load NBI Bridge Data
# ------------------------------------------------------------
NBI_FILE="$DATA_DIR/nbi_california.csv"
if [ -f "$NBI_FILE" ]; then
    echo "Loading NBI bridge data..."
    # NBI data is pipe-delimited or comma-delimited depending on year
    # We'll use a Python helper for flexible parsing
    echo "  Note: NBI data format varies by year."
    echo "  If auto-loading fails, use the Python loader:"
    echo "    python3 scripts/load_nbi.py"

    # Try simple COPY (works for comma-delimited files with headers)
    docker cp "$NBI_FILE" "$DB_CONTAINER:/tmp/nbi_data.csv"
    run_sql <<'SQL'
        -- Truncate to allow re-runs
        TRUNCATE TABLE bridges;

        -- Try loading (adjust delimiter if needed)
        \COPY bridges FROM '/tmp/nbi_data.csv' WITH (FORMAT csv, HEADER true, NULL '');
SQL
    if [ $? -eq 0 ]; then
        BRIDGE_COUNT=$(run_sql -t -c "SELECT COUNT(*) FROM bridges;" | tr -d ' ')
        echo "  Loaded $BRIDGE_COUNT bridges."
    else
        echo "  Auto-load failed. Try the Python loader or adjust the format."
    fi
else
    echo "Skipping NBI data (file not found: $NBI_FILE)"
    echo "  Run ./scripts/download-data.sh first"
fi

echo ""
echo "=== Data loading complete ==="
echo ""
echo "Connect to the database:"
echo "  pgAdmin: http://localhost:8080"
echo "  NocoDB:  http://localhost:8090"
echo "  psql:    docker exec -it $DB_CONTAINER psql -U $DB_USER -d $DB_NAME"
