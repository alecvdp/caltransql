#!/usr/bin/env bash
# ============================================================
# One-time database setup
# ============================================================
# Creates the caltransql database and runs all schema files.
#
# Prerequisites:
#   - PostgreSQL server accessible at PGHOST:PGPORT
#   - psql CLI installed locally
#   - .env file configured (copy from .env.example)
#
# Usage:
#   ./scripts/setup-database.sh
# ============================================================

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
REPO_DIR="$(cd "$SCRIPT_DIR/.." && pwd)"

# Load connection settings from .env
if [ -f "$REPO_DIR/.env" ]; then
    set -a
    source "$REPO_DIR/.env"
    set +a
else
    echo "ERROR: .env file not found. Copy .env.example to .env and configure it."
    exit 1
fi

# Maintenance database used for admin commands such as CREATE DATABASE.
# Can be overridden in .env with PGMAINTENANCE_DB.
if [ -n "${PGMAINTENANCE_DB:-}" ]; then
    MAINTENANCE_DB="$PGMAINTENANCE_DB"
else
    MAINTENANCE_DB=""
    for candidate_db in postgres personal template1; do
        if psql -h "$PGHOST" -p "$PGPORT" -U "$PGUSER" -d "$candidate_db" -c "SELECT 1;" &>/dev/null; then
            MAINTENANCE_DB="$candidate_db"
            break
        fi
    done
fi

if [ -z "$MAINTENANCE_DB" ]; then
    echo "ERROR: Cannot connect to any maintenance database (tried: postgres, personal, template1)."
    echo "Set PGMAINTENANCE_DB in .env if your server uses a different admin database."
    exit 1
fi

echo "=== CaltransSQL Database Setup ==="
echo "Server: $PGHOST:$PGPORT"
echo "Maintenance DB: $MAINTENANCE_DB"
echo ""

# Check psql is available
if ! command -v psql &>/dev/null; then
    echo "ERROR: psql not found. Install it with: brew install libpq"
    exit 1
fi

# Check connectivity (connect to the existing maintenance database to run admin commands)
if ! psql -h "$PGHOST" -p "$PGPORT" -U "$PGUSER" -d "$MAINTENANCE_DB" -c "SELECT 1;" &>/dev/null; then
    echo "ERROR: Cannot connect to PostgreSQL at $PGHOST:$PGPORT"
    echo "Check your .env settings and that the server is running."
    exit 1
fi

# Create the caltransql database if it doesn't exist
echo "Creating database '$PGDATABASE' (if it doesn't exist)..."
DB_EXISTS=$(psql -h "$PGHOST" -p "$PGPORT" -U "$PGUSER" -d "$MAINTENANCE_DB" \
    -v ON_ERROR_STOP=1 -v target_db="$PGDATABASE" -tAc \
    "SELECT 1 FROM pg_database WHERE datname = :'target_db';")

if [ "$DB_EXISTS" != "1" ]; then
    psql -h "$PGHOST" -p "$PGPORT" -U "$PGUSER" -d "$MAINTENANCE_DB" \
        -v ON_ERROR_STOP=1 -v target_db="$PGDATABASE" -c \
        "SELECT format('CREATE DATABASE %I', :'target_db') \gexec"
fi

echo "Database '$PGDATABASE' ready."
echo ""

# Run schema files in order
echo "Creating tables..."
for schema_file in "$REPO_DIR"/schemas/*.sql; do
    echo "  Running: $(basename "$schema_file")"
    psql -h "$PGHOST" -p "$PGPORT" -U "$PGUSER" -d "$PGDATABASE" -f "$schema_file" 2>&1 | \
        grep -v "^NOTICE:" || true
done

echo ""
echo "=== Setup complete ==="
echo ""
echo "Connect with:"
echo "  psql -h $PGHOST -p $PGPORT -U $PGUSER -d $PGDATABASE"
echo "  Or use DataGrip: Host=$PGHOST, Port=$PGPORT, Database=$PGDATABASE, User=$PGUSER"
