-- ============================================================
-- NYC 311 Operations & SLA Analysis
-- 02_data_cleaning.sql
-- ============================================================


-- ============================================================
-- 1. CREATE CLEANED ANALYSIS TABLE
-- ============================================================

DROP TABLE IF EXISTS nyc_311_cleaned;

CREATE TABLE nyc_311_cleaned AS
SELECT
    unique_key,

    -- Convert text dates to timestamps
    TO_TIMESTAMP(
        created_date,
        'MM/DD/YYYY HH12:MI:SS AM'
    )::timestamp AS created_at,

    TO_TIMESTAMP(
        closed_date,
        'MM/DD/YYYY HH12:MI:SS AM'
    )::timestamp AS closed_at,

    TO_TIMESTAMP(
        due_date,
        'MM/DD/YYYY HH12:MI:SS AM'
    )::timestamp AS due_at,

    agency,
    agency_name,
    problem,
    problem_detail,
    additional_details,
    location_type,
    incident_zip,
    city,
    status,
    resolution_description,
    community_board,
    council_district,
    police_precinct,
    borough,
    open_data_channel_type,
    latitude,
    longitude,

    -- Calculate valid resolution time
    CASE
        WHEN closed_date IS NOT NULL
             AND TO_TIMESTAMP(
                 closed_date,
                 'MM/DD/YYYY HH12:MI:SS AM'
             ) >= TO_TIMESTAMP(
                 created_date,
                 'MM/DD/YYYY HH12:MI:SS AM'
             )
        THEN
            EXTRACT(
                EPOCH FROM (
                    TO_TIMESTAMP(
                        closed_date,
                        'MM/DD/YYYY HH12:MI:SS AM'
                    )
                    -
                    TO_TIMESTAMP(
                        created_date,
                        'MM/DD/YYYY HH12:MI:SS AM'
                    )
                )
            ) / 3600.0

        ELSE NULL
    END AS resolution_hours

FROM nyc_311_raw;


-- ============================================================
-- 2. VALIDATE CLEANED DATA
-- ============================================================

SELECT
    COUNT(*) AS total_rows,

    COUNT(*) FILTER (
        WHERE created_at IS NULL
    ) AS missing_created_at,

    COUNT(*) FILTER (
        WHERE closed_at IS NULL
    ) AS missing_closed_at,

    COUNT(*) FILTER (
        WHERE resolution_hours IS NULL
    ) AS missing_resolution_hours,

    COUNT(*) FILTER (
        WHERE resolution_hours < 0
    ) AS negative_resolution_hours,

    COUNT(*) FILTER (
        WHERE resolution_hours = 0
    ) AS zero_resolution_hours,

    COUNT(*) FILTER (
        WHERE resolution_hours > 0
    ) AS positive_resolution_hours

FROM nyc_311_cleaned;


-- ============================================================
-- 3. VALIDATE RESOLUTION TIME
-- ============================================================

SELECT
    MIN(resolution_hours) AS minimum_resolution_hours,
    MAX(resolution_hours) AS maximum_resolution_hours,
    AVG(resolution_hours) AS average_resolution_hours
FROM nyc_311_cleaned
WHERE resolution_hours IS NOT NULL;


-- ============================================================
-- 4. VALIDATE PROJECT ANALYSIS SCOPE
-- ============================================================

SELECT
    MIN(created_at::date) AS analysis_start,
    MAX(created_at::date) AS analysis_end,
    COUNT(*) AS requests_in_scope
FROM nyc_311_cleaned
WHERE
    created_at::date BETWEEN '2025-10-11' AND '2025-11-29';


-- ============================================================
-- 5. VALIDATE DUE DATE / SLA SUBSET
-- ============================================================

SELECT
    COUNT(*) AS requests_with_due_date,

    COUNT(*) FILTER (
        WHERE closed_at IS NOT NULL
        AND resolution_hours IS NOT NULL
    ) AS valid_closed_requests,

    COUNT(*) FILTER (
        WHERE
            closed_at IS NOT NULL
            AND resolution_hours IS NOT NULL
            AND closed_at <= due_at
    ) AS closed_by_due_date,

    COUNT(*) FILTER (
        WHERE
            closed_at IS NOT NULL
            AND resolution_hours IS NOT NULL
            AND closed_at > due_at
    ) AS closed_after_due_date

FROM nyc_311_cleaned
WHERE
    created_at::date BETWEEN '2025-10-11' AND '2025-11-29'
    AND due_at IS NOT NULL;