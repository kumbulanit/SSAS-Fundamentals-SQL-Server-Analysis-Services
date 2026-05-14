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

### Step 1: Load the full v3 dataset and verify the model is complete enough for executive reporting

**Start by confirming scope, not just table existence:**
1. Run `v3_assmang_mining_complete.sql` in SSMS if it has not already been applied.
2. Execute the SQL validation pack in this lab.
3. Confirm that the base dimensions and all advanced fact tables are populated.
4. Pay special attention to `FactEquipmentEfficiency`, `FactSafetyKPI`, and `FactEmployeeMetrics` because this topic depends on them.
5. Note any obvious data gaps before you open the cube project.

**Expected result:** The relational source contains the production, cost, safety, equipment, and workforce data needed for a business-ready SSAS solution.

**If something goes wrong:**
- If one fact table is empty, do not continue as if the implementation were complete.
- If the SQL pack returns missing objects, rerun the dataset load.
- If the data looks inconsistent across mine names or dates, document that because it will affect trust in the cube later.

---

### Step 2: Review the cube as a full business solution, not just a technical artifact

**Open the project and inspect the model end to end:**
1. Open the cube designer.
2. Verify that all major measure groups are present.
3. Confirm the dimensions required for executive slicing are attached and usable.
4. Review whether captions, hierarchy names, and measure names are business-friendly.
5. Inspect the Browser tab metadata to see whether the model looks like something an executive dashboard could consume.

**What you should be able to explain:** This cube is no longer a classroom object only. It is intended to answer production, cost, safety, and workforce questions in one analytical surface.

**Expected result:** The cube structure supports a realistic executive reporting conversation.

**If something goes wrong:**
- If measure groups are missing, revisit the DSV and cube design before continuing.
- If names are too technical, clean them now because executive users should not see warehouse-style jargon.
- If the browser metadata looks chaotic, improve organisation before writing MDX or KPIs.

---

### Step 3: Create or validate KPI coverage across production, cost, and safety

**Use KPIs to turn numbers into management signals:**
1. Choose one production KPI, one cost KPI, and one safety KPI.
2. For each KPI, define the actual measure, the goal, and how status should be interpreted.
3. Make sure the KPI names read clearly in business language.
4. Save and process any changed objects.
5. Verify that the KPI can be surfaced in browsing or MDX.

**What good KPI design looks like:** A manager should understand whether performance is acceptable, not just see another raw number.

**Expected result:** The cube exposes at least one meaningful management signal in each of the three major operational areas.

**If something goes wrong:**
- If the KPI is mathematically correct but meaningless, change the business framing.
- If a KPI does not show after processing, confirm it was created in the correct object and the cube was reprocessed.
- If the goal is arbitrary, state the assumption clearly.

---

### Step 4: Run executive-style MDX queries and compare them to business expectations

**Use the MDX pack as a management review simulation:**
1. Connect to SSAS in SSMS.
2. Run the executive production and revenue query.
3. Run the safety and efficiency query.
4. Run the workforce query.
5. For each one, write a one-sentence interpretation as if you were briefing management.
6. Compare the numbers with the SQL validation pack where useful.

**What this step proves:** The cube is not useful because it was deployed. It is useful because it can answer realistic executive questions correctly and quickly.

**Expected result:** You can produce clear answers about mine performance, safety posture, and workforce signals from the cube.

**If something goes wrong:**
- If MDX fails while the Browser tab works, inspect member and measure paths carefully.
- If query results look implausible, compare against the SQL baseline before blaming MDX.
- If executive questions require too much technical translation, improve captions or calculations.

---

### Step 5: Write a maintenance and release plan for the cube

**Finish like a production-minded BI engineer:**
1. Document how often the cube should be processed.
2. Note who should monitor failed processing, missing data, or broken queries.
3. Define what business sign-off should look like after a release.
4. Include at least one validation step after deployment and one validation step after processing.
5. Note the risk of leaving objects unprocessed or source permissions misconfigured.

**What Microsoft guidance reinforces:** Structural changes, aggregation changes, and refreshed data can all require reprocessing. A release plan is incomplete if it ignores that.

**Expected result:** You have a simple but realistic runbook that covers technical refresh, validation, and business approval.

**If something goes wrong:**
- If the plan only says "process the cube daily," it is too thin.
- If there is no owner for failures, add one.
- If business sign-off is missing, the cube may be technically correct but operationally untrusted.

---

## ✅ Validation Checklist

Before marking this lab as complete, confirm:

- [ ] v3 dataset loaded — all 9 tables show RowCount > 0 (including FactEquipmentEfficiency, FactSafetyKPI, FactEmployeeMetrics)
- [ ] Executive Query 1 returns 4–5 mines with non-zero TonnesProduced and non-zero Revenue (ZAR)
- [ ] Executive Query 2 returns ComplianceScore values between 0 and 100 for each mine
- [ ] Executive Query 3 returns attendance % between 0% and 100% per department
- [ ] You can describe in one sentence what each executive query tells a mine manager
- [ ] You can explain the difference between "deployed but unprocessed" (structure exists, cube returns empty/stale) and "deployed and processed" (cube returns current data)

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

> ✅ **COPY AND PASTE each SQL block into a new SSMS query window. Set database to `AssmangMining` first.**

**Check 1 — Row counts for all 9 tables:**

```sql
USE AssmangMining;
GO

SELECT 'Dim_Mine'                AS TableName, COUNT(*) AS RowCount FROM dbo.Dim_Mine
UNION ALL SELECT 'Dim_Department',              COUNT(*) FROM dbo.Dim_Department
UNION ALL SELECT 'Dim_Employee',                COUNT(*) FROM dbo.Dim_Employee
UNION ALL SELECT 'Dim_Date',                    COUNT(*) FROM dbo.Dim_Date
UNION ALL SELECT 'FactProduction',              COUNT(*) FROM dbo.FactProduction
UNION ALL SELECT 'FactOperatingCosts',          COUNT(*) FROM dbo.FactOperatingCosts
UNION ALL SELECT 'FactEquipmentEfficiency',     COUNT(*) FROM dbo.FactEquipmentEfficiency
UNION ALL SELECT 'FactSafetyKPI',               COUNT(*) FROM dbo.FactSafetyKPI
UNION ALL SELECT 'FactEmployeeMetrics',         COUNT(*) FROM dbo.FactEmployeeMetrics;
```

> 📸 **Expected result:** 9 rows — one per table, all with RowCount > 0. If any table shows 0, the v3 dataset did not load completely. Reload `datasets/v3_assmang_mining_complete.sql` and re-run.

**Check 2 — Summary by mine across all data areas:**

```sql
SELECT
    m.MineName,
    SUM(fp.TonnesProduced)    AS TotalTonnes,
    SUM(fp.RevenueZAR)        AS TotalRevenueZAR,
    AVG(sk.ComplianceScore)   AS AvgComplianceScore
FROM dbo.Dim_Mine m
LEFT JOIN dbo.FactProduction fp ON m.MineID = fp.MineID
LEFT JOIN dbo.FactSafetyKPI sk ON m.MineID = sk.MineID
GROUP BY m.MineName
ORDER BY TotalRevenueZAR DESC;
```

---

## Executive MDX Query Pack (Run in SSMS against SSAS)

> ⚠️ **Before running MDX:** Open an MDX query window (Analysis Services connection → right-click database → New Query → MDX), then select `AssmangMiningAnalytics` from the toolbar dropdown.

> ℹ️ **About the `-- labels`:** Lines starting with `--` are comments. They explain what the query does but **do not affect the result** — you can include them or remove them.

---

**Executive Query 1 — Production and revenue by mine:**

> ✅ COPY THIS ENTIRE BLOCK:

```mdx
-- Executive view: production + revenue per mine, 2024
SELECT
    { [Measures].[TonnesProduced], [Measures].[RevenueZAR] } ON COLUMNS,
    [Mine].[Mine Name].[Mine Name].MEMBERS ON ROWS
FROM [Assmang Mining Analytics]
WHERE ( [Date].[Calendar Year].&[2024] );
```

> 📸 **Expected result:** A grid with each mine's 2024 tonnes and revenue. Write one sentence for each number as if briefing management: "Khumani Mine produced X tonnes generating R Y in revenue in 2024."

---

**Executive Query 2 — Safety compliance and equipment uptime:**

> ✅ COPY THIS ENTIRE BLOCK:

```mdx
-- Executive view: safety + equipment efficiency per mine
SELECT
    { [Measures].[ComplianceScore], [Measures].[UpTimePercentage] } ON COLUMNS,
    [Mine].[Mine Name].[Mine Name].MEMBERS ON ROWS
FROM [Assmang Mining Analytics];
```

> 📸 **Expected result:** A grid showing safety compliance % and equipment uptime % per mine. Any mine below 80% uptime is a concern — flag it in your documentation.

---

**Executive Query 3 — Workforce attendance and overtime by department:**

> ✅ COPY THIS ENTIRE BLOCK:

```mdx
-- Executive view: workforce metrics by department, 2024
SELECT
    { [Measures].[AttendancePercentage], [Measures].[OvertimeHours] } ON COLUMNS,
    [Department].[Department Name].[Department Name].MEMBERS ON ROWS
FROM [Assmang Mining Analytics]
WHERE ( [Date].[Calendar Year].&[2024] );
```

> 📸 **Expected result:** A grid showing each department's attendance rate and overtime hours. Departments with low attendance AND high overtime are a workforce planning signal worth noting.

---

*Assmang Pty Ltd — SSAS Fundamentals | Day 02 Practical Lab*

---

## 🧰 Quick Reference

### Open an MDX Query Window in SSMS
1. Connect to **Analysis Services** in Object Explorer
2. Right-click **AssmangMiningAnalytics** → **New Query → MDX**
3. Select **`AssmangMiningAnalytics`** from the toolbar dropdown **before** typing any MDX
4. Press **F5** to run

### Build and Deploy in Visual Studio (SSDT)
1. **Build:** Build → Build Solution → wait for "Build succeeded" (0 errors)
2. **Deploy:** Right-click project → Deploy → wait for "Deployment completed successfully"
3. **Process:** SSMS → Analysis Services connection → right-click database → Process → Run → wait for all Success rows

### Key Menu Paths
- New SQL query: SSMS toolbar → **New Query**
- Connect to SSAS: SSMS Object Explorer → **Connect → Analysis Services**
- Open MDX query: SSAS connection → right-click database → **New Query → MDX**
- Cube browser: Visual Studio → Cube Designer → **Browser** tab

### Evidence Standard
- Include **input + output + explanation** for each major task
- Explanations should answer: what changed, what you observed, and why it matters for Assmang
- Prefer short and precise evidence over long screenshots with no commentary
