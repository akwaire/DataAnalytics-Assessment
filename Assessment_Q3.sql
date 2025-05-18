-- Assessment_Q3.sql
-- Identify active plans (savings or investment) with no inflow
-- (deposit) transactions in the last 365 days.

SELECT
  p.id                                AS plan_id,
  p.owner_id                          AS owner_id,
  CASE
    WHEN p.is_regular_savings = 1 THEN 'Savings'
    WHEN p.is_a_fund         = 1 THEN 'Investment'
    ELSE 'Unknown'
  END                                 AS type,
  -- Most recent deposit date for this plan
  MAX(s.transaction_date)            AS last_transaction_date,
  -- Days since that last deposit
  DATEDIFF(CURDATE(), MAX(s.transaction_date))  
                                      AS inactivity_days
FROM
  plans_plan p
  LEFT JOIN savings_savingsaccount s
    ON s.savings_id = p.id
GROUP BY
  p.id,
  p.owner_id,
  p.is_regular_savings,
  p.is_a_fund
HAVING
  -- Exclude plans with no deposits ever
  MAX(s.transaction_date) IS NOT NULL
  -- Only those whose last deposit is 365+ days ago
  AND MAX(s.transaction_date) <= DATE_SUB(CURDATE(), INTERVAL 365 DAY)
;
