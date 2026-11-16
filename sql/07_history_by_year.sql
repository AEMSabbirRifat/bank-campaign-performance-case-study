-- 07 Does the client's history with the bank matter? Compared inside each year and pooled.
-- The pooled column ranks the groups differently from every single year: earlier contacts are concentrated in the later, better years.
SELECT history_order, history,
       CAST(campaign_year AS VARCHAR)                        AS period,
       count(*)                                              AS clients_contacted,
       sum(subscribed::INT)                                  AS deposits_sold,
       CASE WHEN count(*) >= 30 THEN round(100.0 * avg(subscribed::INT), 1) END AS pct_clients_who_bought
FROM contacts
GROUP BY history_order, history, campaign_year
UNION ALL
SELECT history_order, history, 'All years', count(*), sum(subscribed::INT), round(100.0 * avg(subscribed::INT), 1)
FROM contacts
GROUP BY history_order, history
ORDER BY history_order, period;
