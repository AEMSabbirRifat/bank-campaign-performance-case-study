-- 02 Where did the calls go, and where did the sales come from?
SELECT campaign_year,
       count(*)                                              AS clients_contacted,
       sum(calls)                                            AS calls_made,
       round(100.0 * sum(calls) / sum(sum(calls)) OVER (), 1) AS pct_of_all_calls,
       sum(subscribed::INT)                                  AS deposits_sold,
       round(100.0 * sum(subscribed::INT) / sum(sum(subscribed::INT)) OVER (), 1) AS pct_of_all_sales,
       round(100.0 * avg(subscribed::INT), 1)                AS pct_clients_who_bought,
       round(1.0 * sum(calls) / sum(subscribed::INT), 1)     AS calls_per_sale,
       round(100.0 * avg((history = 'Never contacted before')::INT), 1) AS pct_first_time_contacts,
       round(100.0 * avg((channel = 'Landline')::INT), 1)    AS pct_landline,
       round(avg(euribor_3m), 2)                             AS avg_euribor_3m
FROM contacts
GROUP BY campaign_year
ORDER BY campaign_year;
