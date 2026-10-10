SELECT ROUND(total / (SELECT COUNT(DISTINCT customer_id) FROM Delivery ) * 100,2) AS immediate_percentage   FROM (SELECT
CASE 
    WHEN  order_date = customer_pref_delivery_date THEN 'immediate'
    ELSE 'scheduled'
END AS order_stat, COUNT(*) AS total
FROM (SELECT 
order_date ,customer_pref_delivery_date ,
ROW_NUMBER() OVER(PARTITION BY customer_id ORDER BY order_date ASC) AS rn
FROM Delivery) k
WHERE rn = 1
GROUP BY order_stat) q
WHERE order_stat ='immediate';
