-- 01 What is in the file?
SELECT count(*)                                         AS clients_contacted,
       sum(calls)                                       AS calls_made,
       sum(subscribed::INT)                             AS deposits_sold,
       round(100.0 * avg(subscribed::INT), 1)           AS pct_clients_who_bought,
       round(1.0 * sum(calls) / sum(subscribed::INT), 1) AS calls_per_sale,
       max(calls)                                       AS most_calls_to_one_client,
       min(campaign_year)                               AS first_year,
       max(campaign_year)                               AS last_year
FROM contacts;
