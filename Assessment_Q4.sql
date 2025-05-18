-- Assessment_Q4.sql
-- Estimate Customer Lifetime Value (CLV):
--  • Tenure in months since signup (min 1)
--  • Total savings transactions
--  • Avg. profit per txn = 0.1% of the transaction value
--  • CLV = (txns/tenure)*12 * avg_profit

WITH txn_stats AS (
  SELECT
    u.id AS customer_id,
    u.name AS name,
    -- months since signup (at least 1)
    GREATEST(
      TIMESTAMPDIFF(MONTH, u.date_joined, CURDATE()),
      1
    ) AS tenure_months,
    -- count of all savings transactions
    COUNT(s.id) AS total_transactions,
    -- average deposit amount in kobo
    AVG(s.confirmed_amount) AS avg_amount_kobo
  FROM
    users_customuser u
    LEFT JOIN savings_savingsaccount s
      ON s.owner_id = u.id
  GROUP BY
    u.id,
    u.name
)

SELECT
  customer_id,
  name,
  tenure_months,
  total_transactions,
  -- Convert avg_amount_kobo → naira by dividing by 100, then profit = 0.1% → ÷1000 more:
  -- avg_profit_naira = avg_amount_kobo / 100000
  ROUND(
    (total_transactions / tenure_months) * 12 
    * (avg_amount_kobo / 100000),
    2
  ) AS estimated_clv
FROM
  txn_stats
ORDER BY
  estimated_clv DESC;
