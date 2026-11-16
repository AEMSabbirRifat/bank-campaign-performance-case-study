-- 08 Which job groups respond? Rates inside each year; 2009 is the year with both volume and spread.
SELECT CASE job WHEN 'admin.' THEN 'Office and admin' WHEN 'blue-collar' THEN 'Blue-collar' WHEN 'entrepreneur' THEN 'Entrepreneur'
                WHEN 'housemaid' THEN 'Household staff' WHEN 'management' THEN 'Management' WHEN 'retired' THEN 'Retired'
                WHEN 'self-employed' THEN 'Self-employed' WHEN 'services' THEN 'Services' WHEN 'student' THEN 'Student'
                WHEN 'technician' THEN 'Technician' WHEN 'unemployed' THEN 'Unemployed' ELSE 'Not recorded' END AS job_group,
       count(*)                                              AS clients_contacted,
       round(100.0 * count(*) / sum(count(*)) OVER (), 1)    AS pct_of_clients,
       sum((campaign_year = 2009)::INT)                      AS clients_2009,
       round(100.0 * avg(CASE WHEN campaign_year = 2008 THEN subscribed::INT END), 1) AS pct_bought_2008,
       round(100.0 * avg(CASE WHEN campaign_year = 2009 THEN subscribed::INT END), 1) AS pct_bought_2009,
       round(100.0 * avg(CASE WHEN campaign_year = 2010 THEN subscribed::INT END), 1) AS pct_bought_2010
FROM contacts
GROUP BY 1
ORDER BY pct_bought_2009 DESC;
