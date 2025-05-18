-- Q2: Transaction Frequency Analysis
-- Goal: Segment users based on how frequently they transact per month.
-- Each transaction is recorded in `savings_savingsaccount.transaction_date`.

-- Frequency Categories:
-- - "High Frequency"    → avg ≥ 10 transactions/month
-- - "Medium Frequency"  → avg between 3–9 transactions/month
-- - "Low Frequency"     → avg ≤ 2 transactions/month

-- ========================================================================
-- Step 1: Compute total transactions and active months for each customer
-- ========================================================================

WITH user_monthly_stats AS (
    SELECT
        owner_id,
        
        -- Count all transaction records per user
        COUNT(*) AS total_transactions,

        -- Count how many distinct months they were active (e.g. '2024-05')
        COUNT(DISTINCT DATE_FORMAT(transaction_date, '%Y-%m')) AS active_months,

        -- Calculate average transactions per active month
        -- Using ROUND to limit decimals for readability
        ROUND(COUNT(*) / COUNT(DISTINCT DATE_FORMAT(transaction_date, '%Y-%m')), 2) AS avg_txn_per_month

    FROM savings_savingsaccount
    WHERE transaction_date IS NOT NULL
    GROUP BY owner_id
),

-- ========================================================================
-- Step 2: Classify users based on avg_txn_per_month into frequency groups
-- ========================================================================

categorized_users AS (
    SELECT
        owner_id,
        avg_txn_per_month,

        -- Use CASE WHEN to assign each user to a frequency category
        CASE
            WHEN avg_txn_per_month >= 10 THEN 'High Frequency'
            WHEN avg_txn_per_month BETWEEN 3 AND 9 THEN 'Medium Frequency'
            ELSE 'Low Frequency'
        END AS frequency_category
    FROM user_monthly_stats
)

-- ========================================================================
-- Step 3: Aggregate results for each frequency group
-- ========================================================================

SELECT
    frequency_category,

    -- Total number of users in each group
    COUNT(DISTINCT owner_id) AS customer_count,

    -- Average of all user-level monthly averages (rounded for clarity)
    ROUND(AVG(avg_txn_per_month), 2) AS avg_transactions_per_month

FROM categorized_users
GROUP BY frequency_category

-- Ensure the result order matches the business expectation
ORDER BY FIELD(frequency_category, 'High Frequency', 'Medium Frequency', 'Low Frequency');
