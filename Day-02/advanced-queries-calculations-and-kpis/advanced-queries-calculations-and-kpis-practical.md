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

### Step 1: Build a calculated measure for `Cost Per Tonne`

**Create the calculation from validated source logic:**
1. Review the SQL baseline query in this lab so you understand the source numbers.
2. Open the cube designer or an MDX query window, depending on how your trainer wants calculations demonstrated.
3. Create a helper expression for total operating cost if one does not already exist.
4. Define `Cost Per Tonne` as total cost divided by tonnes produced.
5. Protect the expression against divide-by-zero cases.
6. Save the calculation and keep the formula readable.

**What you should be thinking about:** A calculated measure is often safer than summing a unit-rate field because it preserves business meaning at aggregated levels.

**Expected result:** The cube can return a meaningful cost-per-tonne figure rather than an invalid raw sum.

**If something goes wrong:**
- If you get nulls everywhere, make sure the source measures being divided are populated.
- If the number is unrealistically large, confirm you are not summing a rate and then dividing incorrectly.
- If syntax errors appear, simplify the formula and test the helper measure first.

---

### Step 2: Create a named set for mines with above-average production

**Turn a business rule into reusable MDX logic:**
1. Start with the set of all mine members.
2. Use `AVG` over the mine set to calculate the comparison benchmark.
3. Wrap the logic in a `FILTER` expression.
4. Name the set clearly so it can be reused in later queries.
5. Run a test query that places the set on rows with `TonnesProduced` and your calculated measure on columns.

**Why this matters:** Named sets allow you to encode reusable groups such as top mines, chrome operations, or underperforming sites without retyping the logic.

**Expected result:** Only mines whose production exceeds the average mine production remain in the result.

**If something goes wrong:**
- If every mine appears, the comparison logic is too broad or the set context is wrong.
- If no mine appears, test the average calculation by itself first.
- If values vary unexpectedly by time, note that the current query context affects the average.

---

### Step 3: Define a KPI for production target attainment

**Model the KPI like a business scorecard, not just a formula:**
1. Decide on an assumed monthly target value.
2. Use the actual production measure as the KPI value.
3. Use the target value as the KPI goal.
4. Define a status rule so results can be interpreted as under target, near target, or on target.
5. If your environment supports it, add a trend expression as well.
6. Save and process the affected objects if necessary.

**What a learner should be able to explain:** A KPI is not only a number. It is a business judgment layer that compares actual performance against a goal.

**Expected result:** The model can now show production performance in a way an executive can read quickly.

**If something goes wrong:**
- If the KPI does not appear in the browser, process the cube again.
- If the goal is hard-coded incorrectly, your status colors or results will be misleading.
- If the KPI seems mathematically correct but business-wise wrong, revisit the target assumption.

---

### Step 4: Browse or query the calculation and KPI outputs

**Validate the logic instead of trusting it blindly:**
1. Open the Browser tab or an SSMS MDX query window.
2. Place mines on rows.
3. Add `TonnesProduced`, `Cost Per Tonne`, target values, and KPI outputs to columns.
4. Optionally slice by year or month so you can see context-sensitive behaviour.
5. Compare at least one result back to the SQL baseline logic from this lab.
6. Record whether the KPI interpretation matches the raw numbers.

**Expected result:** The calculation and KPI behave consistently when sliced by mine or time.

**If something goes wrong:**
- If the KPI disappears at some levels, verify calculation scope and processing state.
- If the cost-per-tonne figure changes wildly by slice, check whether all contributing cost measures are aligned to the same grain.
- If the browser is slow or blank, reconnect and make sure the cube is fully processed.

---

### Step 5: Document the business meaning of every calculation you created

**Finish by translating technical work into business language:**
1. Write one sentence explaining what `Cost Per Tonne` tells a mine manager.
2. Write one sentence explaining what the above-average mines set identifies.
3. Write one sentence explaining what the KPI target-attainment result means for operations review.
4. Note any assumptions, especially hard-coded targets or simplified logic.
5. Save the formulas and the explanation together so another learner can understand both the maths and the business meaning.

**Expected result:** You can defend not only how the calculation works, but why it exists and how a business user should read it.

**If something goes wrong:**
- If your explanation sounds purely technical, rewrite it from a manager's point of view.
- If the explanation and the formula do not match, fix the formula or the wording before submission.
- If assumptions are hidden, surface them clearly so the KPI is not misinterpreted later.

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
