# Practical Lab — Advanced Queries, Calculations, and KPIs
## Day 02 | Assmang Pty Ltd — SSAS Fundamentals

---

## 🎯 Lab Goal

Apply the theory from **Advanced Queries, Calculations, and KPIs** by completing a guided, step-by-step exercise in SQL Server Data Tools (SSDT) and SQL Server Management Studio (SSMS).

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

### Step 1: Create a calculated measure for `Cost Per Tonne` using total cost divided by tonnes produced

**What to do:** Create a calculated measure for `Cost Per Tonne` using total cost divided by tonnes produced.

**Why this matters:** This step builds your understanding of advanced queries, calculations, and kpis by giving you hands-on experience with the tool.

**Expected result:** You should see a successful outcome or confirmation in SSDT/SSMS before moving to the next step.

**Troubleshooting:** If this step fails, check:
- Is the SQL Server instance running?
- Is the dataset `v3_assmang_mining_complete.sql` loaded?
- Do you have the correct permissions?

---

### Step 2: Create a named set for the mines with above-average production

**What to do:** Create a named set for the mines with above-average production.

**Why this matters:** This step builds your understanding of advanced queries, calculations, and kpis by giving you hands-on experience with the tool.

**Expected result:** You should see a successful outcome or confirmation in SSDT/SSMS before moving to the next step.

**Troubleshooting:** If this step fails, check:
- Is the SQL Server instance running?
- Is the dataset `v3_assmang_mining_complete.sql` loaded?
- Do you have the correct permissions?

---

### Step 3: Define a KPI for production target attainment using an assumed monthly target

**What to do:** Define a KPI for production target attainment using an assumed monthly target.

**Why this matters:** This step builds your understanding of advanced queries, calculations, and kpis by giving you hands-on experience with the tool.

**Expected result:** You should see a successful outcome or confirmation in SSDT/SSMS before moving to the next step.

**Troubleshooting:** If this step fails, check:
- Is the SQL Server instance running?
- Is the dataset `v3_assmang_mining_complete.sql` loaded?
- Do you have the correct permissions?

---

### Step 4: Browse the KPI values in the cube browser or SSMS query window

**What to do:** Browse the KPI values in the cube browser or SSMS query window.

**Why this matters:** This step builds your understanding of advanced queries, calculations, and kpis by giving you hands-on experience with the tool.

**Expected result:** You should see a successful outcome or confirmation in SSDT/SSMS before moving to the next step.

**Troubleshooting:** If this step fails, check:
- Is the SQL Server instance running?
- Is the dataset `v3_assmang_mining_complete.sql` loaded?
- Do you have the correct permissions?

---

### Step 5: Document the business meaning of each calculation created

**What to do:** Document the business meaning of each calculation created.

**Why this matters:** This step builds your understanding of advanced queries, calculations, and kpis by giving you hands-on experience with the tool.

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

By the end of this lab, you should be able to demonstrate the core workflow for **Advanced Queries, Calculations, and KPIs** in the Assmang training environment. You should be able to:

- Create calculated measures and members for business-friendly analytics.
- Understand named sets and reusable MDX logic.
- Design practical KPIs for production, cost, and safety monitoring.
- Use time-based calculations to support trend analysis.

---

## 💡 Tips for Success

- **Read each step fully** before executing it.
- **Save your project** after each major step.
- **Ask questions** if something doesn't look right — it's better to clarify early.
- **Take notes** on what you observe — this helps with the assessment later.

## SQL Baseline Checks (Run in SSMS Database Engine)

Use SQL first to validate the source numbers used by your calculations:

```sql
USE AssmangMining;
GO

WITH MonthlyProduction AS (
	SELECT
		fp.MineID,
		fp.DateID,
		SUM(fp.TonnesProduced) AS TonnesProduced,
		SUM(fp.RevenueZAR) AS RevenueZAR
	FROM dbo.FactProduction fp
	GROUP BY fp.MineID, fp.DateID
),
MonthlyCosts AS (
	SELECT
		oc.MineID,
		oc.DateID,
		SUM(oc.LaborCostZAR + oc.EquipmentCostZAR + oc.MaintenanceCostZAR + oc.SafetyCostZAR + oc.UtilitiesCostZAR + oc.OtherCostZAR) AS TotalCostZAR
	FROM dbo.FactOperatingCosts oc
	GROUP BY oc.MineID, oc.DateID
)
SELECT
	m.MineName,
	p.DateID,
	p.TonnesProduced,
	c.TotalCostZAR,
	CASE WHEN p.TonnesProduced = 0 THEN NULL ELSE c.TotalCostZAR / p.TonnesProduced END AS CostPerTonneZAR
FROM MonthlyProduction p
JOIN MonthlyCosts c ON p.MineID = c.MineID AND p.DateID = c.DateID
JOIN dbo.Dim_Mine m ON p.MineID = m.MineID
ORDER BY p.DateID, m.MineName;
```

## MDX Validation Queries (Run in SSMS against SSAS)

```mdx
/* Step 1 and 2: calculated measure + above-average mines set */
WITH
MEMBER [Measures].[Total Operating Cost ZAR] AS
	[Measures].[LaborCostZAR] + [Measures].[EquipmentCostZAR] +
	[Measures].[MaintenanceCostZAR] + [Measures].[SafetyCostZAR] +
	[Measures].[UtilitiesCostZAR] + [Measures].[OtherCostZAR]
MEMBER [Measures].[Cost Per Tonne] AS
	IIF([Measures].[TonnesProduced] = 0, NULL,
		[Measures].[Total Operating Cost ZAR] / [Measures].[TonnesProduced])
SET [Above Avg Production Mines] AS
	FILTER(
		[Mine].[Mine Name].[Mine Name].MEMBERS,
		[Measures].[TonnesProduced] > AVG([Mine].[Mine Name].[Mine Name].MEMBERS, [Measures].[TonnesProduced])
	)
SELECT
	{[Measures].[TonnesProduced], [Measures].[Cost Per Tonne]} ON COLUMNS,
	[Above Avg Production Mines] ON ROWS
FROM [Assmang Mining Analytics];
```

```mdx
/* Step 3 and 4: KPI-style target attainment view */
WITH
MEMBER [Measures].[Monthly Target Tonnes] AS 300000
MEMBER [Measures].[Target Attainment %] AS
	IIF([Measures].[Monthly Target Tonnes] = 0, NULL,
		[Measures].[TonnesProduced] / [Measures].[Monthly Target Tonnes])
SELECT
	{[Measures].[TonnesProduced], [Measures].[Monthly Target Tonnes], [Measures].[Target Attainment %]} ON COLUMNS,
	[Mine].[Mine Name].[Mine Name].MEMBERS ON ROWS
FROM [Assmang Mining Analytics]
WHERE ([Date].[Calendar Year].&[2024]);
```

---

*Assmang Pty Ltd — SSAS Fundamentals | Day 02 Practical Lab*
