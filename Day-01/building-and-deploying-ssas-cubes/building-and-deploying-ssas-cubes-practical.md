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

### Step 1: Open the project and verify the source connection before deployment work begins

**Treat this as a pre-flight check:**
1. Open `AssmangMiningCube` in Visual Studio.
2. Expand **Data Sources** and open the data source.
3. Confirm the connection targets the correct SQL Server instance and the `AssmangMining` database.
4. Click **Test Connection**.
5. Open the DSV and verify it still includes the v2 fact and dimension tables.
6. Save if any corrections were needed.

**Why this step matters:** If the source connection is wrong, every later step can appear to work while still producing the wrong analytical model.

**Expected result:** The project points to the right relational source and is safe to build on.

**If something goes wrong:**
- If Test Connection fails, fix that before touching cube objects.
- If the DSV is missing v2 tables, update it now.
- If someone changed the connection to a different machine, document that before proceeding.

> 📸 **Screenshot Checkpoint 1 — Data Source connection screen:**
> Double-clicking the `.ds` file opens the Data Source Designer. Look for:
> - Connection string showing your server name and `AssmangMining`
> - An **Edit** button (to change connection details)
> - A **Test Connection** button
> After clicking Test Connection, a popup should say "Test connection succeeded."

---

### Step 2: Confirm the cube contains the full v2 business model

**Build or review the cube deliberately:**
1. Open the cube designer for `Assmang Mining Analytics`.
2. Check whether the cube already has measure groups. If it does, skip to the screenshot check below. If it does not exist yet, follow the Cube Wizard steps below.

**If you need to create the cube from scratch (Cube Wizard):**
1. In Solution Explorer, right-click **Cubes** → **New Cube**
2. On the "Select Creation Method" page, choose **Use existing tables**
3. On the "Select Measure Group Tables" page, tick **both** fact tables:
   - `FactProduction` ← this becomes the Production measure group
   - `FactOperatingCosts` ← this becomes the Operating Costs measure group
4. On the "Select Measures" page, keep these and **uncheck** any surrogate keys (columns ending in ID):
   - From FactProduction: `TonnesProduced`, `RevenueZAR`, `Grade`
   - From FactOperatingCosts: `LaborCostZAR`, `MaintenanceCostZAR`, `EquipmentCostZAR`
5. On the "Select Existing Dimensions" page, tick all four: **Mine, Date, Department, Employee**
6. Set the cube name to **`Assmang Mining Analytics`**
7. Click **Finish**

**Verify the cube structure:**
- Confirm the cube name is `Assmang Mining Analytics` (business-friendly)
- Confirm both measure groups are present
- If names are too technical (e.g., `FactProduction` instead of `Production`), right-click the measure group → **Rename**

**Expected result:** One coherent cube contains both measure groups and all four dimensions.

**If something goes wrong:**
- If only one measure group appears, right-click the Measures panel → **New Measure Group** → select the missing fact table.
- If dimensions are missing from the right panel, right-click the dimension panel → **Add Cube Dimension** and select from the project.
- If names are confusing, fix captions before deployment — users should not see warehouse-style table names.

> 📸 **Screenshot Checkpoint 2 — Cube Structure tab showing both measure groups:**
> The Cube Structure tab left panel shows:
> ```
> ▼ Measures
>   ▼ Production
>       Tonnes Produced
>       Revenue (ZAR)
>       Grade
>   ▼ Operating Costs
>       Labor Cost (ZAR)
>       Maintenance Cost (ZAR)
>       Equipment Cost (ZAR)
> ```
> Right panel shows 4 dimension boxes connected to the cube. If you see only one measure group, add the second fact table via right-click → New Measure Group.

---

### Step 3: Review dimension usage so filters reach the right measure groups

**This is where many beginner projects break:**
1. Open the **Dimension Usage** tab in the cube designer.
2. Look at the grid — rows are dimensions, columns are measure groups.
3. Every cell that should filter must show **Regular**. Empty = no relationship = the dimension cannot filter that measure group.
4. Use the table below to verify each relationship. If a cell is empty, click it → **Edit Relationship** → set the relationship type and the matching key columns:

| Dimension | Fact Table Column | Dimension Column | Expected cell |
|-----------|-----------------|-----------------|---------------|
| Mine Dimension | `FactProduction.MineID` | `Dim_Mine.MineID` | Regular |
| Mine Dimension | `FactOperatingCosts.MineID` | `Dim_Mine.MineID` | Regular |
| Date Dimension | `FactProduction.DateID` | `Dim_Date.DateID` | Regular |
| Date Dimension | `FactOperatingCosts.DateID` | `Dim_Date.DateID` | Regular |
| Department Dimension | `FactOperatingCosts.DepartmentID` | `Dim_Department.DepartmentID` | Regular |

> ⚠️ **Department does NOT link to FactProduction in the v2 dataset** — this is expected. FactProduction has no DepartmentID column. Leave that cell empty.

**How to fix an empty cell:**
1. Click the empty cell in the Dimension Usage grid
2. Click the small button that appears (pencil/edit icon)
3. In the relationship dialog, set:
   - **Relationship type:** Regular
   - **Granularity attribute:** the fact-table foreign key column (e.g., `MineID`)
   - **Dimension columns:** the dimension key column (e.g., `Dim_Mine.MineID`)
4. Click OK → Save

**Expected result:** Dimension filters map correctly to the measure groups and the cube is ready for processing.

**If something goes wrong:**
- If a relationship cell is empty, revisit the DSV and check the foreign-key paths.
- If browsing later shows repeated totals on every row, this tab is a primary suspect.
- If you are unsure about a relationship type, prefer fixing the source model rather than guessing.

> 📸 **Screenshot Checkpoint 3 — Dimension Usage tab:**
> The Dimension Usage tab shows a grid where:
> - Rows = Dimensions (Mine, Date, Department, Employee)
> - Columns = Measure Groups (Production, Operating Costs)
> - Each cell = the relationship type
> ```
>                    Production    Operating Costs
> Mine Dimension     Regular       Regular
> Date Dimension     Regular       Regular
> Department Dim     (empty)       Regular
> Employee Dim       (empty)       (empty)
> ```
> Empty cells for Employee are expected — FactProduction and FactOperatingCosts don't join to employees directly in v2.

---

### Step 4: Deploy the cube and process it fully

**Follow the SSAS deployment sequence exactly:**
1. Right-click the project and open **Properties > Deployment**.
2. Confirm the SSAS deployment server and target database name.
3. Run **Build > Build Solution**.
4. Fix build errors before you deploy.
5. Right-click the project and choose **Deploy**.
6. Watch the Output window. During deployment, SSDT builds the project, validates the destination server, and creates or updates the database objects.
7. After deployment, process the cube fully.
8. Wait for the processing dialog to finish successfully before you try to browse.

**What Microsoft guidance adds here:** Browsing requires a deployed and processed cube. A deployed-but-unprocessed cube is not ready for analytical use.

**Expected result:** The cube exists on the SSAS server and is fully queryable.

**If something goes wrong:**
- If deployment fails, verify server name and SSAS permissions.
- If processing fails, check data-source impersonation and relational read access.
- If you changed structure after a prior deployment, remember that reprocessing may be required before browsing works again.

> 📸 **Screenshot Checkpoint 4 — Output window after successful deploy + process:**
> **Deploy log (Output window):**
> ```
> Deployment completed successfully.
> ```
> **Process log:**
> All objects in the Process dialog should show "Success". If the dialog shows any "Error" rows, click them to read the detail before dismissing the dialog.

---

### Step 5: Browse the cube and validate business slices before sign-off

**Use both browser logic and business logic:**
1. Open the Browser tab in the cube designer.
2. Drag a production measure such as `Tonnes Produced` into the data area.
3. Add `Mine Name` to rows.
4. Add a time hierarchy or month-level attribute so you can see the trend over time.
5. Add one operating-cost measure and confirm the slice changes when you move across mines or dates.
6. Compare the browser totals against the SQL validation queries in this lab.
7. Run the MDX validation query below in SSMS to confirm the cube returns the expected mine-level numbers.

**Expected result:** The cube returns believable mine-by-time views for both production and costs.

**If something goes wrong:**
- If the browser tab shows no data, process the cube again.
- If every row shows the same value, revisit Dimension Usage.
- If the cube browser works but SSMS MDX does not, reconnect to Analysis Services and verify you are querying the same database.

---

## MDX Validation Query (Run in SSMS against SSAS after Step 4)

> ⚠️ **Before running MDX:** Open an MDX query window (Analysis Services connection → right-click database → New Query → MDX), then select `AssmangMiningAnalytics` from the toolbar dropdown.

> ✅ **COPY THIS ENTIRE BLOCK:**

```mdx
-- Validate cube: Tonnes Produced by mine for 2024
-- Compare results to your SQL validation query from Check 2
SELECT
    { [Measures].[Tonnes Produced], [Measures].[Revenue (ZAR)] } ON COLUMNS,
    [Mine].[Mine Name].[Mine Name].MEMBERS ON ROWS
FROM [Assmang Mining Analytics]
WHERE ( [Date].[Calendar Year].&[2024] );
```

> 📸 **Expected MDX result:** A grid with one row per mine, showing 2024 totals:
> ```
> Mine Name          Tonnes Produced    Revenue (ZAR)
> Beeshoek Mine      32,500             18,200,000
> Black Rock Mine    28,100             12,600,000
> Dwarsrivier Mine   15,600              9,500,000
> Khumani Mine       45,200             28,500,000
> ```
> Compare Khumani Mine's TonnesProduced here to the SQL query result from **Check 2**. The numbers should match. If they differ significantly, the dimension relationships in Step 3 may be wrong.

---

## ✅ Validation Checklist

Before marking this lab as complete, confirm:

- [ ] v2 dataset loaded — `FactProduction` and `FactOperatingCosts` both show > 0 rows in the table counts query
- [ ] Orphan rows check returns 0 — no fact rows are missing their dimension joins
- [ ] Cube has two measure groups visible in Cube Structure tab: **Production** and **Operating Costs**
- [ ] Dimension Usage tab shows "Regular" in all expected cells (Mine × Production, Mine × Costs, Date × Production, Date × Costs)
- [ ] Deployment and processing completed without errors in the Output window
- [ ] MDX validation query returns Khumani Mine with TonnesProduced matching the SQL Check 2 result

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

> ✅ **COPY AND PASTE each SQL block into a new SSMS query window. Set database to `AssmangMining` first.**

**Check 1 — Row counts for the 4 key tables:**

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

> 📸 **Expected result:** 4 rows each with ApproxRowCount > 0. If FactProduction or FactOperatingCosts shows 0, the v2 dataset is missing — reload it first.

**Check 2 — Sample production data (top 20 rows):**

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

**Check 3 — Orphan rows check (data quality):**

```sql
SELECT
    COUNT(*) AS OrphanRows
FROM dbo.FactOperatingCosts oc
LEFT JOIN dbo.Dim_Mine m ON oc.MineID = m.MineID
LEFT JOIN dbo.Dim_Department dp ON oc.DepartmentID = dp.DepartmentID
LEFT JOIN dbo.Dim_Date dd ON oc.DateID = dd.DateID
WHERE m.MineID IS NULL OR dp.DepartmentID IS NULL OR dd.DateID IS NULL;
```

> 📸 **Expected result:** OrphanRows = 0. Any value > 0 means fact rows cannot be joined to a dimension — these rows will be invisible in the cube until the data is fixed.

---

*Assmang Pty Ltd — SSAS Fundamentals | Day 01 Practical Lab*

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
