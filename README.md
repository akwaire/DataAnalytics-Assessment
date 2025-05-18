# Data Analytics Assessment — Cowrywise

This repository contains the full execution and documentation of a live data analyst assessment for Cowrywise. It reflects the entire process — from local setup to query testing, optimization, benchmarking, and Git-based version control.

## 💼 Assessment Context

**Goal:** Evaluate data analysts on real-world SQL problem solving  
**Scope:** The assessment contains 4 SQL questions, each targeting a specific business scenario  
**Environment:**  
- MySQL 9.3 (localhost)  
- Dataset loaded from `adashi_assessment.sql`  
- Development environment: VS Code with MySQL plugin  
- Version control: GitHub (`main` branch)

Each solution is optimized for:
- ✅ Accuracy  
- ✅ Performance  
- ✅ Clarity (modular structure, comments)  
- ✅ Scalability (readable & adaptable)

---

## 📁 Repository Structure

| File                | Purpose                                 |
|---------------------|-----------------------------------------|
| `Assessment_Q1.sql` | Final answer for Question 1             |
| `Assessment_Q2.sql` | Final answer for Question 2             |
| `Assessment_Q3.sql` | Placeholder for Question 3              |
| `Assessment_Q4.sql` | Placeholder for Question 4              |
| `README.md`         | Full documentation and query breakdowns |

---

## ✅ Q1: High-Value Customers with Multiple Products

### 🔍 Scenario  
The business wants to identify customers who have **both a savings and an investment plan** — for cross-selling opportunities.

### 🧩 Task  
Return users who have:
- At least one **funded savings plan** (`is_regular_savings = 1`)
- At least one **investment plan** (`is_a_fund = 1`)
- Total **confirmed deposits** (converted from kobo to naira)

Sort results in **descending order** of total deposits.

### 📊 Tables Used
- `users_customuser`
- `plans_plan`
- `savings_savingsaccount`

---

### 🧠 SQL Strategy

This solution uses **modular SQL with CTEs (Common Table Expressions)** for clarity and reusability:

1. **`user_plans`** – counts savings and investment plans per user  
2. **`user_deposits`** – aggregates confirmed deposit amounts  
3. **Final SELECT** – joins everything, applies filters, and sorts

---

### 📌 SQL Concepts Applied

| Concept           | Description                                       |
|------------------|---------------------------------------------------|
| `WITH` (CTEs)    | Modular, reusable logic blocks                    |
| `CASE WHEN`      | Conditional plan counts                           |
| `COALESCE`       | Converts `NULL` to `0` for cleaner output         |
| `ROUND(..., 2)`  | Converts from kobo to naira with 2 decimal places |
| `LEFT JOIN`      | Ensures users without deposits are still included |

---

### 🚀 Performance

- Benchmarked on a local machine:
  - ~1,760 users
  - 159K+ savings records
  - 9.6K+ plans
- **Full query execution time: 1 second**
- Fully scalable and readable for real-world analytics

---

### 📥 Result Sample (Top 2 Users)

| owner_id                             | name   | savings_count | investment_count | total_deposits   |
|--------------------------------------|--------|----------------|------------------|------------------|
| 1909df3eba2548cfa3b9c270112bd262     | (NULL) | 3              | 9                | 890312215.48     |
| 5572810f38b543429ffb218ef15243fc     | (NULL) | 108            | 60               | 389632644.11     |

> Note: `name` values are `NULL` in the dataset; logic remains valid.

---

### ✅ Status: Completed & Committed  
→ See: [`Assessment_Q1.sql`](./Assessment_Q1.sql)

---

## ✅ Q2: Transaction Frequency Analysis

### 🔍 Scenario  
The finance team wants to understand how often customers transact, in order to segment them into frequency-based cohorts for personalized targeting or product design.

### 🧩 Task  
Group users into frequency segments by calculating their **average transactions per month**, based on records in `savings_savingsaccount`.

**Categories:**
- **High Frequency**: ≥ 10 txns/month  
- **Medium Frequency**: 3–9 txns/month  
- **Low Frequency**: ≤ 2 txns/month

Return a summary report showing:
- `frequency_category`
- `customer_count`
- `avg_transactions_per_month`

---

### 🧠 SQL Strategy

This query was structured using **modular CTEs (Common Table Expressions)** for clarity, flexibility, and performance:

1. **`user_monthly_stats`**  
   - Aggregates `total_transactions` and `distinct months` per user  
   - Calculates `avg_txn_per_month`

2. **`categorized_users`**  
   - Buckets each user into High/Medium/Low frequency based on average

3. **Final SELECT**  
   - Aggregates number of users per frequency group  
   - Computes average frequency per group

---

### ⚙️ SQL Concepts Used

| Feature                     | Purpose                                                    |
|-----------------------------|------------------------------------------------------------|
| `WITH` (CTE)                | Modular subquery logic                                     |
| `DATE_FORMAT(..., '%Y-%m')` | Normalize timestamps to month granularity                  |
| `CASE WHEN`                 | Used for frequency bucket classification                   |
| `ROUND()`                   | For cleaner average output                                 |
| `FIELD()` in `ORDER BY`     | Preserves semantic order of frequency labels               |

---

### 🧪 Performance

- Query completed in **1 second**
- Dataset size: ~159K+ transactions
- Scalable due to well-structured aggregation and conditional logic

---

### 📊 Result Sample (All Frequency Buckets)

| frequency_category | customer_count | avg_transactions_per_month |
|--------------------|----------------|-----------------------------|
| High Frequency     | 141            | 44.72                       |
| Medium Frequency   | 178            | 4.57                        |
| Low Frequency      | 554            | 1.37                        |

> Full query and logic are saved in [`Assessment_Q2.sql`](./Assessment_Q2.sql)

---



## ✅ Q3: Account Inactivity Alert

### 🔍 Scenario  
The ops team wants to flag plans (savings or investment) that have **no inflow transactions** for over one year.

### 🧩 Task  
Find all active plans where:
- No transactions in the past 365 days  
- Includes plans that have **never been used**

Return:
- `plan_id`
- `owner_id`
- `type` (“Savings” or “Investment”)
- `last_transaction_date`
- `inactivity_days`

---

### 🧠 SQL Strategy

This query uses **modular CTEs** to separate concerns:

1. **`last_transaction`**  
   - Aggregates the **most recent** `transaction_date` per plan.

2. **Final SELECT**  
   - Joins each plan to its last transaction  
   - Filters for plans with `last_transaction_date IS NULL` or inactivity > 365 days  
   - Calculates `inactivity_days` via `DATEDIFF(NOW(), last_transaction_date)`

---

### ⚙️ SQL Concepts Used

| Feature            | Purpose                                               |
|--------------------|-------------------------------------------------------|
| `WITH` (CTE)       | Isolates “most recent inflow” logic                   |
| `MAX()`            | Finds the latest transaction per plan                 |
| `LEFT JOIN`        | Includes plans with no matching transactions          |
| `CASE WHEN`        | Classifies each plan as “Savings” or “Investment”     |
| `DATEDIFF()`       | Computes days since the last inflow                   |

---

### 🧪 Performance

- Query runtime: **2.7 seconds**  
- Dataset: ~9.6K plans, ~163K transactions  
- Scalable with proper indexing on `(savings_id, transaction_date)`

---

### 📊 Result Sample (Top 3 Plans)

| plan_id                             | owner_id                           | type       | last_transaction_date | inactivity_days |
|-------------------------------------|------------------------------------|------------|-----------------------|-----------------|
| 002b48c9f6ec48fdb586bd0a5f01f8e6    | 5572810f38b543429ffb218ef15243fc   | Savings    | 2023-01-15 10:22:35   | 458             |
| 0032b91dd582408ab59946b54a19fc7e    | d4fc05997a4a419fac61fe92d3644742   | Investment | NULL                  | NULL            |
| bf35ec61318b4bd680780f6fba6eeff2    | da1b733b34084652897e4be00f49ffb0   | Investment | NULL                  | NULL            |

> Full query and logic are saved in [`Assessment_Q3.sql`](./Assessment_Q3.sql)


---

## ✅ Q4: Customer Lifetime Value Estimation

### 🔍 Scenario

Marketing wants to estimate customer lifetime value (CLV) from tenure and transaction volume, using a simple profit margin.

### 🧩 Task

For each customer:

1. **Tenure** (months since `date_joined`, minimum 1)
2. **Total transactions** in `savings_savingsaccount`
3. **Estimated profit per transaction** = 0.1% of transaction value
4. **CLV** = (total\_transactions / tenure) × 12 × avg\_profit
5. Sort by **estimated\_clv** descending

---

### 🧠 SQL Strategy

```sql
WITH user_stats AS (
    SELECT
        u.id                     AS customer_id,
        u.name                   AS name,
        GREATEST(
          TIMESTAMPDIFF(MONTH, u.date_joined, NOW()),
          1
        )                       AS tenure_months,
        COUNT(s.id)             AS total_transactions,
        AVG(s.confirmed_amount) AS avg_amount_kobo
    FROM users_customuser u
    LEFT JOIN savings_savingsaccount s
      ON s.owner_id = u.id
    GROUP BY u.id, u.name
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
    )                       AS estimated_clv
FROM user_stats
ORDER BY estimated_clv DESC;
```

---

### ⚙️ SQL Concepts Used

| Feature                    | Purpose                                                |
| -------------------------- | ------------------------------------------------------ |
| `TIMESTAMPDIFF(...,NOW())` | Calculates months of tenure                            |
| `GREATEST(...,1)`          | Ensures at least one month to avoid zero division      |
| `AVG()`                    | Computes average transaction value (in kobo)           |
| `ROUND(...,2)`             | Formats CLV to two decimal places                      |
| `CTE`                      | Modular separation of user stats and final computation |

---

### 🧪 Performance

* Runtime: **1.4 seconds**
* Dataset: \~1,867 users, \~163K transactions
* Efficient through pre-aggregation in CTE

---

### 📊 Result Sample (Top 2 Customers)

| customer\_id                     | name   | tenure\_months | total\_transactions | estimated\_clv |
| -------------------------------- | ------ | -------------- | ------------------- | -------------- |
| 1909df3eba2548cfa3b9c270112bd262 | (NULL) | 33             | 2,383               | 323,749.80     |
| 3097d111f15b4c44ac1bf1f49ec8f9bb | (NULL) | 25             | 845                 | 103,777.81     |

> Full query logic is stored in [`Assessment_Q4.sql`](./Assessment_Q4.sql) 

---

## 🧠 Author Notes

- This project was executed with a focus on **transparency**, **real-time testing**, and **efficient SQL practices**
- Ideal for live or timed assessments, onboarding SQL analysts, or preparing SQL templates

---

## 🔖 Tags  
`MySQL` `SQL Analytics` `Data Analyst` `CTE` `Joins` `Real-time Projects` `Cowrywise Assessment`
