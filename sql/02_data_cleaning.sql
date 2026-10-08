-- 02_data_cleaning.sql
-- Create a cleaned analysis dataset without modifying the raw table

DROP TABLE IF EXISTS nyc_311_cleaned;

CREATE TABLE nyc_311_cleaned AS
SELECT
    unique_key,

    TO_TIMESTAMP(created_date, 'MM/DD/YYYY HH12:MI:SS AM')::timestamp
        AS created_at,

    TO_TIMESTAMP(closed_date, 'MM/DD/YYYY HH12:MI:SS AM')::timestamp
        AS closed_at,

    agency,
    agency_name,
    problem,
    problem_detail,
    additional_details,
    location_type,
    incident_zip,
    city,
    status,
    due_date,
    resolution_description,
    community_board,
    council_district,
    police_precinct,
    borough,
    open_data_channel_type,
    latitude,
    longitude

FROM nyc_311_raw;

ALTER TABLE nyc_311_cleaned
ADD COLUMN resolution_hours NUMERIC;

UPDATE nyc_311_cleaned
SET resolution_hours =
    EXTRACT(EPOCH FROM (closed_at - created_at)) / 3600.0;

	-- Basic cleaned-table checks

SELECT
    COUNT(*) AS total_rows,
    COUNT(*) FILTER (WHERE created_at IS NULL) AS missing_created_at,
    COUNT(*) FILTER (WHERE closed_at IS NULL) AS missing_closed_at,
    COUNT(*) FILTER (WHERE resolution_hours IS NULL) AS missing_resolution_hours,
    COUNT(*) FILTER (WHERE resolution_hours < 0) AS negative_resolution_hours,
    COUNT(*) FILTER (WHERE resolution_hours = 0) AS zero_resolution_hours,
    COUNT(*) FILTER (WHERE resolution_hours > 0) AS positive_resolution_hours
FROM nyc_311_cleaned;


-- Check resolution-time range

SELECT
    MIN(resolution_hours) AS minimum_resolution_hours,
    MAX(resolution_hours) AS maximum_resolution_hours,
    AVG(resolution_hours) AS average_resolution_hours
FROM nyc_311_cleaned
WHERE resolution_hours IS NOT NULL;


-- Check negative-resolution records by agency

SELECT
    agency,
    COUNT(*) AS invalid_resolution_records
FROM nyc_311_cleaned
WHERE resolution_hours < 0
GROUP BY agency
ORDER BY invalid_resolution_records DESC;


-- Check status against resolution availability

SELECT
    status,
    COUNT(*) AS requests,
    COUNT(*) FILTER (
        WHERE resolution_hours IS NULL
    ) AS missing_resolution,
    COUNT(*) FILTER (
        WHERE resolution_hours < 0
    ) AS negative_resolution
FROM nyc_311_cleaned
GROUP BY status
ORDER BY requests DESC;

SELECT
    status,
    COUNT(*) AS zero_hour_requests
FROM nyc_311_cleaned
WHERE resolution_hours = 0
GROUP BY status
ORDER BY zero_hour_requests DESC;

SELECT
    unique_key,
    created_at,
    closed_at,
    resolution_hours,
    agency,
    problem,
    status,
    borough
FROM nyc_311_cleaned
WHERE resolution_hours = 0
ORDER BY created_at
LIMIT 20;

SELECT
    COUNT(*) AS total_rows,
    COUNT(*) FILTER (WHERE due_date IS NULL) AS missing_due_date,
    COUNT(*) FILTER (
        WHERE due_date IS NOT NULL
    ) AS non_missing_due_date
FROM nyc_311_raw;

SELECT
    due_date
FROM nyc_311_raw
WHERE due_date IS NOT NULL
LIMIT 20;

SELECT
    COUNT(*) AS total_rows,
    COUNT(*) FILTER (WHERE due_date IS NULL) AS missing_due_date,
    COUNT(*) FILTER (
        WHERE due_date IS NOT NULL
    ) AS available_due_date,
    COUNT(*) FILTER (
        WHERE due_date IS NOT NULL
        AND TO_TIMESTAMP(due_date, 'MM/DD/YYYY HH12:MI:SS AM') IS NULL
    ) AS invalid_due_date
FROM nyc_311_raw;

SELECT
    MIN(created_at) AS earliest_created,
    MAX(created_at) AS latest_created,

    MIN(
        TO_TIMESTAMP(due_date, 'MM/DD/YYYY HH12:MI:SS AM')
    ) AS earliest_due,

    MAX(
        TO_TIMESTAMP(due_date, 'MM/DD/YYYY HH12:MI:SS AM')
    ) AS latest_due
FROM nyc_311_cleaned
WHERE due_date IS NOT NULL;

SELECT
    COUNT(*) AS due_before_created
FROM nyc_311_cleaned
WHERE
    due_date IS NOT NULL
    AND TO_TIMESTAMP(due_date, 'MM/DD/YYYY HH12:MI:SS AM')
        < created_at;

SELECT
    COUNT(*) AS closed_requests,
    
    COUNT(*) FILTER (
        WHERE due_date IS NOT NULL
    ) AS closed_with_due_date,

    COUNT(*) FILTER (
        WHERE
            due_date IS NOT NULL
            AND closed_at <= TO_TIMESTAMP(
                due_date,
                'MM/DD/YYYY HH12:MI:SS AM'
            )
    ) AS closed_by_due_date,

    COUNT(*) FILTER (
        WHERE
            due_date IS NOT NULL
            AND closed_at > TO_TIMESTAMP(
                due_date,
                'MM/DD/YYYY HH12:MI:SS AM'
            )
    ) AS closed_after_due_date

FROM nyc_311_cleaned
WHERE
    created_at::date BETWEEN '2025-10-11' AND '2025-11-29'
    AND status = 'Closed'
    AND closed_at IS NOT NULL
    AND resolution_hours >= 0;

SELECT
    COUNT(*) AS total_scope_requests,

    COUNT(*) FILTER (
        WHERE due_date IS NOT NULL
    ) AS with_due_date,

    COUNT(*) FILTER (
        WHERE due_date IS NULL
    ) AS without_due_date

FROM nyc_311_cleaned
WHERE created_at::date BETWEEN '2025-10-11' AND '2025-11-29';

SELECT
    status,
    COUNT(*) AS requests,
    COUNT(*) FILTER (
        WHERE due_date IS NOT NULL
    ) AS with_due_date,
    COUNT(*) FILTER (
        WHERE due_date IS NULL
    ) AS without_due_date
FROM nyc_311_cleaned
WHERE created_at::date BETWEEN '2025-10-11' AND '2025-11-29'
GROUP BY status
ORDER BY requests DESC;

SELECT
    unique_key,
    created_at,
    due_date,
    status,
    agency,
    problem
FROM nyc_311_cleaned
WHERE
    created_at::date BETWEEN '2025-10-11' AND '2025-11-29'
    AND due_date IS NOT NULL
LIMIT 20;

SELECT
    due_date,
    COUNT(*) AS requests
FROM nyc_311_cleaned
WHERE
    created_at::date BETWEEN '2025-10-11' AND '2025-11-29'
    AND due_date IS NOT NULL
GROUP BY due_date
ORDER BY requests DESC
LIMIT 20;