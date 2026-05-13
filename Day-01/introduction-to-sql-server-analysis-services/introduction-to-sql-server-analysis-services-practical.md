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

---

## 🧰 Detailed SSMS Workflow (Use This If You Are Not Using Visual Studio)

Use this exact sequence when completing the lab/exercises primarily in SSMS:

1. Open SSMS and connect to the SQL Database Engine hosting `AssmangMining`.
2. Open a **new query window** and run the dataset script for your topic (`v1`, `v2`, or `v3`) if required.
3. Validate dataset load with `SELECT COUNT(*)` checks on key dimension and fact tables.
4. Open a second SSMS connection: **Connect > Analysis Services**.
5. In Object Explorer, expand **Databases** and confirm the target SSAS database is visible.
6. If the SSAS database is missing, ask your trainer for the deployed project name and deployment server.
7. Expand the SSAS database and inspect:
   - **Data Sources**
   - **Data Source Views**
   - **Cubes**
   - **Dimensions**
8. Right-click the target cube and open **Browse** to validate dimensional navigation.
9. Test at least one business slice per task (for example Mine, Month, Commodity, or Department).
10. Run MDX in an SSAS query window: **New Query > MDX**.
11. Save each important query with meaningful names (for example `01-production-by-mine.mdx`).
12. Capture evidence after each exercise:
   - Query text
   - Output grid screenshot
   - One-sentence interpretation in business language
13. If results look incorrect, run this troubleshooting chain:
   - Check source table row counts in SQL Engine
   - Confirm cube processing completed
   - Validate dimension relationships and hierarchy levels
   - Re-run the MDX with simpler axes first
14. Before submission, record:
   - What you tested
   - What answer you obtained
   - Why the answer is relevant to Assmang operations

### SSMS Menu Path Quick Reference

- Connect to SQL Engine: `File > Connect Object Explorer > Database Engine`
- Connect to SSAS: `Object Explorer > Connect > Analysis Services`
- Open SQL query: `Toolbar > New Query`
- Open MDX query: `Analysis Services connection > New Query > MDX`
- Browse cube: `SSAS Database > Cubes > [Cube Name] > Browse`
- Process object (if permissions allow): `Right-click Cube/Dimension > Process`

## Detailed Visual Studio (SSDT) Workflow (Step-by-Step)

Use this path when you are building and validating directly in Visual Studio with SSDT:

1. Open Visual Studio and load your SSAS solution.
2. In Solution Explorer, confirm these project objects exist and are not showing warning icons:
   - Data Sources
   - Data Source Views
   - Dimensions
   - Cubes
3. Open Data Source and click Test Connection.
4. Open Data Source View (DSV) and confirm all required tables are present and related correctly.
5. For each required dimension in this topic:
   - Open the dimension designer.
   - Check KeyColumns and NameColumn.
   - Confirm user hierarchies are logically ordered.
6. Open the cube designer and verify:
   - Correct measure groups
   - Correct aggregation function per measure (SUM/AVG/etc.)
   - Dimension usage relationships are correctly mapped
7. Deploy configuration check:
   - Right-click project > Properties
   - Confirm Deployment Server, Database, and Processing Option
8. Build the project: Build > Build Solution.
9. Fix all build errors before deployment (do not ignore warnings related to key columns or relationships).
10. Deploy: right-click project > Deploy.
11. Process objects if prompted; if not prompted, run manual processing:
   - Right-click SSAS database/cube in SSDT or SSMS > Process
12. Validate in the cube browser:
   - Drag at least one measure
   - Slice by at least one hierarchy related to this exercise
13. Open SSMS (Analysis Services connection) and run 1-2 MDX validation queries for the same result.
14. Compare browser output vs MDX output; values should align.
15. If values differ, troubleshoot in this order:
   - Relationship mapping in Dimension Usage
   - Measure aggregation type
   - Processing freshness (reprocess impacted objects)
   - Source data quality in SQL Engine tables
16. Save evidence for each exercise:
   - Build/deploy outcome
   - Browser or MDX result
   - Short interpretation in plain business language

### Visual Studio Menu Path Quick Reference

- Open solution: File > Open > Project/Solution
- Build: Build > Build Solution
- Deploy: Solution Explorer > Right-click SSAS Project > Deploy
- Project deployment settings: Right-click SSAS Project > Properties > Deployment
- Process object: Right-click Cube/Dimension > Process
- Cube browser: Open Cube Designer > Browser tab

### Evidence Standard (What Good Submission Looks Like)

- Include **input + output + explanation** for each major task.
- Explanations should answer: **what changed, what you observed, and why it matters**.
- Prefer short and precise evidence over long screenshots with no commentary.
