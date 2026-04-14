#!/usr/bin/env python3
"""
Generate synthetic but realistic Caltrans contract and construction project data.

Produces two CSV files:
  - data/construction_projects.csv  (~300 projects)
  - data/contracts.csv              (~250 contracts)

Statistical distributions are calibrated to resemble real Caltrans
Contract Cost Database patterns (bid-to-estimate ratios, contractor
concentration, bidder counts, cost growth, etc.).

Usage:
    python3 scripts/generate-contract-data.py
"""

import csv
import math
import os
import random
from datetime import date, timedelta

REPO_DIR = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
DATA_DIR = os.path.join(REPO_DIR, "data")

random.seed(42)

# ── California geography ──────────────────────────────────────────

DISTRICTS = {
    "01": {"name": "Eureka",       "counties": ["Del Norte", "Humboldt", "Lake", "Mendocino"],                          "weight": 3},
    "02": {"name": "Redding",      "counties": ["Lassen", "Modoc", "Plumas", "Shasta", "Siskiyou", "Tehama", "Trinity"],"weight": 3},
    "03": {"name": "Marysville",   "counties": ["Butte", "Colusa", "Glenn", "Sutter", "Yuba", "El Dorado", "Nevada", "Placer", "Sacramento", "Sierra", "Yolo"], "weight": 6},
    "04": {"name": "Oakland",      "counties": ["Alameda", "Contra Costa", "Marin", "Napa", "San Francisco", "San Mateo", "Santa Clara", "Solano", "Sonoma"], "weight": 15},
    "05": {"name": "San Luis Obispo", "counties": ["Monterey", "San Benito", "San Luis Obispo", "Santa Barbara", "Santa Cruz"], "weight": 5},
    "06": {"name": "Fresno",       "counties": ["Fresno", "Kern", "Kings", "Madera", "Tulare"],                         "weight": 8},
    "07": {"name": "Los Angeles",  "counties": ["Los Angeles", "Ventura"],                                               "weight": 18},
    "08": {"name": "San Bernardino","counties": ["Riverside", "San Bernardino"],                                          "weight": 10},
    "09": {"name": "Bishop",       "counties": ["Inyo", "Mono"],                                                         "weight": 1},
    "10": {"name": "Stockton",     "counties": ["Alpine", "Amador", "Calaveras", "Mariposa", "Merced", "San Joaquin", "Stanislaus", "Tuolumne"], "weight": 5},
    "11": {"name": "San Diego",    "counties": ["Imperial", "San Diego"],                                                "weight": 10},
    "12": {"name": "Irvine",       "counties": ["Orange"],                                                               "weight": 8},
}

ROUTES = [
    "1", "2", "4", "5", "8", "10", "12", "14", "15", "17", "20", "22",
    "29", "33", "37", "39", "41", "46", "50", "55", "57", "58", "60",
    "65", "70", "71", "76", "78", "80", "84", "87", "91", "92", "99",
    "101", "105", "110", "118", "120", "132", "134", "140", "152", "156",
    "162", "166", "170", "180", "198", "210", "215", "241", "280", "380",
    "405", "505", "580", "605", "680", "710", "780", "805", "880", "980",
]

WORK_TYPES = [
    ("Pavement Rehabilitation",      0.28, (2_000_000, 35_000_000)),
    ("Bridge Repair",                 0.14, (1_500_000, 25_000_000)),
    ("Bridge Replacement",            0.06, (5_000_000, 80_000_000)),
    ("Safety Improvement",            0.12, (500_000,   10_000_000)),
    ("Drainage Improvement",          0.05, (400_000,    6_000_000)),
    ("Roadway Widening",              0.07, (3_000_000, 50_000_000)),
    ("Guardrail Upgrade",             0.04, (200_000,    3_000_000)),
    ("Electrical/Lighting",           0.04, (300_000,    5_000_000)),
    ("Landscaping & Erosion Control", 0.03, (150_000,    2_500_000)),
    ("Seismic Retrofit",              0.05, (2_000_000, 40_000_000)),
    ("ADA Compliance",                0.03, (100_000,    2_000_000)),
    ("Sign Replacement",              0.03, (150_000,    1_500_000)),
    ("Pavement Overlay",              0.06, (800_000,   12_000_000)),
]

CONTRACT_TYPES = [
    "Construction",
    "Emergency",
    "Design-Build",
    "Maintenance",
]

PROGRAMS = [
    "SHOPP",
    "STIP",
    "Bridge Program",
    "Safety Program",
    "Maintenance Program",
    "HSIP",
    "HBP",
]

# ── Realistic contractor pool ─────────────────────────────────────

CONTRACTORS = [
    # (name, city, state, size_tier)  size_tier: large/medium/small
    ("Graniterock Company",              "Watsonville",    "CA", "large"),
    ("Flatiron West Inc",                "San Marcos",     "CA", "large"),
    ("Security Paving Company Inc",      "Sylmar",         "CA", "large"),
    ("Skanska USA Civil West",           "Riverside",      "CA", "large"),
    ("Kiewit Infrastructure West Co",    "Omaha",          "NE", "large"),
    ("Golden State Bridge Inc",          "Benicia",        "CA", "large"),
    ("Tutor Perini Corporation",         "Sylmar",         "CA", "large"),
    ("C C Myers Inc",                    "Rancho Cordova", "CA", "large"),
    ("Griffith Company",                 "Brea",           "CA", "large"),
    ("Shimmick Construction Co Inc",     "Oakland",        "CA", "large"),
    ("OHL USA Inc",                      "Los Angeles",    "CA", "medium"),
    ("Myers & Sons Construction LLC",    "Rancho Cordova", "CA", "medium"),
    ("MCM Construction Inc",             "Riverside",      "CA", "medium"),
    ("Teichert Construction",            "Sacramento",     "CA", "medium"),
    ("DeSilva Gates Construction",       "Dublin",         "CA", "medium"),
    ("Ghilotti Bros Inc",                "San Rafael",     "CA", "medium"),
    ("Bay Cities Paving & Grading Inc",  "Concord",        "CA", "medium"),
    ("R J Noble Company",                "Orange",         "CA", "medium"),
    ("Sully-Miller Contracting Co",      "Brea",           "CA", "medium"),
    ("Dutra Construction",               "San Rafael",     "CA", "medium"),
    ("Sukut Construction LLC",           "Santa Ana",      "CA", "medium"),
    ("All American Asphalt",             "Corona",         "CA", "medium"),
    ("Anrak Corporation",                "Ontario",        "CA", "medium"),
    ("West Coast Bridge Inc",            "Benicia",        "CA", "medium"),
    ("Steve P Rados Inc",                "Santa Maria",    "CA", "medium"),
    ("Papich Construction Company Inc",  "San Luis Obispo","CA", "small"),
    ("Viking Construction Inc",          "Rancho Cordova", "CA", "small"),
    ("Doug Veerkamp General Eng Inc",    "Placerville",    "CA", "small"),
    ("Diablo Contractors Inc",           "Pleasanton",     "CA", "small"),
    ("Ford Construction Company",        "Lodi",           "CA", "small"),
    ("Knife River Construction",         "Red Bluff",      "CA", "small"),
    ("George Reed Inc",                  "Sonora",         "CA", "small"),
    ("Lee's Paving Inc",                 "Riverside",      "CA", "small"),
    ("Mercer Fraser Company",            "Eureka",         "CA", "small"),
    ("Cal-Neva Construction Inc",        "Carson City",    "NV", "small"),
    ("Sierra Mountain Construction Inc", "Colfax",         "CA", "small"),
    ("Interstate Grading & Paving Inc",  "El Cajon",       "CA", "small"),
    ("L H Woods & Sons Inc",             "Fresno",         "CA", "small"),
    ("Lund Construction Company",        "Lodi",           "CA", "small"),
    ("Carr Bros Construction Inc",       "Salinas",        "CA", "small"),
]

# Contractor selection weights: large firms win more contracts
TIER_WEIGHTS = {"large": 5.0, "medium": 3.0, "small": 1.5}


def pick_district():
    districts = list(DISTRICTS.keys())
    weights = [DISTRICTS[d]["weight"] for d in districts]
    return random.choices(districts, weights=weights, k=1)[0]


def pick_work_type():
    names = [w[0] for w in WORK_TYPES]
    weights = [w[1] for w in WORK_TYPES]
    idx = random.choices(range(len(WORK_TYPES)), weights=weights, k=1)[0]
    return WORK_TYPES[idx]


def pick_contractor():
    weights = [TIER_WEIGHTS[c[3]] for c in CONTRACTORS]
    return random.choices(CONTRACTORS, weights=weights, k=1)[0]


def lognormal_in_range(low, high, sigma=0.6):
    mid = math.sqrt(low * high)
    mu = math.log(mid)
    while True:
        val = random.lognormexp(mu, sigma) if hasattr(random, "lognormexp") else math.exp(random.gauss(mu, sigma))
        if low <= val <= high * 1.5:
            return val


def round_to_thousands(val):
    return round(val / 1000) * 1000


def generate_projects(n=300):
    projects = []
    seq_by_dist = {}
    for i in range(n):
        dist = pick_district()
        county = random.choice(DISTRICTS[dist]["counties"])
        route = random.choice(ROUTES)

        seq_by_dist.setdefault(dist, 0)
        seq_by_dist[dist] += 1
        seq = seq_by_dist[dist]
        project_id = f"EA-{dist}A{seq:04d}"

        work_name, _, cost_range = pick_work_type()
        estimate = round_to_thousands(lognormal_in_range(*cost_range))
        total_cost = round_to_thousands(estimate * random.uniform(0.85, 1.25))

        program = random.choice(PROGRAMS)

        base_year = random.randint(2010, 2024)
        base_month = random.randint(1, 12)
        approval_date = date(base_year, base_month, 1)
        start_offset = random.randint(60, 365)
        start_date = approval_date + timedelta(days=start_offset)

        duration_days = random.randint(90, 900)
        completion_date = start_date + timedelta(days=duration_days)

        today = date(2025, 4, 1)
        if completion_date < today:
            status = "completed"
        elif start_date < today:
            status = "active"
        else:
            status = "planned"

        pm_start = round(random.uniform(0.0, 60.0), 3)
        pm_end = round(pm_start + random.uniform(0.1, 5.0), 3)

        ca_lat_min, ca_lat_max = 32.5, 42.0
        ca_lon_min, ca_lon_max = -124.4, -114.1
        lat = round(random.uniform(ca_lat_min, ca_lat_max), 7)
        lon = round(random.uniform(ca_lon_min, ca_lon_max), 7)

        desc_templates = [
            f"Hwy {route} {work_name.lower()} in {county} County",
            f"Route {route} - {work_name.lower()} near PM {pm_start:.1f}",
            f"{work_name} on SR-{route}, {county} County",
            f"{work_name.lower()} improvements, State Route {route}",
        ]

        projects.append({
            "project_id": project_id,
            "district": dist,
            "county": county,
            "route": route,
            "post_mile_start": pm_start,
            "post_mile_end": pm_end,
            "project_description": random.choice(desc_templates),
            "work_type": work_name,
            "program": program,
            "total_cost": total_cost,
            "engineer_estimate": estimate,
            "approval_date": approval_date.isoformat(),
            "start_date": start_date.isoformat(),
            "completion_date": completion_date.isoformat(),
            "status": status,
            "latitude": lat,
            "longitude": lon,
        })

    return projects


def generate_contracts(projects, target=250):
    contracts = []
    used_projects = random.sample(projects, min(target, len(projects)))
    seq_global = 0

    for proj in used_projects:
        seq_global += 1
        dist = proj["district"]
        contract_id = f"{dist}-{200000 + seq_global}"
        contract_number = f"{dist}-{random.randint(100000, 999999)}"

        contractor = pick_contractor()

        estimate = proj["engineer_estimate"]

        # Bid-to-estimate ratio: normally distributed around 0.97 (bids tend slightly below estimate)
        # sigma ~0.12 captures the realistic spread
        bid_ratio = max(0.60, min(1.50, random.gauss(0.97, 0.12)))
        bid_amount = round_to_thousands(estimate * bid_ratio)

        # Final cost: typically 1.0-1.15x of bid (cost growth), occasional overruns
        cost_growth = max(0.95, random.gauss(1.07, 0.08))
        if random.random() < 0.08:
            cost_growth = random.uniform(1.20, 1.45)

        if proj["status"] == "completed":
            final_cost = round_to_thousands(bid_amount * cost_growth)
        elif proj["status"] == "active" and random.random() < 0.3:
            final_cost = round_to_thousands(bid_amount * cost_growth)
        else:
            final_cost = None

        # Number of bidders: realistic distribution (median ~4-5)
        num_bidders = max(1, min(15, int(random.gauss(5, 2))))
        if bid_amount > 20_000_000:
            num_bidders = max(2, min(10, int(random.gauss(4, 1.5))))

        approval = date.fromisoformat(proj["approval_date"])
        award_offset = random.randint(30, 180)
        award_date = approval + timedelta(days=award_offset)

        work_start = award_date + timedelta(days=random.randint(14, 90))
        work_days = random.randint(60, 600)
        work_completion = work_start + timedelta(days=work_days)

        if proj["status"] == "completed":
            acceptance_date = work_completion + timedelta(days=random.randint(14, 90))
        else:
            acceptance_date = None

        ct = "Construction"
        r = random.random()
        if r < 0.03:
            ct = "Emergency"
        elif r < 0.08:
            ct = "Design-Build"
        elif r < 0.12:
            ct = "Maintenance"

        if proj["status"] == "completed":
            status = "accepted"
        elif proj["status"] == "active":
            status = random.choice(["in progress", "pending completion"])
        else:
            status = "awarded"

        contracts.append({
            "contract_id": contract_id,
            "project_id": proj["project_id"],
            "contract_number": contract_number,
            "contractor_name": contractor[0],
            "contractor_city": contractor[1],
            "contractor_state": contractor[2],
            "bid_amount": bid_amount,
            "engineer_estimate": estimate,
            "final_cost": final_cost if final_cost else "",
            "award_date": award_date.isoformat(),
            "work_start_date": work_start.isoformat(),
            "work_completion_date": work_completion.isoformat(),
            "acceptance_date": acceptance_date.isoformat() if acceptance_date else "",
            "num_bidders": num_bidders,
            "num_working_days": work_days,
            "contract_type": ct,
            "status": status,
        })

    return contracts


def write_csv(filepath, rows, fieldnames):
    os.makedirs(os.path.dirname(filepath), exist_ok=True)
    with open(filepath, "w", newline="") as f:
        writer = csv.DictWriter(f, fieldnames=fieldnames)
        writer.writeheader()
        writer.writerows(rows)
    print(f"  Wrote {len(rows)} rows to {os.path.basename(filepath)}")


def print_summary(projects, contracts):
    print("\n  Data summary:")
    print(f"    Projects: {len(projects)}")
    print(f"    Contracts: {len(contracts)}")

    bids = [c["bid_amount"] for c in contracts]
    estimates = [c["engineer_estimate"] for c in contracts]
    ratios = [b / e for b, e in zip(bids, estimates) if e > 0]

    print(f"    Bid range: ${min(bids):,.0f} - ${max(bids):,.0f}")
    print(f"    Median bid: ${sorted(bids)[len(bids)//2]:,.0f}")
    print(f"    Avg bid-to-estimate ratio: {sum(ratios)/len(ratios):.3f}")
    print(f"    Bid-to-estimate range: {min(ratios):.3f} - {max(ratios):.3f}")

    bidders = [c["num_bidders"] for c in contracts]
    print(f"    Avg bidders: {sum(bidders)/len(bidders):.1f}")

    contractors = set(c["contractor_name"] for c in contracts)
    print(f"    Unique contractors: {len(contractors)}")

    statuses = {}
    for c in contracts:
        statuses[c["status"]] = statuses.get(c["status"], 0) + 1
    print(f"    Status distribution: {statuses}")


def main():
    print("=== Generating synthetic Caltrans contract data ===\n")

    projects = generate_projects(300)
    contracts = generate_contracts(projects, 250)

    proj_path = os.path.join(DATA_DIR, "construction_projects.csv")
    cont_path = os.path.join(DATA_DIR, "contracts.csv")

    proj_fields = [
        "project_id", "district", "county", "route", "post_mile_start",
        "post_mile_end", "project_description", "work_type", "program",
        "total_cost", "engineer_estimate", "approval_date", "start_date",
        "completion_date", "status", "latitude", "longitude",
    ]
    cont_fields = [
        "contract_id", "project_id", "contract_number",
        "contractor_name", "contractor_city", "contractor_state",
        "bid_amount", "engineer_estimate", "final_cost",
        "award_date", "work_start_date", "work_completion_date", "acceptance_date",
        "num_bidders", "num_working_days", "contract_type", "status",
    ]

    write_csv(proj_path, projects, proj_fields)
    write_csv(cont_path, contracts, cont_fields)
    print_summary(projects, contracts)

    print("\nNext steps:")
    print("  1. Run: psql ... -f scripts/load-contracts.sql")
    print("  2. Or use: ./scripts/load-data.sh")


if __name__ == "__main__":
    main()
