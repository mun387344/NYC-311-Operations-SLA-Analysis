SELECT COUNT(*) AS total_rows 
FROM nyc_311_raw;

SELECT unique_key, created_date, closed_date, agency, problem, status, borough
FROM nyc_311_raw
LIMIT 10;

SELECT
    MIN(TO_TIMESTAMP(created_date, 'MM/DD/YYYY HH12:MI:SS AM')) AS earliest_request,
    MAX(TO_TIMESTAMP(created_date, 'MM/DD/YYYY HH12:MI:SS AM')) AS latest_request
FROM nyc_311_raw;