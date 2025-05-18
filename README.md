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

## 🕐 Q3: [Placeholder Title]

> 🟨 _In Progress..._

---

## 🕐 Q4: [Placeholder Title]

> 🟨 _In Progress..._

---

## 🧠 Author Notes

- This project was executed with a focus on **transparency**, **real-time testing**, and **efficient SQL practices**
- Ideal for live or timed assessments, onboarding SQL analysts, or preparing SQL templates

---

## 🔖 Tags  
`MySQL` `SQL Analytics` `Data Analyst` `CTE` `Joins` `Real-time Projects` `Cowrywise Assessment`
