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
