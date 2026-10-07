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