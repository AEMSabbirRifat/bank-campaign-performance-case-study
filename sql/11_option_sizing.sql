-- 11 Three options, replayed on the calls that were actually made.
-- A sale is recorded at a client's last call, so a cap at three keeps the sales that closed within three calls.
WITH base AS (
  SELECT calls, subscribed::INT AS sold,
         (history = 'Never contacted before' AND channel = 'Landline') AS cold_landline
  FROM contacts
),
scenarios AS (
  SELECT 0 AS sort_order, 'As run' AS option, 'Every call that was made' AS rule, sum(calls) AS calls_made, sum(sold) AS deposits_sold FROM base
  UNION ALL
  SELECT 1, 'A', 'Stop after three calls to a client', sum(least(calls, 3)), sum(CASE WHEN calls <= 3 THEN sold ELSE 0 END) FROM base
  UNION ALL
  SELECT 2, 'B', 'No first-time calls to landlines', sum(calls), sum(sold) FROM base WHERE NOT cold_landline
  UNION ALL
  SELECT 3, 'C', 'Both rules together', sum(least(calls, 3)), sum(CASE WHEN calls <= 3 THEN sold ELSE 0 END) FROM base WHERE NOT cold_landline
)
SELECT sort_order, option, rule, calls_made, deposits_sold,
       round(1.0 * calls_made / deposits_sold, 1)                                    AS calls_per_sale,
       round(100.0 * (1 - 1.0 * calls_made / first_value(calls_made) OVER (ORDER BY sort_order)), 1)   AS pct_calls_saved,
       round(100.0 * deposits_sold / first_value(deposits_sold) OVER (ORDER BY sort_order), 1)          AS pct_sales_kept
FROM scenarios
ORDER BY sort_order;
