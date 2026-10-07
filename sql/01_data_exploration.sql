SELECT COUNT(*) AS total_rows 
FROM nyc_311_raw;

SELECT unique_key, created_date, closed_date, agency, problem, status, borough
FROM nyc_311_raw
LIMIT 10;

SELECT
    MIN(TO_TIMESTAMP(created_date, 'MM/DD/YYYY HH12:MI:SS AM')) AS earliest_request,
    MAX(TO_TIMESTAMP(created_date, 'MM/DD/YYYY HH12:MI:SS AM')) AS latest_request
FROM nyc_311_raw;

SELECT
    TO_TIMESTAMP(created_date, 'MM/DD/YYYY HH12:MI:SS AM')::date AS day,
    COUNT(*) AS requests
FROM nyc_311_raw
GROUP BY 1
ORDER BY 1;

SELECT
    agency,
    COUNT(*) AS requests
FROM nyc_311_raw
GROUP BY agency
ORDER BY requests DESC;

SELECT
    status,
    COUNT(*) AS requests
FROM nyc_311_raw
GROUP BY status
ORDER BY requests DESC;

SELECT
    problem,
    COUNT(*) AS requests
FROM nyc_311_raw
GROUP BY problem
ORDER BY requests DESC
LIMIT 15;

SELECT
    borough,
    COUNT(*) AS requests
FROM nyc_311_raw
GROUP BY borough
ORDER BY requests DESC;

--Missing Values
SELECT
    COUNT(*) FILTER (WHERE unique_key IS NULL) AS missing_unique_key,
    COUNT(*) FILTER (WHERE created_date IS NULL) AS missing_created_date,
    COUNT(*) FILTER (WHERE closed_date IS NULL) AS missing_closed_date,
    COUNT(*) FILTER (WHERE agency IS NULL) AS missing_agency,
    COUNT(*) FILTER (WHERE problem IS NULL) AS missing_problem,
    COUNT(*) FILTER (WHERE status IS NULL) AS missing_status,
    COUNT(*) FILTER (WHERE borough IS NULL) AS missing_borough
FROM nyc_311_raw;

SELECT
    status,
    COUNT(*) AS requests,
    COUNT(*) FILTER (WHERE closed_date IS NULL) AS missing_closed_date
FROM nyc_311_raw
GROUP BY status
ORDER BY requests DESC;