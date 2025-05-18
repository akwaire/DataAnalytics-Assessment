-- Assessment_Q2.sql
-- Calculate average number of savings transactions per customer per month
-- and categorize into High (≥10), Medium (3–9) or Low (≤2) frequency.

WITH user_txn AS (
  SELECT
    u.id AS customer_id,
    COUNT(s.id) AS total_transactions,
    -- Active months between first and last transaction, inclusive (at least 1)
    GREATEST(
      TIMESTAMPDIFF(
        MONTH,
        MIN(s.transaction_date),
        MAX(s.transaction_date)
      ) + 1,
      1
    ) AS months_active
  FROM
    users_customuser u
    JOIN savings_savingsaccount s
      ON s.owner_id = u.id
  GROUP BY
    u.id
)

SELECT
  CASE
    WHEN avg_txn >= 10 THEN 'High Frequency'
    WHEN avg_txn BETWEEN 3 AND 9 THEN 'Medium Frequency'
    ELSE 'Low Frequency'
  END AS frequency_category,
  COUNT(*)                                AS customer_count,
  ROUND(AVG(avg_txn), 1)                  AS avg_transactions_per_month
FROM (
  SELECT
    customer_id,
    total_transactions / months_active    AS avg_txn
  FROM
    user_txn
) AS sub
GROUP BY
  frequency_category
ORDER BY
  CASE frequency_category
    WHEN 'High Frequency' THEN 1
    WHEN 'Medium Frequency' THEN 2
    WHEN 'Low Frequency' THEN 3
  END;
