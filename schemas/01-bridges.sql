-- ============================================================
-- National Bridge Inventory (NBI) - California Bridges
-- Source: FHWA - https://www.fhwa.dot.gov/bridge/nbi.cfm
-- ============================================================
-- The NBI is a comprehensive database of all bridges in the US
-- over 20 feet. This schema covers key fields from the dataset.
-- ============================================================

CREATE TABLE IF NOT EXISTS bridges (
    -- Identification
    structure_number    VARCHAR(20) PRIMARY KEY,
    state_code          VARCHAR(3),
    county              VARCHAR(50),
    district            VARCHAR(5),
    place_code          VARCHAR(10),

    -- Location
    facility_carried    VARCHAR(100),   -- road/route on the bridge
    features_intersected VARCHAR(100),  -- what the bridge crosses
    location_description VARCHAR(100),
    latitude            DECIMAL(10, 7),
    longitude           DECIMAL(10, 7),

    -- Classification
    owner               VARCHAR(50),    -- who owns it (state, county, city, etc.)
    functional_class    VARCHAR(50),    -- type of road (interstate, arterial, etc.)
    highway_system      VARCHAR(20),

    -- Physical characteristics
    year_built          INTEGER,
    year_reconstructed  INTEGER,
    total_length_m      DECIMAL(10, 2), -- total length in meters
    deck_width_m        DECIMAL(8, 2),  -- deck width in meters
    num_spans_main      INTEGER,
    num_spans_approach  INTEGER,
    max_span_length_m   DECIMAL(10, 2),

    -- Materials & design
    deck_structure_type     VARCHAR(50),
    main_structure_type     VARCHAR(50),
    main_material           VARCHAR(50),
    approach_material       VARCHAR(50),

    -- Condition ratings (0-9 scale, 9 = excellent, 0 = failed)
    deck_condition          INTEGER,
    superstructure_condition INTEGER,
    substructure_condition  INTEGER,
    channel_condition       INTEGER,
    culvert_condition       INTEGER,

    -- Appraisal ratings
    structural_evaluation   VARCHAR(5),
    deck_geometry_eval      VARCHAR(5),
    waterway_adequacy       VARCHAR(5),
    approach_alignment      VARCHAR(5),

    -- Traffic
    adt                 INTEGER,        -- average daily traffic
    adt_year            INTEGER,        -- year of traffic count
    truck_adt_pct       DECIMAL(5, 2),  -- truck traffic percentage
    design_load         VARCHAR(20),

    -- Status
    status              VARCHAR(20),
    sufficiency_rating  DECIMAL(5, 2),
    health_index        DECIMAL(5, 2),

    -- Metadata
    last_inspection_date VARCHAR(10),
    data_year           INTEGER         -- year of this NBI record
);

-- Useful indexes
CREATE INDEX IF NOT EXISTS idx_bridges_county ON bridges(county);
CREATE INDEX IF NOT EXISTS idx_bridges_year_built ON bridges(year_built);
CREATE INDEX IF NOT EXISTS idx_bridges_owner ON bridges(owner);
CREATE INDEX IF NOT EXISTS idx_bridges_deck_condition ON bridges(deck_condition);
CREATE INDEX IF NOT EXISTS idx_bridges_county_year ON bridges(county, year_built);
