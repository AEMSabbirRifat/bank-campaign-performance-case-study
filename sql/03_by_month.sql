-- 03 Month by month. Months with fewer than 50 clients are left out of the rate columns.
SELECT campaign_year, month_no,
       strftime(make_date(CAST(campaign_year AS INT), month_no, 1), '%b %Y') AS month_label,
       count(*)                                              AS clients_contacted,
       sum(calls)                                            AS calls_made,
       sum(subscribed::INT)                                  AS deposits_sold,
       CASE WHEN count(*) >= 50 THEN round(100.0 * avg(subscribed::INT), 1) END AS pct_clients_who_bought
FROM contacts
GROUP BY campaign_year, month_no
ORDER BY campaign_year, month_no;
