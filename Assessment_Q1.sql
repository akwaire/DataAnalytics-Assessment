-- Assessment_Q1.sql
-- Identify customers who have at least one savings plan and one investment plan,
-- showing counts and total deposit amount, sorted by total deposits descending.

SELECT
    u.id                   AS owner_id,
    u.name                 AS name,
    -- Count funded savings plans
    SUM(CASE WHEN p.is_regular_savings = 1 THEN 1 ELSE 0 END)       AS savings_count,
    -- Count funded investment plans
    SUM(CASE WHEN p.is_a_fund         = 1 THEN 1 ELSE 0 END)       AS investment_count,
    -- Sum of all deposit transactions (amounts are in kobo, convert to currency)
    COALESCE(SUM(s.confirmed_amount)/100.0, 0)                     AS total_deposits
FROM
    users_customuser AS u
    -- Join to all plans for each user
    LEFT JOIN plans_plan AS p
        ON p.owner_id = u.id
    -- Only deposit transactions for savings plans
    LEFT JOIN savings_savingsaccount AS s
        ON s.savings_id = p.id
        AND p.is_regular_savings = 1
GROUP BY
    u.id,
    u.name
-- Only users who have at least one savings AND one investment plan
HAVING
       SUM(CASE WHEN p.is_regular_savings = 1 THEN 1 ELSE 0 END) >= 1
   AND SUM(CASE WHEN p.is_a_fund         = 1 THEN 1 ELSE 0 END) >= 1
ORDER BY
    total_deposits DESC;
