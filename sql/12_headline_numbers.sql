-- 12 The numbers quoted in the story, in one place.
SELECT sum(calls)                                                                        AS calls_made,
       sum(subscribed::INT)                                                              AS deposits_sold,
       round(1.0 * sum(calls) / sum(subscribed::INT), 1)                                 AS calls_per_sale,
       round(100.0 * sum(CASE WHEN campaign_year = 2008 THEN calls END) / sum(calls), 1) AS pct_calls_in_2008,
       round(100.0 * sum(CASE WHEN campaign_year = 2008 THEN subscribed::INT END) / sum(subscribed::INT), 1) AS pct_sales_in_2008,
       round(1.0 * sum(CASE WHEN campaign_year = 2008 THEN calls END) / sum(CASE WHEN campaign_year = 2008 THEN subscribed::INT END), 1) AS calls_per_sale_2008,
       round(1.0 * sum(CASE WHEN campaign_year = 2010 THEN calls END) / sum(CASE WHEN campaign_year = 2010 THEN subscribed::INT END), 1) AS calls_per_sale_2010,
       sum(CASE WHEN calls >= 10 THEN 1 ELSE 0 END)                                      AS clients_called_10_plus,
       sum(CASE WHEN calls >= 10 THEN calls END)                                         AS calls_to_those_clients,
       sum(CASE WHEN calls >= 10 THEN subscribed::INT END)                               AS sales_from_those_clients,
       sum(greatest(calls - 3, 0))                                                       AS calls_after_the_third,
       sum(CASE WHEN calls > 3 THEN subscribed::INT END)                                 AS sales_after_the_third,
       sum(CASE WHEN history = 'Never contacted before' AND channel = 'Landline' THEN calls END)            AS first_time_landline_calls,
       sum(CASE WHEN history = 'Never contacted before' AND channel = 'Landline' THEN subscribed::INT END)  AS first_time_landline_sales,
       sum(CASE WHEN history = 'Never contacted before' AND channel = 'Mobile' THEN calls END)              AS first_time_mobile_calls,
       sum(CASE WHEN history = 'Never contacted before' AND channel = 'Mobile' THEN subscribed::INT END)    AS first_time_mobile_sales
FROM contacts;
