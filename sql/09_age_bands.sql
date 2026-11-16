-- 09 Response by age band, inside each year. Cells with fewer than 30 clients are left empty.
SELECT age_order, age_band,
       count(*)                                              AS clients_contacted,
       CASE WHEN sum((campaign_year = 2008)::INT) >= 30 THEN round(100.0 * avg(CASE WHEN campaign_year = 2008 THEN subscribed::INT END), 1) END AS pct_bought_2008,
       CASE WHEN sum((campaign_year = 2009)::INT) >= 30 THEN round(100.0 * avg(CASE WHEN campaign_year = 2009 THEN subscribed::INT END), 1) END AS pct_bought_2009,
       CASE WHEN sum((campaign_year = 2010)::INT) >= 30 THEN round(100.0 * avg(CASE WHEN campaign_year = 2010 THEN subscribed::INT END), 1) END AS pct_bought_2010
FROM contacts
GROUP BY age_order, age_band
ORDER BY age_order;
