-- Q4: Customer Lifetime Value (CLV) Estimation
-- Goal: Estimate CLV using tenure and transaction profit (0.1% per txn).

-- ========================================================================
-- Step 1: Gather user tenure and transaction stats
-- ========================================================================
WITH user_stats AS (
    SELECT
        u.id                     AS customer_id,
        u.name                   AS name,
        -- Compute months since signup, at least 1
        GREATEST(
          TIMESTAMPDIFF(MONTH, u.date_joined, NOW()),
          1
        )                       AS tenure_months,
        -- Total transactions per user
        COUNT(s.id)             AS total_transactions,
        -- Average transaction amount (in kobo)
        AVG(s.confirmed_amount) AS avg_amount_kobo
    FROM users_customuser u
    LEFT JOIN savings_savingsaccount s
      ON s.owner_id = u.id
    GROUP BY u.id, u.name
)

-- ========================================================================
-- Step 2: Calculate CLV and order results
-- ========================================================================
SELECT
    customer_id,
    name,
    tenure_months,
    total_transactions,
    -- avg_amount_kobo / 100000 converts kobo→naira and applies 0.1% profit
    ROUND(
      (total_transactions / tenure_months) * 12
      * (avg_amount_kobo / 100000),
      2
    )                       AS estimated_clv
FROM user_stats
ORDER BY estimated_clv DESC;
