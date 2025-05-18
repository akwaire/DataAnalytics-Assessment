# DataAnalytics-Assessment

This repository contains my solutions to the SQL proficiency assessment provided by Cowrywise. It includes four SQL queries addressing cross-selling opportunities, transaction frequency analysis, inactivity alerts, and a simplified Customer Lifetime Value (CLV) estimation model, along with explanations of the approach, assumptions, and any challenges encountered.

---

## Table of Contents

1. [Getting Started](#getting-started)
2. [Assessment Overview](#assessment-overview)
3. [Question 1: High-Value Customers with Multiple Products](#question-1-high-value-customers-with-multiple-products)
4. [Question 2: Transaction Frequency Analysis](#question-2-transaction-frequency-analysis)
5. [Question 3: Account Inactivity Alert](#question-3-account-inactivity-alert)
6. [Question 4: Customer Lifetime Value Estimation](#question-4-customer-lifetime-value-estimation)
7. [Challenges & Assumptions](#challenges--assumptions)

---

## Getting Started

1. Install MySQL 8.0 (or use XAMPP).
2. Create the database:

   ```sql
   CREATE DATABASE adashi_staging;
   ```
3. Import the SQL dump:

   ```bash
   mysql -u root -p adashi_staging < adashi_assessment.sql
   ```
4. Run each query file in your SQL client:

   * `Assessment_Q1.sql`
   * `Assessment_Q2.sql`
   * `Assessment_Q3.sql`
   * `Assessment_Q4.sql`

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
 See [Assessment_Q1.sql](https://github.com/akwaire/DataAnalytics-Assessment/blob/main/Assessment_Q1.sql)
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
-- See [Assessment_Q2.sql](./Assessment_Q2.sql)
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
-- See [Assessment_Q3.sql](./Assessment_Q3.sql)
```

---

## Question 4: Customer Lifetime Value Estimation

**Objective:**
Estimate each customer’s lifetime value (CLV) using a simplified model where profit per transaction = 0.1% of the transaction value.

**Approach:**

1. Compute customer tenure in months since `date_joined` (min 1).
2. Count total transactions & average deposit amount (in kobo).
3. Apply CLV formula:

   ```
     CLV = (total_transactions/tenure_months) * 12 * (avg_amount_kobo/100000)
   ```
4. Order by estimated CLV descending.

```sql
-- See [Assessment_Q4.sql](./Assessment_Q4.sql)
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
