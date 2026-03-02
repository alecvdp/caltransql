#!/usr/bin/env bash
# ============================================================
# Download publicly available transportation datasets
# ============================================================
# Run this script from the repo root:
#   ./scripts/download-data.sh
#
# Downloads data into the ./data directory.
# The .gitignore excludes large CSV files from git.
# ============================================================

set -euo pipefail

DATA_DIR="$(cd "$(dirname "$0")/../data" && pwd)"
echo "Downloading data to: $DATA_DIR"
echo ""

# ------------------------------------------------------------
# 1. National Bridge Inventory (NBI) - California
# Source: FHWA
# https://www.fhwa.dot.gov/bridge/nbi/ascii.cfm
# ------------------------------------------------------------
echo "=== National Bridge Inventory (California) ==="

NBI_URL="https://www.fhwa.dot.gov/bridge/nbi/2024/delimited/CA24.txt"
NBI_FILE="$DATA_DIR/nbi_california.csv"

if [ -f "$NBI_FILE" ]; then
    echo "  Already downloaded: $NBI_FILE"
else
    echo "  Downloading NBI data..."
    echo "  Note: If this URL is outdated, visit https://www.fhwa.dot.gov/bridge/nbi/ascii.cfm"
    echo "        and download the latest California file manually."
    curl -L -o "$NBI_FILE" "$NBI_URL" 2>/dev/null || {
        echo "  WARNING: Download failed. The FHWA may have updated their URL format."
        echo "  Visit https://www.fhwa.dot.gov/bridge/nbi/ascii.cfm to download manually."
        echo "  Save the California file as: $NBI_FILE"
    }
fi
echo ""

# ------------------------------------------------------------
# 2. Caltrans Traffic Counts (AADT)
# Source: Caltrans - Traffic Census Program
# https://dot.ca.gov/programs/traffic-operations/census
# ------------------------------------------------------------
echo "=== Caltrans Traffic Counts ==="
echo "  Traffic count data requires manual download:"
echo "  1. Visit: https://dot.ca.gov/programs/traffic-operations/census"
echo "  2. Download the AADT data files"
echo "  3. Save to: $DATA_DIR/traffic_counts.csv"
echo ""

# ------------------------------------------------------------
# 3. Caltrans Contract Cost Data
# Source: Caltrans Division of Construction
# https://dot.ca.gov/programs/construction/contract-cost-data
# ------------------------------------------------------------
echo "=== Caltrans Contract Cost Data ==="
echo "  Contract data requires manual download:"
echo "  1. Visit: https://dot.ca.gov/programs/construction"
echo "  2. Look for Contract Cost Data or Awards"
echo "  3. Save to: $DATA_DIR/contracts.csv"
echo ""

# ------------------------------------------------------------
# 4. California Open Data Portal
# Source: data.ca.gov
# ------------------------------------------------------------
echo "=== California Open Data Portal ==="
echo "  Additional datasets available at: https://data.ca.gov"
echo "  Search for: transportation, highway, bridge, Caltrans"
echo ""

echo "=== Download complete ==="
echo ""
echo "Next steps:"
echo "  1. Start the database:  docker compose up -d"
echo "  2. Load the data:       ./scripts/load-data.sh"
