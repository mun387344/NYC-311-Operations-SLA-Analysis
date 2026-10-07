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