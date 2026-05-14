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
2. Verify that the measure groups for production and operating costs are present.
3. Confirm the business dimensions required for slicing are attached to the cube.
4. Check that the cube name is business-friendly and consistent across the project.
5. If the cube does not exist yet, use the Cube Wizard to create it with the v2 fact tables.

**What you should be able to say after this step:** This cube is the analytical surface the business will query, and it contains the facts and dimensions needed for mine, time, and department analysis.

**Expected result:** One coherent cube contains the v2 analytical content rather than scattered partial objects.

**If something goes wrong:**
- If the measure groups are incomplete, revisit the Cube Wizard or cube structure.
- If dimensions are missing, make sure they exist in the project and then add them to the cube.
- If names are confusing, fix captions before deployment so users do not inherit messy labels.

> 📸 **Screenshot Checkpoint 2 — Cube Structure tab showing both measure groups:**
> The Cube Structure tab left panel shows:
> ```
> ▼ Measures
>   ▼ Production
>       TonnesProduced
>       RevenueZAR
>       Grade
>   ▼ Operating Costs
>       LaborCostZAR
>       MaintenanceCostZAR
>       EquipmentCostZAR
> ```
> Right panel shows dimension boxes connected to the cube. If you see only one measure group, the second fact table needs to be added via right-click → New Measure Group.

---

### Step 3: Review dimension usage so filters reach the right measure groups

**This is where many beginner projects break:**
1. Open the **Dimension Usage** tab in the cube designer.
2. Look at each intersection between a dimension and a measure group.
3. Confirm regular relationships exist where the foreign-key design supports them.
4. Pay particular attention to `Dim_Date`, `Dim_Mine`, and `Dim_Department` because those dimensions drive most browsing in this course.
5. If a relationship is missing or incorrect, edit it now.
6. Save the cube before moving on.

**What you are verifying:** When a learner filters by mine or month, the measures should genuinely change because the cube knows how the dimensions relate to the fact tables.

**Expected result:** Dimension filters map correctly to the measure groups and the cube is ready for meaningful processing.

**If something goes wrong:**
- If a relationship cell is empty, revisit the DSV and fact-to-dimension key paths.
- If browsing later shows repeated totals on every row, this tab is a primary suspect.
- If you are unsure about a relationship type, prefer fixing the source model rather than guessing in the cube designer.

> 📸 **Screenshot Checkpoint 3 — Dimension Usage tab:**
> The Dimension Usage tab shows a grid where:
> - Rows = Dimensions (Mine, Date, Department, Employee)
> - Columns = Measure Groups (Production, Operating Costs)
> - Each cell = the relationship type (should show "Regular" for most)
> Example:
> ```
>                    Production    Operating Costs
> Mine Dimension     Regular       Regular
> Date Dimension     Regular       Regular
> Department Dim     Regular       Regular
> ```
> Empty cells mean NO relationship — the dimension cannot filter that measure group. Fix this before deploying.

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
2. Drag a production measure such as `TonnesProduced` into the data area.
3. Add `Mine Name` to rows.
4. Add a time hierarchy or month-level attribute so you can see the trend over time.
5. Add one operating-cost measure and confirm the slice changes when you move across mines or dates.
6. Compare one or two totals with the SQL validation queries in this lab.
7. Record whether the output matches expectation before you consider the deployment complete.

**Expected result:** The cube returns believable mine-by-time views for both production and costs, which is the minimum readiness check before business release.

**If something goes wrong:**
- If the browser tab shows no data, process the cube again and confirm dimensions are not left unprocessed.
- If every row shows the same value, revisit Dimension Usage.
- If the cube browser works but SSMS does not, reconnect to Analysis Services and verify you are hitting the same deployed database.

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

## 🧰 Detailed SSMS Workflow (Use This If You Are Not Using Visual Studio)

Use this exact sequence when completing the lab or exercise primarily in SSMS:

1. Open SSMS and connect to the **Database Engine** that hosts `AssmangMining`.
2. Open the topic dataset script only if the lab requires a fresh load, then execute it and wait for a clean completion message in the Messages pane.
3. Run the SQL validation queries in the file immediately after the load so you confirm counts, date ranges, and key joins before involving SSAS.
4. Keep the Database Engine connection open so you can cross-check source numbers later.
5. Open a second connection in the same SSMS session using **Connect > Analysis Services**.
6. Expand **Databases** on the Analysis Services connection and refresh the tree if the expected SSAS database is not visible the first time.
7. Confirm the deployed database name matches the training project and that the target cube is present.
8. Expand the SSAS database and inspect the cube, dimensions, and other objects so you know the metadata you are about to query.
9. If you need to process objects, remember the project must already be deployed and the account must have SSAS admin rights plus read access to the relational source through the data source impersonation settings.
10. Right-click the cube or database and choose **Process** only after you know which object you are affecting.
11. In the processing dialog, review the list of affected objects carefully because processing can cascade from a high-level object to lower-level objects.
12. Wait for processing to finish and read warnings, not just the final success line.
13. Open the cube browser from SSMS if available, or open an MDX query window using **New Query > MDX**.
14. Start with the simplest possible MDX pattern: one measure on columns and one hierarchy on rows.
15. Add a slicer only after the base query works.
16. Compare at least one SSAS result against the SQL baseline from the Database Engine connection.
17. Save important queries with meaningful names so you can reuse them during assessments.
18. Capture evidence for every exercise: the input, the output, and one sentence explaining what the result means for Assmang.
19. If the numbers look wrong, troubleshoot in this order: SQL source data, deployment state, processing state, dimension relationships, then MDX syntax.
20. Before submission, write down what you tested, what result you obtained, and why the result matters to the business.

### SSMS Menu Path Quick Reference

- Connect to SQL Engine: `File > Connect Object Explorer > Database Engine`
- Connect to SSAS: `Object Explorer > Connect > Analysis Services`
- Open SQL query: `Toolbar > New Query`
- Open MDX query: `Analysis Services connection > New Query > MDX`
- Browse cube: `SSAS Database > Cubes > [Cube Name] > Browse`
- Process object (if permissions allow): `Right-click Cube/Dimension > Process`

## Detailed Visual Studio (SSDT) Workflow (Step-by-Step)

Use this path when you are building and validating directly in Visual Studio with SSDT:

1. Open Visual Studio and load the SSAS solution for the topic.
2. In Solution Explorer, confirm the expected SSAS folders exist and are not already showing warning icons.
3. Open **Project Properties > Deployment** before changing design objects so you know which SSAS server and database you are targeting.
4. Open the data source and click **Test Connection**.
5. Confirm the data source points to the SQL Database Engine instance, not the SSAS instance.
6. Review impersonation settings because successful deployment alone is not enough; processing also needs relational read access.
7. Open the Data Source View and verify the required tables and joins for the topic are present.
8. Rearrange the DSV if it is unreadable so you can actually inspect it during the exercise.
9. Open each required dimension and review `KeyColumns`, `NameColumn`, visible attributes, and user hierarchies.
10. If the topic involves cube work, open the cube designer and inspect structure, measure groups, calculations, and the **Dimension Usage** tab.
11. Check aggregation behaviour for business measures instead of accepting every wizard default.
12. Save changes before building.
13. Run **Build > Build Solution** and read the Error List carefully.
14. Fix build errors before deployment and do not ignore relationship or key warnings unless you can explain them.
15. Deploy the project using **Right-click Project > Deploy**.
16. Remember what Microsoft’s SSDT deployment guidance says: deployment builds the project, validates the destination server, and then creates or updates the SSAS database objects.
17. After deployment, process the affected objects if prompted, or right-click the cube or database and choose **Process** manually.
18. Review the processing dialog before clicking Run because high-level processing choices can affect multiple lower-level objects.
19. Wait for processing to complete and read warnings, not just the success banner.
20. Open the Browser tab and test at least one real business slice for the topic.
21. Open SSMS against Analysis Services and run one or two MDX checks against the same cube output.
22. Compare SSDT browser results, MDX results, and SQL baseline values.
23. If results differ, troubleshoot in this order: source data, DSV relationships, dimension design, dimension usage, aggregation logic, then processing freshness.
24. Save evidence for the exercise: build result, deployment result, process result, browser or MDX output, and one sentence explaining the business meaning.

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
