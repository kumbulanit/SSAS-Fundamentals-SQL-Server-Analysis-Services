# Practical Lab — Performance Tuning and Optimization
## Day 02 | Assmang Pty Ltd — SSAS Fundamentals

---

## 🎯 Lab Goal

Apply the theory from **Performance Tuning and Optimization** by completing a guided, step-by-step exercise in SQL Server Data Tools (SSDT) and SQL Server Management Studio (SSMS).

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

### Step 1: Inspect storage mode and justify the default choice for this model

**Find the storage mode setting — it controls how SSAS stores cube data:**
1. In Visual Studio (SSDT), open the cube designer by double-clicking the cube in Solution Explorer.
2. In the Cube Designer, click the **Partition Manager** tab, or right-click the **Production** measure group in Cube Structure → **Properties**.
3. In the Properties panel, look for the `StorageMode` property. It should show **MOLAP**.

> ℹ️ **You can also check at the measure group level:** In Cube Structure tab, right-click the **Production** measure group → **Properties Window** (press F4 if it is not visible). The `StorageMode` property appears there.

4. Note that the three options are:
   - **MOLAP** — Data is pre-aggregated and stored in SSAS's own format. Fastest for queries. Requires processing to reflect source changes.
   - **ROLAP** — SSAS queries SQL directly at query time. No processing delay but slowest for large queries.
   - **HOLAP** — Aggregates in SSAS, detail data stays in SQL. Compromise option.

5. For Assmang daily reporting (stable, batch-loaded data loaded nightly), **MOLAP is correct**. Write one sentence explaining why: managers query yesterday's data, not real-time, so pre-aggregated storage is a good fit.

**Expected result:** You can find the `StorageMode = MOLAP` property in SSDT and explain why it suits a nightly-refresh reporting pattern.

**If something goes wrong:**
- If you cannot find the storage setting, check both the cube-level Properties and the measure group-level Properties panel (F4).
- If the property shows ROLAP, check whether the cube was deployed that way intentionally before changing it.

---

### Step 2: Review aggregation design for common production queries

**Open the Aggregation Design Wizard in SSDT:**
1. In Cube Structure tab, right-click the **Production** measure group → **Design Aggregations...**
2. The Aggregation Design Wizard opens. On the first page, leave the defaults and click **Next**.
3. On the **Specify Query Criteria** page, choose **Performance-Based** if you have query logs, or **Count-Based** for a new cube. For this lab, choose **Count-Based** and set the performance goal slider to **50%** of potential performance gain.
4. Click **Start** — the wizard analyses the attribute combinations and proposes aggregations.
5. When it finishes, click **Next** to review the proposed aggregations. You will see entries like:
   - `Mine.Mine Name × Date.Calendar Year` — fast for yearly totals by mine
   - `Mine.Mine Type × Date.Calendar Year` — fast for commodity summaries
6. Click **Finish** to save the design. This design is stored but **does not change query results** until the measure group is reprocessed.
7. In the Output window, after reprocessing: look for a line like `Aggregations: 14 aggregation(s) created`.

**What you are really testing:** Whether the cube is prepared for the kinds of grouped queries managers ask most often — mine × year, commodity × quarter, department × month.

**Expected result:** The wizard creates 10–20 aggregations for the Production measure group. You can explain that aggregations pre-compute subtotals so SSAS can skip scanning all rows for every grouped query.

**If something goes wrong:**
- If the **Design Aggregations** option is greyed out, make sure you right-clicked a measure group (not the cube itself).
- If the wizard runs but shows 0 aggregations, confirm the measure group has at least one dimension with a non-trivial hierarchy.

---

### Step 3: Compare a broad query and a narrow query before and after processing-related changes

**Use evidence instead of assumptions:**
1. Run the two MDX comparison queries in this lab.
2. Note how long they take and how dense the result set is.
3. Make the relevant processing or design adjustment for your experiment.
4. Process the affected objects again.
5. Rerun the same MDX queries.
6. Record whether the behaviour or user experience improved.

**What Microsoft guidance reinforces:** Processing is not optional housekeeping. It directly affects whether structural changes and optimisation changes are available for querying.

**Expected result:** You can describe how query breadth, processing state, and design choices combine to affect perceived performance.

**If something goes wrong:**
- If the comparison is inconclusive, reduce the variables and test one change at a time.
- If the cube becomes unqueryable, confirm no object was left unprocessed.
- If performance gets worse, document the outcome instead of hiding it.

---

### Step 4: Create a year-based partition for FactProduction

**Partitioning splits a measure group into smaller physical pieces so SSAS can skip irrelevant data:**
1. In Visual Studio (SSDT), click the **Partitions** tab in the Cube Designer.
2. You will see a single default partition for the Production measure group (usually named after the measure group with no date suffix).
3. Click **New Partition** button in the toolbar.
4. In the Partition Wizard:
   - **Name:** `Production_2024`
   - **Source type:** Table (keep the default)
   - **Fact table:** `FactProduction`
5. On the **Specify Processing and Storage Locations** page, accept defaults.
6. On the **Slice** page — this is the critical step for performance:
   - Select the **Date** dimension
   - Select the **Calendar Year** hierarchy
   - Click the `2024` member to set the slice
   - The slice expression shown will be: `[Date].[Calendar Year].&[2024]`
   - This tells SSAS: "this partition only contains 2024 data — skip it for any other year."
7. Click **Finish**.
8. Repeat to create `Production_2023` with the same steps but slice `[Date].[Calendar Year].&[2023]`.
9. Delete or rename the original default partition to `Production_Historical` and restrict it to years before 2023.

**Why this matters:** When a manager runs a 2024-only report, SSAS skips the 2023 partition entirely. The more rows in FactProduction, the bigger the saving.

**Expected result:** The Partitions tab shows 2–3 partitions for the Production measure group. After reprocessing, queries filtered by Calendar Year 2024 only scan the `Production_2024` partition.

**If something goes wrong:**
- If the **Slice** page does not appear, you may be missing the Date dimension on the Production measure group — check Dimension Usage first.
- If you create a partition without a slice, SSAS will not know which partition to skip and will scan all of them — always set the slice.

---

### Step 5: Document one realistic optimisation trade-off

**Close the lab by choosing, not just listing, an optimisation position:**
1. Pick one trade-off such as faster queries versus fresher data.
2. Describe the design choice that supports it.
3. State the downside clearly.
4. Tie the decision back to an Assmang reporting scenario.
5. Write the answer so a non-technical stakeholder could still understand it.

**Expected result:** You can explain that performance tuning is a business decision, not only a technical settings exercise.

**If something goes wrong:**
- If the answer sounds too generic, anchor it to one measure group or one dashboard use case.
- If you only describe the benefit, add the cost as well.
- If you cannot defend the trade-off, pick a narrower example and rewrite it.

---

## ✅ Validation Checklist

Before marking this lab as complete, confirm:

- [ ] v3 dataset loaded — `FactEquipmentEfficiency` and `FactSafetyKPI` both show > 0 rows
- [ ] `StorageMode = MOLAP` found in the Production measure group Properties panel in SSDT
- [ ] Aggregation Design Wizard ran and created 10+ aggregations for the Production measure group
- [ ] Partitions tab shows at least 2 partitions — `Production_2024` and `Production_2023` — each with a Calendar Year slice set
- [ ] MDX Query A (mine × month cross-join) returns ≥ 48 rows (4 mines × 12 months)
- [ ] MDX Query B (mine-only slice) returns 4 rows and you can explain why it should run faster than Query A
- [ ] You can name one benefit of MOLAP over ROLAP for Assmang's daily production reporting

---

## 🎓 Expected Outcome

By the end of this lab, you should be able to demonstrate the core workflow for **Performance Tuning and Optimization** in the Assmang training environment. You should be able to:

- Understand how storage mode and aggregation design affect performance.
- Recognise common causes of slow cube queries.
- Understand partitioning and caching at a beginner level.
- Apply practical optimisation decisions in an Assmang reporting context.

---

## 💡 Tips for Success

- **Read each step fully** before executing it.
- **Save your project** after each major step.
- **Ask questions** if something doesn't look right — it's better to clarify early.
- **Take notes** on what you observe — this helps with the assessment later.

## SQL Checks for Tuning Context (Run in SSMS Database Engine)

> ✅ **COPY AND PASTE each SQL block into a new SSMS query window. Set database to `AssmangMining` first.**

**Check 1 — Production row count by month (to see data volume):**

```sql
USE AssmangMining;
GO

SELECT
    d.[Year],
    d.[Month],
    COUNT(*) AS ProductionRows,
    SUM(fp.TonnesProduced) AS TotalTonnes
FROM dbo.FactProduction fp
JOIN dbo.Dim_Date d ON fp.DateID = d.DateID
GROUP BY d.[Year], d.[Month]
ORDER BY d.[Year], d.[Month];
```

**Check 2 — Equipment uptime and productivity by mine:**

```sql
SELECT
    m.MineName,
    AVG(ee.UpTimePercentage) AS AvgUpTimePct,
    AVG(ee.ProductivityTonnesPerHour) AS AvgProductivityTonnesPerHour
FROM dbo.FactEquipmentEfficiency ee
JOIN dbo.Dim_Mine m ON ee.MineID = m.MineID
GROUP BY m.MineName
ORDER BY AvgUpTimePct DESC;
```

---

## MDX Queries for Before/After Comparison (Run in SSMS against SSAS)

> ⚠️ **Before running MDX:** Open an MDX query window (Analysis Services connection → right-click database → New Query → MDX), then select `AssmangMiningAnalytics` from the toolbar dropdown.

> ℹ️ **About the `-- labels`:** Lines starting with `--` are comments (explanations only). They do NOT affect execution — you can include them or remove them.

---

**Query A — Broad cross-join scan (mine × month):**

> ✅ COPY THIS ENTIRE BLOCK:

```mdx
-- Query A: broad scan — all mines × all months
-- Useful for seeing the maximum row count in a result
SELECT
    { [Measures].[TonnesProduced], [Measures].[RevenueZAR] } ON COLUMNS,
    NON EMPTY
        CROSSJOIN(
            [Mine].[Mine Name].[Mine Name].MEMBERS,
            [Date].[Month Name].[Month Name].MEMBERS
        ) ON ROWS
FROM [Assmang Mining Analytics]
WHERE ( [Date].[Calendar Year].&[2024] );
```

> 📸 **Expected result:** A dense grid with one row per Mine-Month combination (up to ~48 rows for 4 mines × 12 months). Note how long this takes — this is your "before" benchmark.

---

**Query B — Narrow slice (mine only, no month breakdown):**

> ✅ COPY THIS ENTIRE BLOCK:

```mdx
-- Query B: narrow slice — mines only, no month detail
-- Compare this response time to Query A
SELECT
    { [Measures].[TonnesProduced], [Measures].[RevenueZAR] } ON COLUMNS,
    [Mine].[Mine Name].[Mine Name].MEMBERS ON ROWS
FROM [Assmang Mining Analytics]
WHERE ( [Date].[Calendar Year].&[2024] );
```

> 📸 **Expected result:** A short grid (4–5 rows). Compare the execution time to Query A. Query B should return faster because fewer cells are needed — this demonstrates why aggregations help.

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
