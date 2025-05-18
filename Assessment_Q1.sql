-- Q1: Identify High-Value Customers with Both Savings and Investment Plans
-- This query returns users who have at least one savings plan and one investment plan,
-- along with the total value of their confirmed savings deposits.

-- Step 1: Aggregate savings and investment plans per user
WITH user_plans AS (
    SELECT
        owner_id,
        -- Count savings plans (is_regular_savings = 1)
        COUNT(DISTINCT CASE WHEN is_regular_savings = 1 THEN id END) AS savings_count,
        
        -- Count investment plans (is_a_fund = 1)
        COUNT(DISTINCT CASE WHEN is_a_fund = 1 THEN id END) AS investment_count
    FROM plans_plan
    GROUP BY owner_id
),

-- Step 2: Aggregate confirmed deposits (in kobo) and convert to naira
user_deposits AS (
    SELECT
        owner_id,
        -- Sum all confirmed deposit amounts and convert from kobo to naira
        ROUND(SUM(confirmed_amount) / 100, 2) AS total_deposits
    FROM savings_savingsaccount
    WHERE confirmed_amount > 0
    GROUP BY owner_id
)

-- Step 3: Combine user info, plan counts, and deposit totals
SELECT
    u.id AS owner_id,
    u.name,

    -- Use COALESCE to default null counts to 0
    COALESCE(p.savings_count, 0) AS savings_count,
    COALESCE(p.investment_count, 0) AS investment_count,
    COALESCE(d.total_deposits, 0) AS total_deposits

FROM users_customuser u

-- Join pre-aggregated plan data
LEFT JOIN user_plans p ON u.id = p.owner_id

-- Join pre-aggregated deposit data
LEFT JOIN user_deposits d ON u.id = d.owner_id

-- Only return users who have both savings AND investment plans
WHERE
    COALESCE(p.savings_count, 0) >= 1
    AND COALESCE(p.investment_count, 0) >= 1

-- Sort by value: highest total deposits first
ORDER BY total_deposits DESC;
