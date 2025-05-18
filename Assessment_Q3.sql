-- Q3: Account Inactivity Alert
-- Goal: Identify savings or investment plans with no inflow in the last 365 days (or never used).

-- ========================================================================
-- Step 1: Compute each plan’s most recent inflow date
-- ========================================================================
WITH last_transaction AS (
    SELECT
        savings_id,                                 -- plan identifier
        MAX(transaction_date) AS last_transaction_date  -- latest inflow per plan
    FROM savings_savingsaccount
    -- no WHERE needed since MAX(NULL) is ignored
    GROUP BY savings_id                           -- one row per plan
)

-- ========================================================================
-- Step 2: Join plans to their last inflow info and filter for inactivity
-- ========================================================================
SELECT
    p.id                   AS plan_id,           -- plan identifier
    p.owner_id             AS owner_id,          -- customer identifier

    -- Classify plan type
    CASE
      WHEN p.is_regular_savings = 1 THEN 'Savings'
      WHEN p.is_a_fund         = 1 THEN 'Investment'
    END                      AS type,

    l.last_transaction_date,                     -- last inflow date (NULL if never used)

    -- Compute days since last inflow (NULL if never used)
    DATEDIFF(NOW(), l.last_transaction_date)     AS inactivity_days

FROM plans_plan p

    -- Include all plans; link to inflow info if it exists
    LEFT JOIN last_transaction l
      ON l.savings_id = p.id

WHERE
    -- Only actual savings or investment plans
    (p.is_regular_savings = 1 OR p.is_a_fund = 1)
    -- Flag plans never used or inactive > 365 days
    AND (
        l.last_transaction_date IS NULL
        OR DATEDIFF(NOW(), l.last_transaction_date) > 365
    )

-- Show the most inactive plans first
ORDER BY inactivity_days DESC;
