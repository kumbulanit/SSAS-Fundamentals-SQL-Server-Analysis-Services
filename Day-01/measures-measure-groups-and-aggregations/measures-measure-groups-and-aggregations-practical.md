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

### Step 1: Load `datasets/v2_assmang_mining_extended.sql` and verify the fact data arrived correctly

**Complete the source-data extension first:**
1. Open `datasets/v2_assmang_mining_extended.sql` in SSMS.
2. Execute the script against the same SQL instance used by your SSAS project.
3. Run the SQL validation queries in this lab immediately after the load.
4. Confirm that `FactProduction` and `FactOperatingCosts` now contain data and link cleanly to mines, departments, and dates.

**What you should verify before moving on:**
- `FactProduction` has monthly output and revenue values.
- `FactOperatingCosts` has cost categories by mine, department, and date.
- No orphan rows appear in the validation query.

**Expected result:** Your relational source is ready for measure-group design.

**If something goes wrong:**
- If fact tables are missing, rerun the script from the top.
- If counts look wrong, check that you are in the `AssmangMining` database.
- If joins fail in the validation query, do not continue to cube design until the relational issues are understood.

---

### Step 2: Extend the Data Source View to include the two fact tables

**Update the DSV deliberately, not casually:**
1. Open the existing Data Source View in Visual Studio.
2. Right-click inside the diagram and choose **Add/Remove Tables**.
3. Add `FactProduction` and `FactOperatingCosts`.
4. Confirm the relationship lines to `Dim_Mine`, `Dim_Department`, and `Dim_Date` are visible.
5. Rearrange the diagram so dimensions are easy to distinguish from facts.
6. Save the DSV.

**What you are checking at this stage:**
- Both fact tables are present.
- The fact-to-dimension joins make sense visually.
- The DSV now looks like a star-style analytical model rather than a random pile of tables.

**Expected result:** The project metadata now exposes the fact tables required for measure groups.

**If something goes wrong:**
- If relationships are missing, inspect the SQL foreign keys and refresh the DSV.
- If the DSV becomes cluttered, tidy the layout now before opening the cube wizard.
- If the wrong tables were added, remove them before continuing.

---

### Step 3: Use the Cube Wizard to create one cube with two measure groups

**Create the cube from the extended model:**
1. Right-click **Cubes** and choose **New Cube**.
2. Choose **Use existing tables** when prompted.
3. Select both `FactProduction` and `FactOperatingCosts` as measure group sources.
4. Review the measures suggested by the wizard instead of clicking through blindly.
5. Ensure the relevant dimensions are selected for inclusion in the cube.
6. Name the cube `Assmang Mining Analytics`.
7. Finish the wizard and open the cube designer.

**What to check when the cube opens:**
- You should see two measure groups.
- The Measures pane should include production, revenue, grade, and cost-related values.
- The Dimensions pane should show the business dimensions that can slice those measures.

**Expected result:** The cube structure reflects the business model: one cube, multiple measure groups, shared dimensions.

**If something goes wrong:**
- If the wizard suggests nonsense measures, stop and deselect the wrong columns.
- If a fact table does not appear, go back to the DSV and verify it is present there.
- If the cube opens without dimensions, revisit the wizard choices rather than patching blindly afterward.

---

### Step 4: Correct measure properties so business math is sensible

**Review aggregation behavior measure by measure:**
1. In the cube designer, inspect each auto-generated measure.
2. Keep additive values such as `TonnesProduced`, `RevenueZAR`, and individual cost amounts as sums.
3. Review values such as `Grade` and `CostPerTonneZAR` carefully because business users usually want averages or calculated logic, not simple sums.
4. Rename awkward measure captions so the browser output reads clearly.
5. Remove any measures that are obviously technical or not useful to end users.
6. Save the cube after the review.

**Business rule to keep in mind:** Summing revenue is sensible. Summing grades or cost-per-tonne values often produces misleading results.

**Expected result:** The cube exposes measures that behave correctly when a manager slices by mine, month, or department.

**If something goes wrong:**
- If you are unsure whether to use Sum or Average, ask what question the user wants answered.
- If a measure appears twice or under the wrong group, clean it up now.
- If the browser later shows absurd totals, this review step is the first place to revisit.

---

### Step 5: Process the cube and validate measures by mine and month

**Do not stop at deployment; confirm analytical behaviour:**
1. Build and deploy the project.
2. Process the cube fully so the measure groups and dimensions are queryable.
3. Open the Browser tab.
4. Drag `TonnesProduced`, `RevenueZAR`, and one or two cost measures into the data area.
5. Slice by mine and then by time.
6. Compare the browser output to the SQL validation queries in this lab.
7. Record any mismatch before moving on.

**What good output looks like:**
- Mines should return different totals based on their fact data.
- Month-level slices should show time movement rather than repeated totals everywhere.
- Revenue and cost patterns should roughly align with the relational SQL checks.

**Expected result:** Learners can explain the difference between fact tables, measure groups, measures, and aggregation behaviour using actual cube output.

**If something goes wrong:**
- If the Browser tab is empty, the cube probably is not fully processed.
- If values repeat strangely across all rows, inspect dimension usage and aggregation settings.
- If the cube processes but browsing still fails, verify deployment and reconnect to the SSAS instance.

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
