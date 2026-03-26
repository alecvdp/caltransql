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

echo ""
echo "=== Data loading complete ==="
echo ""
echo "Connect with DataGrip or psql:"
echo "  psql -h $PGHOST -p $PGPORT -U $PGUSER -d $PGDATABASE"
