# Practical Lab — Measures, Measure Groups, and Aggregations
## Day 01 | Assmang Pty Ltd — SSAS Fundamentals

---

## 🎯 Lab Goal

Apply the theory from **Measures, Measure Groups, and Aggregations** by completing a guided, step-by-step exercise in SQL Server Data Tools (SSDT) and SQL Server Management Studio (SSMS).

## 📋 Prerequisites

- Dataset **`v2_assmang_mining_extended.sql`** loaded into SQL Server
- SQL Server Analysis Services running
- Visual Studio with SSDT installed
- SSMS available for verification

## 🔧 Lab Environment

| Component | Value |
|-----------|-------|
| SQL Server Instance | localhost\SSASDEV (or your instance) |
| Database | AssmangMining |
| SSAS Project | AssmangMiningCube |
| Dataset Version | `v2_assmang_mining_extended.sql` |

---

## 📝 Guided Steps

### Step 1: Load `datasets/v2_assmang_mining_extended.sql`

**What to do:** Load `datasets/v2_assmang_mining_extended.sql` to add production and operating cost facts.

**Why this matters:** This step builds your understanding of measures, measure groups, and aggregations by giving you hands-on experience with the tool.

**Expected result:** You should see a successful outcome or confirmation in SSDT/SSMS before moving to the next step.

**Troubleshooting:** If this step fails, check:
- Is the SQL Server instance running?
- Is the dataset `v2_assmang_mining_extended.sql` loaded?
- Do you have the correct permissions?

---

### Step 2: Update the Data Source View to include `FactProduction` and `FactOperatingCosts`

**What to do:** Update the Data Source View to include `FactProduction` and `FactOperatingCosts`.

**Why this matters:** This step builds your understanding of measures, measure groups, and aggregations by giving you hands-on experience with the tool.

**Expected result:** You should see a successful outcome or confirmation in SSDT/SSMS before moving to the next step.

**Troubleshooting:** If this step fails, check:
- Is the SQL Server instance running?
- Is the dataset `v2_assmang_mining_extended.sql` loaded?
- Do you have the correct permissions?

---

### Step 3: Create a cube using the Cube Wizard and select both fact tables as measure groups

**What to do:** Create a cube using the Cube Wizard and select both fact tables as measure groups.

**Why this matters:** This step builds your understanding of measures, measure groups, and aggregations by giving you hands-on experience with the tool.

**Expected result:** You should see a successful outcome or confirmation in SSDT/SSMS before moving to the next step.

**Troubleshooting:** If this step fails, check:
- Is the SQL Server instance running?
- Is the dataset `v2_assmang_mining_extended.sql` loaded?
- Do you have the correct permissions?

---

### Step 4: Review the proposed measures and correct any aggregation types that should use averages instead of sums

**What to do:** Review the proposed measures and correct any aggregation types that should use averages instead of sums.

**Why this matters:** This step builds your understanding of measures, measure groups, and aggregations by giving you hands-on experience with the tool.

**Expected result:** You should see a successful outcome or confirmation in SSDT/SSMS before moving to the next step.

**Troubleshooting:** If this step fails, check:
- Is the SQL Server instance running?
- Is the dataset `v2_assmang_mining_extended.sql` loaded?
- Do you have the correct permissions?

---

### Step 5: Process the cube and browse `TonnesProduced`, `RevenueZAR`, and cost measures by mine and month

**What to do:** Process the cube and browse `TonnesProduced`, `RevenueZAR`, and cost measures by mine and month.

**Why this matters:** This step builds your understanding of measures, measure groups, and aggregations by giving you hands-on experience with the tool.

**Expected result:** You should see a successful outcome or confirmation in SSDT/SSMS before moving to the next step.

**Troubleshooting:** If this step fails, check:
- Is the SQL Server instance running?
- Is the dataset `v2_assmang_mining_extended.sql` loaded?
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

By the end of this lab, you should be able to demonstrate the core workflow for **Measures, Measure Groups, and Aggregations** in the Assmang training environment. You should be able to:

- Understand the relationship between fact tables, measure groups, and cube measures.
- Choose correct aggregation behavior for common mining metrics.
- Recognise additive, semi-additive, and non-additive business values.
- Understand the purpose of aggregations in performance optimisation.

---

## 💡 Tips for Success

- **Read each step fully** before executing it.
- **Save your project** after each major step.
- **Ask questions** if something doesn't look right — it's better to clarify early.
- **Take notes** on what you observe — this helps with the assessment later.

## SQL Validation Queries (Run in SSMS)

Run these checks to validate the fact tables used by your measure groups:

```sql
USE AssmangMining;
GO

SELECT
	COUNT(*) AS FactProductionRows,
	COUNT(DISTINCT MineID) AS MineCount,
	MIN(DateID) AS MinDateID,
	MAX(DateID) AS MaxDateID
FROM dbo.FactProduction;
```

```sql
SELECT
	m.MineName,
	SUM(fp.TonnesProduced) AS TotalTonnes,
	SUM(fp.RevenueZAR) AS TotalRevenueZAR,
	AVG(fp.Grade) AS AvgGrade
FROM dbo.FactProduction fp
JOIN dbo.Dim_Mine m ON fp.MineID = m.MineID
GROUP BY m.MineName
ORDER BY TotalTonnes DESC;
```

```sql
SELECT
	m.MineName,
	d.DepartmentName,
	SUM(oc.LaborCostZAR + oc.EquipmentCostZAR + oc.MaintenanceCostZAR + oc.SafetyCostZAR + oc.UtilitiesCostZAR + oc.OtherCostZAR) AS TotalOperatingCost
FROM dbo.FactOperatingCosts oc
JOIN dbo.Dim_Mine m ON oc.MineID = m.MineID
JOIN dbo.Dim_Department d ON oc.DepartmentID = d.DepartmentID
GROUP BY m.MineName, d.DepartmentName
ORDER BY m.MineName, d.DepartmentName;
```

---

*Assmang Pty Ltd — SSAS Fundamentals | Day 01 Practical Lab*
