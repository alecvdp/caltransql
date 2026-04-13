#!/usr/bin/env bash
# ============================================================
# Data Validation / Health Check
# ============================================================
# Runs validate-data.sql against the database and prints a
# colour-coded summary showing which checks passed, warned,
# or failed.
#
# Prerequisites:
#   - Database created and data loaded (setup-database.sh + load-data.sh)
#   - psql CLI installed
#   - .env file configured
#
# Usage:
#   ./scripts/validate-data.sh
#
# Exit codes:
#   0 — all checks passed (PASS/WARN/INFO only)
#   1 — one or more checks FAILed
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

# Check psql is available
if ! command -v psql &>/dev/null; then
    echo "ERROR: psql not found. Install it with: brew install libpq"
    exit 1
fi

# Check connectivity
if ! psql -h "$PGHOST" -p "$PGPORT" -U "$PGUSER" -d "$PGDATABASE" -c "SELECT 1;" &>/dev/null; then
    echo "ERROR: Cannot connect to $PGDATABASE at $PGHOST:$PGPORT"
    echo "Run ./scripts/setup-database.sh first."
    exit 1
fi

# Colours (disabled when stdout is not a terminal)
if [ -t 1 ]; then
    GREEN='\033[0;32m'
    YELLOW='\033[0;33m'
    RED='\033[0;31m'
    CYAN='\033[0;36m'
    BOLD='\033[1m'
    RESET='\033[0m'
else
    GREEN='' YELLOW='' RED='' CYAN='' BOLD='' RESET=''
fi

echo ""
echo -e "${BOLD}=== CaltransSQL Data Validation ===${RESET}"
echo "Server: $PGHOST:$PGPORT/$PGDATABASE"
echo ""

# Run the SQL and capture output
OUTPUT=$(psql -h "$PGHOST" -p "$PGPORT" -U "$PGUSER" -d "$PGDATABASE" \
    -f "$SCRIPT_DIR/validate-data.sql" 2>&1)

# Counters
PASS_COUNT=0
WARN_COUNT=0
FAIL_COUNT=0
TOTAL=0

# Parse pipe-delimited output: check_name|status|message
while IFS='|' read -r check_name status message; do
    # Skip blank lines and psql noise
    [ -z "$check_name" ] && continue
    check_name=$(echo "$check_name" | xargs)
    status=$(echo "$status" | xargs)
    message=$(echo "$message" | xargs)

    case "$status" in
        PASS)
            symbol="${GREEN}PASS${RESET}"
            PASS_COUNT=$((PASS_COUNT + 1))
            ;;
        WARN)
            symbol="${YELLOW}WARN${RESET}"
            WARN_COUNT=$((WARN_COUNT + 1))
            ;;
        FAIL)
            symbol="${RED}FAIL${RESET}"
            FAIL_COUNT=$((FAIL_COUNT + 1))
            ;;
        INFO)
            symbol="${CYAN}INFO${RESET}"
            ;;
        *)
            continue
            ;;
    esac

    TOTAL=$((TOTAL + 1))
    printf "  [%b]  %-40s %s\n" "$symbol" "$check_name" "$message"

done <<< "$OUTPUT"

# Summary
echo ""
echo -e "${BOLD}--- Summary ---${RESET}"
printf "  ${GREEN}PASS: %d${RESET}  ${YELLOW}WARN: %d${RESET}  ${RED}FAIL: %d${RESET}  Total: %d\n" \
    "$PASS_COUNT" "$WARN_COUNT" "$FAIL_COUNT" "$TOTAL"
echo ""

if [ "$FAIL_COUNT" -gt 0 ]; then
    echo -e "${RED}Some checks FAILED. Review the output above.${RESET}"
    exit 1
elif [ "$WARN_COUNT" -gt 0 ]; then
    echo -e "${YELLOW}All critical checks passed, but there are warnings.${RESET}"
    exit 0
else
    echo -e "${GREEN}All checks passed.${RESET}"
    exit 0
fi
