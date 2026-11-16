-- 00 Build the analysis table. One row per client contacted in the campaign.
-- Input: data/bank-additional-full.csv.gz (UCI "Bank Marketing", semicolon separated, in date order, May 2008 to November 2010).
-- The file has a month but no year. Rows are in date order, so the year is rebuilt by counting each time the month number falls.
CREATE OR REPLACE TABLE contacts AS
WITH raw AS (
  SELECT *, row_number() OVER () AS client_no
  FROM read_csv('data/bank-additional-full.csv.gz', delim = ';', header = true)
),
numbered AS (
  SELECT *,
         CASE "month" WHEN 'jan' THEN 1 WHEN 'feb' THEN 2 WHEN 'mar' THEN 3 WHEN 'apr' THEN 4 WHEN 'may' THEN 5 WHEN 'jun' THEN 6
                      WHEN 'jul' THEN 7 WHEN 'aug' THEN 8 WHEN 'sep' THEN 9 WHEN 'oct' THEN 10 WHEN 'nov' THEN 11 ELSE 12 END AS month_no
  FROM raw
),
stepped AS (
  SELECT *, CASE WHEN month_no < lag(month_no) OVER (ORDER BY client_no) THEN 1 ELSE 0 END AS new_year
  FROM numbered
)
SELECT
  client_no,
  2008 + sum(new_year) OVER (ORDER BY client_no)                AS campaign_year,
  month_no,
  day_of_week,
  CASE contact WHEN 'cellular' THEN 'Mobile' ELSE 'Landline' END AS channel,
  campaign                                                      AS calls,            -- calls made to this client in this campaign
  CASE poutcome WHEN 'success' THEN 'Bought in an earlier campaign'
                WHEN 'failure' THEN 'Declined in an earlier campaign'
                ELSE 'Never contacted before' END               AS history,
  CASE poutcome WHEN 'success' THEN 1 WHEN 'failure' THEN 2 ELSE 3 END AS history_order,
  job,
  age,
  CASE WHEN age < 25 THEN 'Under 25' WHEN age < 35 THEN '25 to 34' WHEN age < 45 THEN '35 to 44'
       WHEN age < 55 THEN '45 to 54' WHEN age < 65 THEN '55 to 64' ELSE '65 and over' END AS age_band,
  CASE WHEN age < 25 THEN 1 WHEN age < 35 THEN 2 WHEN age < 45 THEN 3 WHEN age < 55 THEN 4 WHEN age < 65 THEN 5 ELSE 6 END AS age_order,
  euribor3m                                                     AS euribor_3m,
  (y = 'yes')                                                   AS subscribed        -- opened the term deposit
FROM stepped;
