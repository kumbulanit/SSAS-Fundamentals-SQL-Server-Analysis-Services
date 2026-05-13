# Practical Lab — Real-World SSAS Implementation at Assmang
## Day 02 | Assmang Pty Ltd — SSAS Fundamentals

---

## 🎯 Lab Goal

Apply the theory from **Real-World SSAS Implementation at Assmang** by completing a guided, step-by-step exercise in SQL Server Data Tools (SSDT) and SQL Server Management Studio (SSMS).

## 📋 Prerequisites

- Dataset **`v3_assmang_mining_complete.sql`** loaded into SQL Server
- SQL Server Analysis Services running
- Visual Studio with SSDT installed
- SSMS available for verification

## 🔧 Lab Environment

| Component | Value |
|-----------|-------|
| SQL Server Instance | localhost\SSASDEV (or your instance) |
| Database | AssmangMining |
| SSAS Project | AssmangMiningCube |
| Dataset Version | `v3_assmang_mining_complete.sql` |

---

## 📝 Guided Steps

### Step 1: Load the v3 dataset and confirm all dimension and fact tables are available

**What to do:** Load the v3 dataset and confirm all dimension and fact tables are available.

**Why this matters:** This step builds your understanding of real-world ssas implementation at assmang by giving you hands-on experience with the tool.

**Expected result:** You should see a successful outcome or confirmation in SSDT/SSMS before moving to the next step.

**Troubleshooting:** If this step fails, check:
- Is the SQL Server instance running?
- Is the dataset `v3_assmang_mining_complete.sql` loaded?
- Do you have the correct permissions?

---

### Step 2: Review the full cube structure and ensure all relevant measure groups are included

**What to do:** Review the full cube structure and ensure all relevant measure groups are included.

**Why this matters:** This step builds your understanding of real-world ssas implementation at assmang by giving you hands-on experience with the tool.

**Expected result:** You should see a successful outcome or confirmation in SSDT/SSMS before moving to the next step.

**Troubleshooting:** If this step fails, check:
- Is the SQL Server instance running?
- Is the dataset `v3_assmang_mining_complete.sql` loaded?
- Do you have the correct permissions?

---

### Step 3: Create or validate at least one KPI each for production, cost, and safety

**What to do:** Create or validate at least one KPI each for production, cost, and safety.

**Why this matters:** This step builds your understanding of real-world ssas implementation at assmang by giving you hands-on experience with the tool.

**Expected result:** You should see a successful outcome or confirmation in SSDT/SSMS before moving to the next step.

**Troubleshooting:** If this step fails, check:
- Is the SQL Server instance running?
- Is the dataset `v3_assmang_mining_complete.sql` loaded?
- Do you have the correct permissions?

---

### Step 4: Run representative MDX queries that answer executive questions

**What to do:** Run representative MDX queries that answer executive questions.

**Why this matters:** This step builds your understanding of real-world ssas implementation at assmang by giving you hands-on experience with the tool.

**Expected result:** You should see a successful outcome or confirmation in SSDT/SSMS before moving to the next step.

**Troubleshooting:** If this step fails, check:
- Is the SQL Server instance running?
- Is the dataset `v3_assmang_mining_complete.sql` loaded?
- Do you have the correct permissions?

---

### Step 5: Document a maintenance plan covering processing, monitoring, and business sign-off

**What to do:** Document a maintenance plan covering processing, monitoring, and business sign-off.

**Why this matters:** This step builds your understanding of real-world ssas implementation at assmang by giving you hands-on experience with the tool.

**Expected result:** You should see a successful outcome or confirmation in SSDT/SSMS before moving to the next step.

**Troubleshooting:** If this step fails, check:
- Is the SQL Server instance running?
- Is the dataset `v3_assmang_mining_complete.sql` loaded?
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

By the end of this lab, you should be able to demonstrate the core workflow for **Real-World SSAS Implementation at Assmang** in the Assmang training environment. You should be able to:

- Apply the full SSAS workflow to an Assmang-style business solution.
- Design a business-ready analytical cube for production, cost, safety, and workforce reporting.
- Understand deployment, maintenance, and reporting integration considerations.
- Consolidate the course into a real implementation playbook.

---

## 💡 Tips for Success

- **Read each step fully** before executing it.
- **Save your project** after each major step.
- **Ask questions** if something doesn't look right — it's better to clarify early.
- **Take notes** on what you observe — this helps with the assessment later.

## SQL Integrated Validation Pack (Run in SSMS Database Engine)

```sql
USE AssmangMining;
GO

SELECT 'Dim_Mine' AS TableName, COUNT(*) AS RowCount FROM dbo.Dim_Mine
UNION ALL SELECT 'Dim_Department', COUNT(*) FROM dbo.Dim_Department
UNION ALL SELECT 'Dim_Employee', COUNT(*) FROM dbo.Dim_Employee
UNION ALL SELECT 'Dim_Date', COUNT(*) FROM dbo.Dim_Date
UNION ALL SELECT 'FactProduction', COUNT(*) FROM dbo.FactProduction
UNION ALL SELECT 'FactOperatingCosts', COUNT(*) FROM dbo.FactOperatingCosts
UNION ALL SELECT 'FactEquipmentEfficiency', COUNT(*) FROM dbo.FactEquipmentEfficiency
UNION ALL SELECT 'FactSafetyKPI', COUNT(*) FROM dbo.FactSafetyKPI
UNION ALL SELECT 'FactEmployeeMetrics', COUNT(*) FROM dbo.FactEmployeeMetrics;
```

```sql
SELECT
	m.MineName,
	SUM(fp.TonnesProduced) AS TotalTonnes,
	SUM(fp.RevenueZAR) AS TotalRevenueZAR,
	AVG(sk.ComplianceScore) AS AvgComplianceScore
FROM dbo.Dim_Mine m
LEFT JOIN dbo.FactProduction fp ON m.MineID = fp.MineID
LEFT JOIN dbo.FactSafetyKPI sk ON m.MineID = sk.MineID
GROUP BY m.MineName
ORDER BY TotalRevenueZAR DESC;
```

## Executive MDX Query Pack (Run in SSMS against SSAS)

```mdx
/* Executive view 1: Production and revenue by mine */
SELECT
	{[Measures].[TonnesProduced], [Measures].[RevenueZAR]} ON COLUMNS,
	[Mine].[Mine Name].[Mine Name].MEMBERS ON ROWS
FROM [Assmang Mining Analytics]
WHERE ([Date].[Calendar Year].&[2024]);
```

```mdx
/* Executive view 2: Safety and efficiency indicators */
SELECT
	{[Measures].[ComplianceScore], [Measures].[UpTimePercentage]} ON COLUMNS,
	[Mine].[Mine Name].[Mine Name].MEMBERS ON ROWS
FROM [Assmang Mining Analytics];
```

```mdx
/* Executive view 3: Workforce metric */
SELECT
	{[Measures].[AttendancePercentage], [Measures].[OvertimeHours]} ON COLUMNS,
	[Department].[Department Name].[Department Name].MEMBERS ON ROWS
FROM [Assmang Mining Analytics]
WHERE ([Date].[Calendar Year].&[2024]);
```

---

*Assmang Pty Ltd — SSAS Fundamentals | Day 02 Practical Lab*

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
