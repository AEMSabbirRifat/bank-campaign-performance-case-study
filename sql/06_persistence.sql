-- 06 What repeated calling cost: clients grouped by how many calls they received.
SELECT CASE WHEN calls <= 3 THEN 1 WHEN calls <= 6 THEN 2 WHEN calls <= 9 THEN 3 ELSE 4 END AS sort_order,
       CASE WHEN calls <= 3 THEN '1 to 3 calls' WHEN calls <= 6 THEN '4 to 6 calls' WHEN calls <= 9 THEN '7 to 9 calls' ELSE '10 calls and more' END AS calls_to_client,
       count(*)                                              AS clients_contacted,
       sum(calls)                                            AS calls_made,
       round(100.0 * sum(calls) / sum(sum(calls)) OVER (), 1) AS pct_of_all_calls,
       sum(subscribed::INT)                                  AS deposits_sold,
       round(100.0 * sum(subscribed::INT) / sum(sum(subscribed::INT)) OVER (), 1) AS pct_of_all_sales,
       round(1.0 * sum(calls) / sum(subscribed::INT))        AS calls_per_sale
FROM contacts
GROUP BY 1, 2
ORDER BY 1;
