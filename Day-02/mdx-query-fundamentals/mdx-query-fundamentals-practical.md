# Practical Lab — MDX Query Fundamentals
## Day 02 | Assmang Pty Ltd — SSAS Fundamentals

---

## 🎯 Lab Goal

Apply the theory from **MDX Query Fundamentals** by completing a guided, step-by-step exercise in SQL Server Data Tools (SSDT) and SQL Server Management Studio (SSMS).

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

### Step 1: Open SSMS against the SSAS instance and connect to the processed Assmang cube

**What to do:** Open SSMS against the SSAS instance and connect to the processed Assmang cube.

**Why this matters:** This step builds your understanding of mdx query fundamentals by giving you hands-on experience with the tool.

**Expected result:** You should see a successful outcome or confirmation in SSDT/SSMS before moving to the next step.

**Troubleshooting:** If this step fails, check:
- Is the SQL Server instance running?
- Is the dataset `v3_assmang_mining_complete.sql` loaded?
- Do you have the correct permissions?

---

### Step 2: Run a basic query returning `TonnesProduced` by mine

**What to do:** Run a basic query returning `TonnesProduced` by mine.

**Why this matters:** This step builds your understanding of mdx query fundamentals by giving you hands-on experience with the tool.

**Expected result:** You should see a successful outcome or confirmation in SSDT/SSMS before moving to the next step.

**Troubleshooting:** If this step fails, check:
- Is the SQL Server instance running?
- Is the dataset `v3_assmang_mining_complete.sql` loaded?
- Do you have the correct permissions?

---

### Step 3: Add a time slicer for calendar year 2024

**What to do:** Add a time slicer for calendar year 2024.

**Why this matters:** This step builds your understanding of mdx query fundamentals by giving you hands-on experience with the tool.

**Expected result:** You should see a successful outcome or confirmation in SSDT/SSMS before moving to the next step.

**Troubleshooting:** If this step fails, check:
- Is the SQL Server instance running?
- Is the dataset `v3_assmang_mining_complete.sql` loaded?
- Do you have the correct permissions?

---

### Step 4: Query revenue by commodity hierarchy level instead of by individual mine

**What to do:** Query revenue by commodity hierarchy level instead of by individual mine.

**Why this matters:** This step builds your understanding of mdx query fundamentals by giving you hands-on experience with the tool.

**Expected result:** You should see a successful outcome or confirmation in SSDT/SSMS before moving to the next step.

**Troubleshooting:** If this step fails, check:
- Is the SQL Server instance running?
- Is the dataset `v3_assmang_mining_complete.sql` loaded?
- Do you have the correct permissions?

---

### Step 5: Use a set to return only the iron ore mines

**What to do:** Use a set to return only the iron ore mines.

**Why this matters:** This step builds your understanding of mdx query fundamentals by giving you hands-on experience with the tool.

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

By the end of this lab, you should be able to demonstrate the core workflow for **MDX Query Fundamentals** in the Assmang training environment. You should be able to:

- Understand the structure of a basic MDX SELECT statement.
- Work with measures, members, sets, tuples, and slicers.
- Query the Assmang cube for common analytical views.
- Recognise how MDX differs from SQL thinking.

---

## 💡 Tips for Success

- **Read each step fully** before executing it.
- **Save your project** after each major step.
- **Ask questions** if something doesn't look right — it's better to clarify early.
- **Take notes** on what you observe — this helps with the assessment later.

## SQL Precheck (Run in SSMS Database Engine)

```sql
USE AssmangMining;
GO

SELECT
	m.MineName,
	SUM(fp.TonnesProduced) AS TotalTonnes,
	SUM(fp.RevenueZAR) AS TotalRevenueZAR
FROM dbo.FactProduction fp
JOIN dbo.Dim_Mine m ON fp.MineID = m.MineID
GROUP BY m.MineName
ORDER BY m.MineName;
```

## MDX Lab Queries (Run in SSMS against SSAS)

```mdx
/* Step 2: Tonnes by mine */
SELECT
	{[Measures].[TonnesProduced]} ON COLUMNS,
	[Mine].[Mine Name].[Mine Name].MEMBERS ON ROWS
FROM [Assmang Mining Analytics];
```

```mdx
/* Step 3: Add year slicer */
SELECT
	{[Measures].[TonnesProduced]} ON COLUMNS,
	[Mine].[Mine Name].[Mine Name].MEMBERS ON ROWS
FROM [Assmang Mining Analytics]
WHERE ([Date].[Calendar Year].&[2024]);
```

```mdx
/* Step 4: Revenue by commodity type */
SELECT
	{[Measures].[RevenueZAR]} ON COLUMNS,
	[Mine].[Mine Type].[Mine Type].MEMBERS ON ROWS
FROM [Assmang Mining Analytics]
WHERE ([Date].[Calendar Year].&[2024]);
```

```mdx
/* Step 5: Iron ore mines only */
WITH
SET [Iron Ore Mines] AS
	DESCENDANTS(
		[Mine].[Mine Type].&[Iron Ore],
		[Mine].[Mine Name].[Mine Name]
	)
SELECT
	{[Measures].[TonnesProduced], [Measures].[RevenueZAR]} ON COLUMNS,
	[Iron Ore Mines] ON ROWS
FROM [Assmang Mining Analytics];
```

---

*Assmang Pty Ltd — SSAS Fundamentals | Day 02 Practical Lab*
