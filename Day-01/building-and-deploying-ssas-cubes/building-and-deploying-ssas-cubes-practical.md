# Practical Lab — Building and Deploying SSAS Cubes
## Day 01 | Assmang Pty Ltd — SSAS Fundamentals

---

## 🎯 Lab Goal

Apply the theory from **Building and Deploying SSAS Cubes** by completing a guided, step-by-step exercise in SQL Server Data Tools (SSDT) and SQL Server Management Studio (SSMS).

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

### Step 1: Open the SSAS project and confirm the data source points to `AssmangMining`

**What to do:** Open the SSAS project and confirm the data source points to `AssmangMining`.

**Why this matters:** This step builds your understanding of building and deploying ssas cubes by giving you hands-on experience with the tool.

**Expected result:** You should see a successful outcome or confirmation in SSDT/SSMS before moving to the next step.

**Troubleshooting:** If this step fails, check:
- Is the SQL Server instance running?
- Is the dataset `v2_assmang_mining_extended.sql` loaded?
- Do you have the correct permissions?

---

### Step 2: Add all v2 dimensions and measure groups to a single cube named `Assmang Mining Analytics`

**What to do:** Add all v2 dimensions and measure groups to a single cube named `Assmang Mining Analytics`.

**Why this matters:** This step builds your understanding of building and deploying ssas cubes by giving you hands-on experience with the tool.

**Expected result:** You should see a successful outcome or confirmation in SSDT/SSMS before moving to the next step.

**Troubleshooting:** If this step fails, check:
- Is the SQL Server instance running?
- Is the dataset `v2_assmang_mining_extended.sql` loaded?
- Do you have the correct permissions?

---

### Step 3: Review cube dimension usage so that relationships are correctly mapped

**What to do:** Review cube dimension usage so that relationships are correctly mapped.

**Why this matters:** This step builds your understanding of building and deploying ssas cubes by giving you hands-on experience with the tool.

**Expected result:** You should see a successful outcome or confirmation in SSDT/SSMS before moving to the next step.

**Troubleshooting:** If this step fails, check:
- Is the SQL Server instance running?
- Is the dataset `v2_assmang_mining_extended.sql` loaded?
- Do you have the correct permissions?

---

### Step 4: Deploy the cube to the training SSAS instance and process it fully

**What to do:** Deploy the cube to the training SSAS instance and process it fully.

**Why this matters:** This step builds your understanding of building and deploying ssas cubes by giving you hands-on experience with the tool.

**Expected result:** You should see a successful outcome or confirmation in SSDT/SSMS before moving to the next step.

**Troubleshooting:** If this step fails, check:
- Is the SQL Server instance running?
- Is the dataset `v2_assmang_mining_extended.sql` loaded?
- Do you have the correct permissions?

---

### Step 5: Use the cube browser to confirm that production and cost metrics can be sliced by mine and time

**What to do:** Use the cube browser to confirm that production and cost metrics can be sliced by mine and time.

**Why this matters:** This step builds your understanding of building and deploying ssas cubes by giving you hands-on experience with the tool.

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

By the end of this lab, you should be able to demonstrate the core workflow for **Building and Deploying SSAS Cubes** in the Assmang training environment. You should be able to:

- Understand the end-to-end workflow for building a multidimensional cube in SSDT.
- Create a cube from data source, DSV, dimensions, and measure groups.
- Deploy and process a cube to an SSAS instance.
- Perform validation checks before handing the cube to users.

---

## 💡 Tips for Success

- **Read each step fully** before executing it.
- **Save your project** after each major step.
- **Ask questions** if something doesn't look right — it's better to clarify early.
- **Take notes** on what you observe — this helps with the assessment later.

## SQL Validation Queries (Run in SSMS)

Use these SQL checks before deployment and processing:

```sql
USE AssmangMining;
GO

SELECT
	t.name AS TableName,
	p.rows AS ApproxRowCount
FROM sys.tables t
JOIN sys.partitions p ON t.object_id = p.object_id AND p.index_id IN (0, 1)
WHERE t.name IN ('Dim_Mine', 'Dim_Date', 'FactProduction', 'FactOperatingCosts')
ORDER BY t.name;
```

```sql
SELECT TOP (20)
	m.MineName,
	d.[Year],
	d.[Month],
	fp.TonnesProduced,
	fp.RevenueZAR
FROM dbo.FactProduction fp
JOIN dbo.Dim_Mine m ON fp.MineID = m.MineID
JOIN dbo.Dim_Date d ON fp.DateID = d.DateID
ORDER BY d.[Year], d.[Month], m.MineName;
```

```sql
SELECT
	COUNT(*) AS OrphanRows
FROM dbo.FactOperatingCosts oc
LEFT JOIN dbo.Dim_Mine m ON oc.MineID = m.MineID
LEFT JOIN dbo.Dim_Department dp ON oc.DepartmentID = dp.DepartmentID
LEFT JOIN dbo.Dim_Date dd ON oc.DateID = dd.DateID
WHERE m.MineID IS NULL OR dp.DepartmentID IS NULL OR dd.DateID IS NULL;
```

---

*Assmang Pty Ltd — SSAS Fundamentals | Day 01 Practical Lab*
