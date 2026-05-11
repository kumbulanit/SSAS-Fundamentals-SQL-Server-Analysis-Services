# Practical Lab — Introduction to SQL Server Analysis Services
## Day 01 | Assmang Pty Ltd — SSAS Fundamentals

---

## 🎯 Lab Goal

Apply the theory from **Introduction to SQL Server Analysis Services** by completing a guided, step-by-step exercise in SQL Server Data Tools (SSDT) and SQL Server Management Studio (SSMS).

## 📋 Prerequisites

- Dataset **`v1_assmang_mining_base.sql`** loaded into SQL Server
- SQL Server Analysis Services running
- Visual Studio with SSDT installed
- SSMS available for verification

## 🔧 Lab Environment

| Component | Value |
|-----------|-------|
| SQL Server Instance | localhost\SSASDEV (or your instance) |
| Database | AssmangMining |
| SSAS Project | AssmangMiningCube |
| Dataset Version | `v1_assmang_mining_base.sql` |

---

## 📝 Guided Steps

### Step 1: Load `datasets/v1_assmang_mining_base.sql`

**What to do:** Load `datasets/v1_assmang_mining_base.sql` into SQL Server and verify all four dimension tables exist.

**Why this matters:** This step builds your understanding of introduction to sql server analysis services by giving you hands-on experience with the tool.

**Expected result:** You should see a successful outcome or confirmation in SSDT/SSMS before moving to the next step.

**Troubleshooting:** If this step fails, check:
- Is the SQL Server instance running?
- Is the dataset `v1_assmang_mining_base.sql` loaded?
- Do you have the correct permissions?

---

### Step 2: Open Visual Studio with SSDT and create a new Analysis Services Multidimensional Project

**What to do:** Open Visual Studio with SSDT and create a new Analysis Services Multidimensional Project.

**Why this matters:** This step builds your understanding of introduction to sql server analysis services by giving you hands-on experience with the tool.

**Expected result:** You should see a successful outcome or confirmation in SSDT/SSMS before moving to the next step.

**Troubleshooting:** If this step fails, check:
- Is the SQL Server instance running?
- Is the dataset `v1_assmang_mining_base.sql` loaded?
- Do you have the correct permissions?

---

### Step 3: Create a data source pointing to the `AssmangMining` database

**What to do:** Create a data source pointing to the `AssmangMining` database.

**Why this matters:** This step builds your understanding of introduction to sql server analysis services by giving you hands-on experience with the tool.

**Expected result:** You should see a successful outcome or confirmation in SSDT/SSMS before moving to the next step.

**Troubleshooting:** If this step fails, check:
- Is the SQL Server instance running?
- Is the dataset `v1_assmang_mining_base.sql` loaded?
- Do you have the correct permissions?

---

### Step 4: Create a Data Source View including `Dim_Mine`, `Dim_Department`, `Dim_Employee`, and `Dim_Date`

**What to do:** Create a Data Source View including `Dim_Mine`, `Dim_Department`, `Dim_Employee`, and `Dim_Date`.

**Why this matters:** This step builds your understanding of introduction to sql server analysis services by giving you hands-on experience with the tool.

**Expected result:** You should see a successful outcome or confirmation in SSDT/SSMS before moving to the next step.

**Troubleshooting:** If this step fails, check:
- Is the SQL Server instance running?
- Is the dataset `v1_assmang_mining_base.sql` loaded?
- Do you have the correct permissions?

---

### Step 5: Deploy an empty project shell to the local SSAS instance to confirm connectivity and permissions

**What to do:** Deploy an empty project shell to the local SSAS instance to confirm connectivity and permissions.

**Why this matters:** This step builds your understanding of introduction to sql server analysis services by giving you hands-on experience with the tool.

**Expected result:** You should see a successful outcome or confirmation in SSDT/SSMS before moving to the next step.

**Troubleshooting:** If this step fails, check:
- Is the SQL Server instance running?
- Is the dataset `v1_assmang_mining_base.sql` loaded?
- Do you have the correct permissions?

---

## ✅ Validation Checklist

Before marking this lab as complete, confirm:

- [ ] The relevant SQL dataset was loaded and verified
- [ ] The SSAS project was opened without errors
- [ ] All objects created in this lab are visible in Solution Explorer
- [ ] Processing completed successfully (check Output window)
- [ ] The cube browser or SSMS query returns expected results
- [ ] You can explain what each object does in business terms

---

## 🎓 Expected Outcome

By the end of this lab, you should be able to demonstrate the core workflow for **Introduction to SQL Server Analysis Services** in the Assmang training environment. You should be able to:

- Explain what SSAS is and where it fits in the Microsoft BI stack.
- Differentiate multidimensional and tabular models at a beginner level.
- Understand SSAS terminology such as cube, dimension, hierarchy, measure, and processing.
- Connect the SSAS learning journey to Assmang production analytics use cases.

---

## 💡 Tips for Success

- **Read each step fully** before executing it.
- **Save your project** after each major step.
- **Ask questions** if something doesn't look right — it's better to clarify early.
- **Take notes** on what you observe — this helps with the assessment later.

## SQL Validation Queries (Run in SSMS)

Run these checks after loading `v1_assmang_mining_base.sql`:

```sql
USE AssmangMining;
GO

SELECT
	(SELECT COUNT(*) FROM dbo.Dim_Mine) AS MineCount,
	(SELECT COUNT(*) FROM dbo.Dim_Department) AS DepartmentCount,
	(SELECT COUNT(*) FROM dbo.Dim_Employee) AS EmployeeCount,
	(SELECT COUNT(*) FROM dbo.Dim_Date) AS DateCount;
```

```sql
SELECT TOP (10)
	e.EmployeeCode,
	e.FirstName + ' ' + e.LastName AS EmployeeName,
	m.MineName,
	d.DepartmentName
FROM dbo.Dim_Employee e
LEFT JOIN dbo.Dim_Mine m ON e.MineID = m.MineID
LEFT JOIN dbo.Dim_Department d ON e.DepartmentID = d.DepartmentID
ORDER BY e.EmployeeID;
```

```sql
SELECT
	MIN(FullDate) AS StartDate,
	MAX(FullDate) AS EndDate,
	COUNT(*) AS NumberOfDates
FROM dbo.Dim_Date;
```

---

*Assmang Pty Ltd — SSAS Fundamentals | Day 01 Practical Lab*
