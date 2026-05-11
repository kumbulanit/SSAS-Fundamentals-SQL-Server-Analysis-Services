# Practical Lab — Multidimensional Models and Dimensions
## Day 01 | Assmang Pty Ltd — SSAS Fundamentals

---

## 🎯 Lab Goal

Apply the theory from **Multidimensional Models and Dimensions** by completing a guided, step-by-step exercise in SQL Server Data Tools (SSDT) and SQL Server Management Studio (SSMS).

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

### Step 1: Use the Data Source View from Topic 1 and run the Dimension Wizard for `Dim_Mine`

**What to do:** Use the Data Source View from Topic 1 and run the Dimension Wizard for `Dim_Mine`.

**Why this matters:** This step builds your understanding of multidimensional models and dimensions by giving you hands-on experience with the tool.

**Expected result:** You should see a successful outcome or confirmation in SSDT/SSMS before moving to the next step.

**Troubleshooting:** If this step fails, check:
- Is the SQL Server instance running?
- Is the dataset `v1_assmang_mining_base.sql` loaded?
- Do you have the correct permissions?

---

### Step 2: Set `MineID` as the key attribute and `MineName` as the name column

**What to do:** Set `MineID` as the key attribute and `MineName` as the name column.

**Why this matters:** This step builds your understanding of multidimensional models and dimensions by giving you hands-on experience with the tool.

**Expected result:** You should see a successful outcome or confirmation in SSDT/SSMS before moving to the next step.

**Troubleshooting:** If this step fails, check:
- Is the SQL Server instance running?
- Is the dataset `v1_assmang_mining_base.sql` loaded?
- Do you have the correct permissions?

---

### Step 3: Add attributes for `MineType`, `Province`, and `EstablishedYear`

**What to do:** Add attributes for `MineType`, `Province`, and `EstablishedYear`.

**Why this matters:** This step builds your understanding of multidimensional models and dimensions by giving you hands-on experience with the tool.

**Expected result:** You should see a successful outcome or confirmation in SSDT/SSMS before moving to the next step.

**Troubleshooting:** If this step fails, check:
- Is the SQL Server instance running?
- Is the dataset `v1_assmang_mining_base.sql` loaded?
- Do you have the correct permissions?

---

### Step 4: Create a user hierarchy `Mine Type > Province > Mine Name` and process the dimension

**What to do:** Create a user hierarchy `Mine Type > Province > Mine Name` and process the dimension.

**Why this matters:** This step builds your understanding of multidimensional models and dimensions by giving you hands-on experience with the tool.

**Expected result:** You should see a successful outcome or confirmation in SSDT/SSMS before moving to the next step.

**Troubleshooting:** If this step fails, check:
- Is the SQL Server instance running?
- Is the dataset `v1_assmang_mining_base.sql` loaded?
- Do you have the correct permissions?

---

### Step 5: Repeat the exercise for `Dim_Date` and create the `Year > Quarter > Month > Day` hierarchy

**What to do:** Repeat the exercise for `Dim_Date` and create the `Year > Quarter > Month > Day` hierarchy.

**Why this matters:** This step builds your understanding of multidimensional models and dimensions by giving you hands-on experience with the tool.

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

By the end of this lab, you should be able to demonstrate the core workflow for **Multidimensional Models and Dimensions** in the Assmang training environment. You should be able to:

- Understand star-schema thinking and how dimensions support analysis.
- Design dimensions from the Assmang dimension tables.
- Build hierarchies that support drill-down navigation.
- Recognise common dimension design issues such as poor keys or weak hierarchies.

---

## 💡 Tips for Success

- **Read each step fully** before executing it.
- **Save your project** after each major step.
- **Ask questions** if something doesn't look right — it's better to clarify early.
- **Take notes** on what you observe — this helps with the assessment later.

## SQL Validation Queries (Run in SSMS)

Use these checks to confirm your dimension data is hierarchy-ready:

```sql
USE AssmangMining;
GO

SELECT
	MineType,
	Province,
	COUNT(*) AS MineCount
FROM dbo.Dim_Mine
GROUP BY MineType, Province
ORDER BY MineType, Province;
```

```sql
SELECT
	[Year],
	[Quarter],
	COUNT(*) AS DaysInQuarter
FROM dbo.Dim_Date
GROUP BY [Year], [Quarter]
ORDER BY [Year], [Quarter];
```

```sql
SELECT
	SUM(CASE WHEN MineName IS NULL THEN 1 ELSE 0 END) AS NullMineName,
	SUM(CASE WHEN MineType IS NULL THEN 1 ELSE 0 END) AS NullMineType,
	SUM(CASE WHEN Province IS NULL THEN 1 ELSE 0 END) AS NullProvince
FROM dbo.Dim_Mine;
```

---

*Assmang Pty Ltd — SSAS Fundamentals | Day 01 Practical Lab*
