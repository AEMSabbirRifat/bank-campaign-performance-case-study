-- 05 Does calling the same client again pay? Share who bought, by number of calls, 2008 against 2009-2010.
SELECT CASE WHEN calls >= 7 THEN 7 ELSE calls END            AS sort_order,
       CASE WHEN calls >= 7 THEN '7+' ELSE CAST(calls AS VARCHAR) END AS calls_to_client,
       sum((campaign_year = 2008)::INT)                      AS clients_2008,
       round(100.0 * avg(CASE WHEN campaign_year = 2008 THEN subscribed::INT END), 1) AS pct_bought_2008,
       sum((campaign_year > 2008)::INT)                      AS clients_2009_2010,
       round(100.0 * avg(CASE WHEN campaign_year > 2008 THEN subscribed::INT END), 1) AS pct_bought_2009_2010
FROM contacts
GROUP BY 1, 2
ORDER BY 1;
