--How many requests have a usable resolution time? 
SELECT
    COUNT(*) AS total_requests,
    COUNT(resolution_hours) AS valid_resolution_requests
FROM nyc_311_cleaned
WHERE created_at::date BETWEEN '2025-10-11' AND '2025-11-29';

--What does the resolution time look like overall?
SELECT
    COUNT(resolution_hours) AS valid_requests,
    ROUND(AVG(resolution_hours), 1) AS avg_hours,
    ROUND(
        PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY resolution_hours)::numeric, 1
    ) AS median_hours,
    ROUND(
        PERCENTILE_CONT(0.9) WITHIN GROUP (ORDER BY resolution_hours)::numeric, 1
    ) AS p90_hours
FROM nyc_311_cleaned
WHERE created_at::date BETWEEN '2025-10-11' AND '2025-11-29'
AND resolution_hours IS NOT NULL;
  
--How does it differ by agency, problem and borough?
SELECT
    Agency,
    COUNT(resolution_hours) AS valid_requests,
    ROUND(AVG(resolution_hours), 1) AS avg_hours,
    ROUND(
        PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY resolution_hours)::numeric, 1
    ) AS median_hours,
    ROUND(
        PERCENTILE_CONT(0.9) WITHIN GROUP (ORDER BY resolution_hours)::numeric, 1
    ) AS p90_hours
FROM nyc_311_cleaned
WHERE created_at::date BETWEEN '2025-10-11' AND '2025-11-29'
AND resolution_hours IS NOT NULL
GROUP BY Agency
ORDER BY median_hours DESC;

--How do we define SLA? 
SELECT
    COUNT(resolution_hours) AS valid_requests,

    ROUND(
        100.0 * COUNT(*) FILTER (
            WHERE resolution_hours <= 24
        ) / COUNT(resolution_hours), 1
    ) AS resolved_within_24h_pct,

    ROUND(
        100.0 * COUNT(*) FILTER (
            WHERE resolution_hours <= 72
        ) / COUNT(resolution_hours), 1
    ) AS resolved_within_72h_pct,

    ROUND(
        100.0 * COUNT(*) FILTER (
            WHERE resolution_hours <= 168
        ) / COUNT(resolution_hours), 1
    ) AS resolved_within_7d_pct

FROM nyc_311_cleaned
WHERE created_at::date BETWEEN '2025-10-11' AND '2025-11-29'
  AND resolution_hours IS NOT NULL;