# DataAnalytics-Assessment

This repository contains my solutions to the SQL proficiency assessment provided by Cowrywise. It includes four SQL queries addressing cross-selling opportunities, transaction frequency analysis, inactivity alerts, and a simplified Customer Lifetime Value (CLV) estimation model, along with explanations of the approach, assumptions, and any challenges encountered.

---

## Table of Contents

1. [Assessment Overview](#assessment-overview)
2. [Question 1: High-Value Customers with Multiple Products](#question-1-high-value-customers-with-multiple-products)
3. [Question 2: Transaction Frequency Analysis](#question-2-transaction-frequency-analysis)
4. [Question 3: Account Inactivity Alert](#question-3-account-inactivity-alert)
5. [Question 4: Customer Lifetime Value Estimation](#question-4-customer-lifetime-value-estimation)
6. [Challenges & Assumptions](#challenges--assumptions)

---

## Assessment Overview

* **Environment:** MySQL 8.0
* **Schema:**

  * `users_customuser` (customer demographics, signup date)
  * `savings_savingsaccount` (deposit transactions)
  * `plans_plan` (customer plans—savings vs. investments)
  * `withdrawals_withdrawal` (withdrawal transactions)
* **Data Units:** All monetary fields in **kobo** (100 kobo = 1 naira).

---

## Question 1: High-Value Customers with Multiple Products

**Objective:**
Identify customers who hold **at least one** funded savings plan *and* **one** funded investment plan—ideal cross-selling targets—sorted by their total deposit amount.

**Approach:**

1. **Joins:** Link `users_customuser` → `plans_plan` → `savings_savingsaccount` (only for savings plans).
2. **Aggregation:**

   * Count savings plans (`is_regular_savings = 1`) and investment plans (`is_a_fund = 1`).
   * Sum all deposits and convert kobo→naira (`SUM(confirmed_amount)/100`).
3. **Filtering:** Use `HAVING` to ensure each user has ≥1 of each plan type.
4. **Ordering:** Descending by total deposits.

```sql
-- Assessment_Q1.sql
SELECT
    u.id                                           AS owner_id,
    u.name                                         AS name,
    SUM(CASE WHEN p.is_regular_savings = 1 THEN 1 ELSE 0 END) AS savings_count,
    SUM(CASE WHEN p.is_a_fund         = 1 THEN 1 ELSE 0 END) AS investment_count,
    COALESCE(SUM(s.confirmed_amount)/100.0, 0)             AS total_deposits
FROM
    users_customuser AS u
    LEFT JOIN plans_plan AS p
        ON p.owner_id = u.id
    LEFT JOIN savings_savingsaccount AS s
        ON s.savings_id = p.id
        AND p.is_regular_savings = 1
GROUP BY
    u.id,
    u.name
HAVING
       SUM(CASE WHEN p.is_regular_savings = 1 THEN 1 ELSE 0 END) >= 1
   AND SUM(CASE WHEN p.is_a_fund         = 1 THEN 1 ELSE 0 END) >= 1
ORDER BY
    total_deposits DESC;
```

---

## Question 2: Transaction Frequency Analysis

**Objective:**
Segment customers into **High Frequency** (≥10 txns/month), **Medium Frequency** (3–9 txns/month), or **Low Frequency** (≤2 txns/month) based on their average monthly savings deposit transactions.

**Approach:**

1. Compute total transactions and months active (min 1) per user.
2. Calculate average transactions per month.
3. Bucket into High/Medium/Low via a `CASE` expression.
4. Aggregate to count customers and average rates per bucket.

```sql
-- Assessment_Q2.sql
WITH user_txn AS (
  SELECT
    u.id AS customer_id,
    COUNT(s.id) AS total_transactions,
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
  COUNT(*)                           AS customer_count,
  ROUND(AVG(avg_txn), 1)             AS avg_transactions_per_month
FROM (
  SELECT
    customer_id,
    total_transactions / months_active AS avg_txn
  FROM
    user_txn
) AS sub
GROUP BY
  frequency_category
ORDER BY
  CASE frequency_category
    WHEN 'High Frequency'   THEN 1
    WHEN 'Medium Frequency' THEN 2
    WHEN 'Low Frequency'    THEN 3
  END;
```

---

## Question 3: Account Inactivity Alert

**Objective:**
Flag all **active** savings or investment plans that have received **no deposit** transactions in the past **365 days**.

**Approach:**

1. Left-join `plans_plan` to any savings transactions.
2. Use `MAX(transaction_date)` to find the last deposit per plan.
3. Filter for inactivity ≥ 365 days via `HAVING`.
4. Compute days of inactivity with `DATEDIFF`.

```sql
-- Assessment_Q3.sql
SELECT
  p.id                                             AS plan_id,
  p.owner_id                                       AS owner_id,
  CASE
    WHEN p.is_regular_savings = 1 THEN 'Savings'
    WHEN p.is_a_fund         = 1 THEN 'Investment'
    ELSE 'Unknown'
  END                                              AS type,
  MAX(s.transaction_date)                          AS last_transaction_date,
  DATEDIFF(CURDATE(), MAX(s.transaction_date))     AS inactivity_days
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
  MAX(s.transaction_date) IS NOT NULL
  AND MAX(s.transaction_date) <= DATE_SUB(CURDATE(), INTERVAL 365 DAY);
```

---

## Question 4: Customer Lifetime Value Estimation

**Objective:**
Estimate each customer’s lifetime value (CLV) using a simplified model where profit per transaction = 0.1% of the transaction value.

**Approach:**

1. Compute customer tenure in months since `date_joined` (min 1).
2. Count total transactions & average deposit amount (in kobo).
3. Apply CLV formula:

   $$
     \text{CLV} = \left(\frac{\text{total\_transactions}}{\text{tenure\_months}}\right) \times 12 \times \frac{\text{avg\_amount\_kobo}}{100\,000}
   $$
4. Order by estimated CLV descending.

```sql
-- Assessment_Q4.sql
WITH txn_stats AS (
  SELECT
    u.id                                     AS customer_id,
    u.name                                   AS name,
    GREATEST(
      TIMESTAMPDIFF(MONTH, u.date_joined, CURDATE()),
      1
    )                                        AS tenure_months,
    COUNT(s.id)                              AS total_transactions,
    AVG(s.confirmed_amount)                 AS avg_amount_kobo
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
  ROUND(
    (total_transactions / tenure_months) * 12
    * (avg_amount_kobo / 100000),
    2
  )                                        AS estimated_clv
FROM
  txn_stats
ORDER BY
  estimated_clv DESC;
```

---

## Challenges & Assumptions

* **Assumptions:**

  * Monetary values stored in kobo; converted to naira by dividing by 100.
  * `is_regular_savings = 1` flags savings plans; `is_a_fund = 1` flags investments.
  * Users with no transactions appear in CLV with tenure ≥ 1 but CLV = 0.

* **Challenges:**

  * Ensuring a minimum “months active” of 1 for users with a single transaction.
  * Converting kobo→naira and applying a 0.1% profit margin correctly.
  * Filtering out plans with **no** deposits ever when flagging inactivity.

---

*Thank you for reviewing my SQL assessment solutions. Feel free to reach out for any clarifications!*
