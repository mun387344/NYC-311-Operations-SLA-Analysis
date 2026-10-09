--How many requests were received during the project period, and how does demand change over time?
SELECT
    created_at::date AS request_date,
    COUNT(*) AS request_count
FROM nyc_311_cleaned
WHERE created_at::date BETWEEN '2025-10-11' AND '2025-11-29'
GROUP BY created_at::date
ORDER BY created_at::date;

--Which request types create the largest workload?
SELECT
    problem,
    COUNT(*) AS request_count
FROM nyc_311_cleaned
WHERE created_at::date BETWEEN '2025-10-11' AND '2025-11-29'
GROUP BY problem
ORDER BY request_count DESC;

--Which boroughs receive the most requests?
SELECT
    borough,
    COUNT(*) AS request_count
FROM nyc_311_cleaned
WHERE created_at::date BETWEEN '2025-10-11' AND '2025-11-29'
GROUP BY borough
ORDER BY request_count DESC;

--Which problem–borough combinations generate especially high demand?
SELECT
    borough,
    problem,
    COUNT(*) AS request_count
FROM nyc_311_cleaned
WHERE created_at::date BETWEEN '2025-10-11' AND '2025-11-29'
GROUP BY borough, problem
ORDER BY request_count DESC;
