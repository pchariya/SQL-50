--Solution: 1
WITH CTE1 AS (SELECT query_name,ROUND(AVG(rating/position), 2) AS quality, COUNT(*) AS total FROM Queries GROUP BY query_name)
, CTE2 AS (SELECT q.query_name, 
CASE 
    WHEN k.query_percentage IS NULL THEN 0
ELSE k.query_percentage END AS poor_query_percentage
FROM CTE1 q LEFT OUTER JOIN (SELECT q.query_name, 
ROUND(COUNT(*)/total * 100, 2) AS query_percentage  
FROM Queries q INNER JOIN CTE1 c ON q.query_name = c.query_name
WHERE rating < 3
GROUP BY query_name) k 
ON k.query_name = q.query_name)


SELECT c1.query_name, c1.quality,c2.poor_query_percentage FROM CTE1 c1 INNER JOIN CTE2 c2
 ON c1.query_name = c2.query_name;


--Solution: 1
SELECT 
    query_name,
    ROUND(AVG(rating / position), 2) AS quality,
    ROUND(SUM(CASE WHEN rating < 3 THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2) AS poor_query_percentage
FROM Queries
WHERE query_name IS NOT NULL
GROUP BY query_name;
