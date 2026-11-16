-- 10 A plain call order built from the findings above, applied to the calls that were actually made.
-- No model: five groups, called in the order that holds inside each year.
WITH grouped AS (
  SELECT CASE WHEN history = 'Bought in an earlier campaign' THEN 1
              WHEN history = 'Never contacted before' AND channel = 'Mobile' AND job IN ('student', 'retired') THEN 2
              WHEN history = 'Never contacted before' AND channel = 'Mobile' THEN 3
              WHEN history = 'Declined in an earlier campaign' THEN 4
              ELSE 5 END AS call_order,
         calls, subscribed
  FROM contacts
),
per_group AS (
  SELECT call_order,
         CASE call_order WHEN 1 THEN 'Bought in an earlier campaign'
                         WHEN 2 THEN 'First-time, mobile, student or retired'
                         WHEN 3 THEN 'First-time, mobile, everyone else'
                         WHEN 4 THEN 'Declined in an earlier campaign'
                         ELSE 'First-time, landline' END AS client_group,
         count(*) AS clients_contacted, sum(calls) AS calls_made, sum(subscribed::INT) AS deposits_sold
  FROM grouped GROUP BY call_order
)
SELECT call_order, client_group, clients_contacted, calls_made, deposits_sold,
       round(100.0 * deposits_sold / clients_contacted, 1)                            AS pct_clients_who_bought,
       round(1.0 * calls_made / deposits_sold, 1)                                     AS calls_per_sale,
       round(100.0 * sum(calls_made) OVER (ORDER BY call_order) / sum(calls_made) OVER (), 1)       AS cumulative_pct_of_calls,
       round(100.0 * sum(deposits_sold) OVER (ORDER BY call_order) / sum(deposits_sold) OVER (), 1) AS cumulative_pct_of_sales
FROM per_group
ORDER BY call_order;
