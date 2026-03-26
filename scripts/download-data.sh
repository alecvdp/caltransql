#!/usr/bin/env bash
# ============================================================
# Download publicly available transportation datasets
# ============================================================
# Run this script from the repo root:
#   ./scripts/download-data.sh
#
# Downloads data into the ./data directory.
# The .gitignore excludes large CSV files from git.
#
# Some datasets auto-download; others require a manual step
# (noted with "MANUAL" in the output).
# ============================================================

set -euo pipefail

DATA_DIR="$(cd "$(dirname "$0")/../data" && pwd)"
echo "Downloading data to: $DATA_DIR"
echo ""

download_file() {
    local url="$1"
    local dest="$2"
    local name="$3"

    if [ -f "$dest" ]; then
        echo "  Already downloaded: $(basename "$dest")"
        return 0
    fi

    echo "  Downloading $name..."
    if curl -fL -o "$dest" "$url" 2>/dev/null; then
        echo "  Saved to: $(basename "$dest")"
        return 0
    else
        echo "  WARNING: Download failed. See manual instructions below."
        return 1
    fi
}

# ------------------------------------------------------------
# 1. National Bridge Inventory (NBI) - California
# Source: FHWA
# ~25,000 bridges with 115+ attributes each
# ------------------------------------------------------------
echo "=== 1. National Bridge Inventory (California) ==="
echo "   Source: FHWA - https://www.fhwa.dot.gov/bridge/nbi/ascii.cfm"

NBI_URL="https://www.fhwa.dot.gov/bridge/nbi/2024/delimited/CA24.txt"
download_file "$NBI_URL" "$DATA_DIR/nbi_california.csv" "NBI California data" || {
    echo "  Manual: Visit https://www.fhwa.dot.gov/bridge/nbi/ascii.cfm"
    echo "          Download the latest California file"
    echo "          Save as: $DATA_DIR/nbi_california.csv"
}
echo ""

# ------------------------------------------------------------
# 2. Caltrans State Highway Bridges (data.ca.gov)
# ~13,261 state-owned bridge records
# ------------------------------------------------------------
echo "=== 2. Caltrans State Highway Bridges ==="
echo "   Source: data.ca.gov"
echo "  MANUAL: Visit https://data.ca.gov/dataset/state-highway-bridges"
echo "          Click 'Download' on the CSV file"
echo "          Save as: $DATA_DIR/state_highway_bridges.csv"
echo ""

# ------------------------------------------------------------
# 3. Caltrans Local Bridges (data.ca.gov)
# ~12,601 locally-owned bridge records
# ------------------------------------------------------------
echo "=== 3. Caltrans Local Bridges ==="
echo "   Source: data.ca.gov"
echo "  MANUAL: Visit https://data.ca.gov/dataset/local-bridges"
echo "          Click 'Download' on the CSV file"
echo "          Save as: $DATA_DIR/local_bridges.csv"
echo ""

# ------------------------------------------------------------
# 4. Caltrans Traffic Volumes AADT (data.ca.gov)
# Annual Average Daily Traffic across the highway system
# ------------------------------------------------------------
echo "=== 4. Traffic Volumes AADT ==="
echo "   Source: data.ca.gov"
echo "  MANUAL: Visit https://data.ca.gov/dataset/annual-average-daily-traffic"
echo "          Click 'Download' on the CSV file"
echo "          Save as: $DATA_DIR/traffic_aadt.csv"
echo ""

# ------------------------------------------------------------
# 5. Caltrans Truck Volumes AADT (data.ca.gov)
# Truck traffic with axle-class breakdown
# Relevant for pavement design (EAL data)
# ------------------------------------------------------------
echo "=== 5. Truck Volumes AADT ==="
echo "   Source: data.ca.gov"
echo "  MANUAL: Visit https://gisdata-caltrans.opendata.arcgis.com/datasets/c079bdd6a2c54aec84b6b2f7d6570f6d_0/about"
echo "          Download as CSV"
echo "          Save as: $DATA_DIR/truck_aadt.csv"
echo ""

# ------------------------------------------------------------
# 6. SHOPP Project List (Caltrans SB1)
# State Highway Operation & Protection Program projects
# ~600+ construction projects - bridge rehab, pavement, safety
# ------------------------------------------------------------
echo "=== 6. SHOPP Project List ==="
echo "   Source: Caltrans SB1 Program"
SHOPP_URL="https://dot.ca.gov/-/media/dot-media/programs/sb1/documents/shopp-project-list-excel-file-a11y.xlsx"
download_file "$SHOPP_URL" "$DATA_DIR/shopp_projects.xlsx" "SHOPP project list" || {
    echo "  Manual: Visit https://dot.ca.gov/programs/asset-management/caltrans-project-portal"
    echo "          Download the SHOPP Project List Excel file"
    echo "          Save as: $DATA_DIR/shopp_projects.xlsx"
}
echo "  Note: This is an Excel file. Convert to CSV before loading,"
echo "        or use the Python helper: python3 scripts/convert_excel.py"
echo ""

# ------------------------------------------------------------
# 7. NHCCI - National Highway Construction Cost Index
# Quarterly cost index since 2003 (~90 rows)
# Directly relevant for adjusting historical bid prices
# ------------------------------------------------------------
echo "=== 7. National Highway Construction Cost Index ==="
echo "   Source: FHWA / data.transportation.gov"
echo "  MANUAL: Visit https://data.transportation.gov/Research-and-Statistics/NHCCI/r94d-n4f9"
echo "          Click 'Export' > CSV"
echo "          Save as: $DATA_DIR/nhcci.csv"
echo ""

# ------------------------------------------------------------
# 8. CCRS - California Crash Reporting System (data.ca.gov)
# Replaced SWITRS in Jan 2025. Three linked tables per year.
# WARNING: Large dataset (100K+ records per year)
# ------------------------------------------------------------
echo "=== 8. California Crash Data (CCRS) ==="
echo "   Source: data.ca.gov - https://data.ca.gov/dataset/ccrs"
echo "  MANUAL: Visit the URL above"
echo "          Download Crashes, Parties, and InjuredWitnessPassengers CSVs"
echo "          Save as: $DATA_DIR/ccrs_crashes.csv"
echo "                   $DATA_DIR/ccrs_parties.csv"
echo "                   $DATA_DIR/ccrs_victims.csv"
echo "  Note: Start with one year of data to keep sizes manageable."
echo ""

# ------------------------------------------------------------
# 9. Caltrans Contract Cost Database
# Historical bid prices - web search only, no bulk download
# ------------------------------------------------------------
echo "=== 9. Caltrans Contract Cost Data ==="
echo "   Source: https://sv08data.dot.ca.gov/contractcost/"
echo "  NOTE: This database is web-only (no bulk CSV download)."
echo "        You can search by item code, district, and year."
echo "        For exercises, we include sample data in schemas/."
echo ""

# ------------------------------------------------------------
# 10. Crash Data on State Highway System (data.ca.gov)
# Curated annual summaries - smaller, cleaner dataset
# ------------------------------------------------------------
echo "=== 10. Crash Summaries (State Highway System) ==="
echo "   Source: data.ca.gov"
echo "  MANUAL: Visit https://data.ca.gov/dataset/2023-crash-data-on-state-highway-system"
echo "          Download the CSV files"
echo "          Save to: $DATA_DIR/crash_summary_2023.csv"
echo ""

echo "=========================================="
echo "Download checklist complete!"
echo "=========================================="
echo ""
echo "Minimum viable dataset (start here):"
echo "  [1] NBI California bridges (auto-downloaded if URL works)"
echo "  [6] SHOPP construction projects (auto-downloaded if URL works)"
echo ""
echo "Next steps:"
echo "  1. Set up the database: ./scripts/setup-database.sh"
echo "  2. Load the data:       ./scripts/load-data.sh"
