-- 04 Mobile against landline, first-time contacts only, compared inside each year.
SELECT campaign_year, channel,
       count(*)                                              AS clients_contacted,
       sum(calls)                                            AS calls_made,
       sum(subscribed::INT)                                  AS deposits_sold,
       round(100.0 * avg(subscribed::INT), 1)                AS pct_clients_who_bought,
       round(1.0 * sum(calls) / sum(subscribed::INT), 1)     AS calls_per_sale
FROM contacts
WHERE history = 'Never contacted before'
GROUP BY campaign_year, channel
ORDER BY campaign_year, channel;
