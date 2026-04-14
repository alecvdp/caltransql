-- ============================================================
-- PostGIS extension bootstrap (optional but recommended)
-- ============================================================
-- This script tries to enable PostGIS so spatial/GIS exercises
-- can use ST_DWithin, ST_Distance, clustering, and spatial joins.
--
-- If PostGIS is not installed on the PostgreSQL server, or if the
-- current user cannot CREATE EXTENSION, setup will continue and
-- print a warning instead of hard failing.
-- ============================================================

DO $$
BEGIN
    IF EXISTS (
        SELECT 1
        FROM pg_available_extensions
        WHERE name = 'postgis'
    ) THEN
        BEGIN
            CREATE EXTENSION IF NOT EXISTS postgis;
            RAISE NOTICE 'PostGIS extension is enabled for this database.';
        EXCEPTION
            WHEN insufficient_privilege THEN
                RAISE WARNING 'PostGIS is available but could not be enabled: insufficient privilege for CREATE EXTENSION.';
                RAISE WARNING 'Ask your database admin to run: CREATE EXTENSION postgis;';
        END;
    ELSE
        RAISE WARNING 'PostGIS extension is not installed on this PostgreSQL server.';
        RAISE WARNING 'Install PostGIS packages on the server to use spatial exercises.';
    END IF;
END
$$;
