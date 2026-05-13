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

**Start with the design setting that affects almost everything else:**
1. Open the cube designer.
2. Review the storage mode of the cube and measure groups.
3. Note whether the training model is using MOLAP and why.
4. Write a short explanation of why MOLAP fits a training model with stable, batch-loaded data.
5. Contrast it briefly with ROLAP or HOLAP so you can explain the trade-off.

**What to look for:** You are not memorising acronyms. You are deciding how fast queries, freshness, and complexity should be balanced.

**Expected result:** You can explain why preprocessed multidimensional storage is usually a sensible default in this course.

**If something goes wrong:**
- If you cannot find the storage setting, inspect measure-group and partition properties.
- If someone changed the default, document that and explain the implication rather than forcing it back blindly.
- If you do not understand the mode, compare how each mode answers queries and refreshes data.

---

### Step 2: Review aggregation design for common production queries

**Use the design tools with a business question in mind:**
1. Focus on the production measure group first.
2. Open the aggregation design tooling or relevant measure-group settings.
3. Review which attributes are likely to help common Assmang queries, especially mine and time slices.
4. Note which aggregations the tool suggests and why they matter.
5. Save your observations before making changes.

**What you are really testing:** Whether the cube is prepared for the kinds of grouped queries managers ask most often.

**Expected result:** You can explain how aggregations reduce repeated computation for predictable query patterns.

**If something goes wrong:**
- If the designer is unavailable, document the intended design even if you cannot implement every optimisation interactively.
- If the suggestions seem random, tie them back to your main browse and MDX query patterns.
- If you add changes, remember that reprocessing may be required afterward.

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

### Step 4: Propose a practical partitioning design for production facts

**Think like a BI engineer planning for growth:**
1. Review the grain of `FactProduction`.
2. Decide whether yearly or monthly partitions make more sense for the data volume and refresh pattern.
3. Explain how new periods could be processed more often than historical periods.
4. Note which partition boundaries you would use.
5. Explain how that design helps both maintenance and query responsiveness.

**Expected result:** You can propose a partitioning approach that matches business time periods and operational refresh behaviour.

**If something goes wrong:**
- If the dataset is too small to prove partition value empirically, explain the design logically using future growth assumptions.
- If you are unsure between month and year partitions, compare maintenance overhead against query benefit.
- If your proposal ignores refresh frequency, revisit the business scenario.

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

- [ ] The relevant SQL dataset was loaded and verified
- [ ] The SSAS project was opened without errors
- [ ] All objects created in this lab are visible in Solution Explorer
- [ ] Processing completed successfully (check Output window)
- [ ] The cube browser or SSMS query returns expected results
- [ ] You can explain what each object does in business terms

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

## MDX Queries for Before/After Comparison (Run in SSMS against SSAS)

```mdx
/* Query A: broad scan by mine and month */
SELECT
	{[Measures].[TonnesProduced], [Measures].[RevenueZAR]} ON COLUMNS,
	NON EMPTY
	CROSSJOIN(
		[Mine].[Mine Name].[Mine Name].MEMBERS,
		[Date].[Month Name].[Month Name].MEMBERS
	) ON ROWS
FROM [Assmang Mining Analytics]
WHERE ([Date].[Calendar Year].&[2024]);
```

```mdx
/* Query B: narrower slice for comparison */
SELECT
	{[Measures].[TonnesProduced], [Measures].[RevenueZAR]} ON COLUMNS,
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
