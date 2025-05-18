# Data Analytics Assessment — Cowrywise

This repository contains the full execution and documentation of a live data analyst assessment for Cowrywise. It reflects the entire process — from local setup to query testing, optimization, benchmarking, and Git-based version control.

## 💼 Assessment Context

**Goal:** Evaluate data analysts on real-world SQL problem solving.  
**Scope:** The assessment contains 4 SQL questions, each targeting a specific business scenario.  
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

| File                  | Purpose                                |
|-----------------------|----------------------------------------|
| `Assessment_Q1.sql`   | Final answer for Question 1             |
| `Assessment_Q2.sql`   | Placeholder for Question 2              |
| `Assessment_Q3.sql`   | Placeholder for Question 3              |
| `Assessment_Q4.sql`   | Placeholder for Question 4              |
| `README.md`           | Full documentation and query breakdowns |

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

### 🧠 Query Strategy

This solution uses **modular SQL with CTEs (Common Table Expressions)** for clarity and reusability:

1. `user_plans`: counts savings and investment plans per user
2. `user_deposits`: aggregates confirmed deposit amounts
3. Final SELECT: joins everything, applies filters, and sorts

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

### 📥 Sample Output (Top 2 Users)

| owner_id                             | name   | savings_count | investment_count | total_deposits   |
|--------------------------------------|--------|----------------|------------------|------------------|
| 1909df3eba2548cfa3b9c270112bd262     | (NULL) | 3              | 9                | 890312215.48     |
| 5572810f38b543429ffb218ef15243fc     | (NULL) | 108            | 60               | 389632644.11     |

> Note: `name` values are `NULL` in the dataset; logic remains valid.

---

### ✅ Status: Completed & Committed  
→ See: [`Assessment_Q1.sql`](./Assessment_Q1.sql)

---

## 🕐 Q2: [Placeholder Title]

> 🟨 _In Progress..._

- [ ] Problem breakdown
- [ ] SQL plan
- [ ] Query testing
- [ ] Optimization
- [ ] Benchmark & commit

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

