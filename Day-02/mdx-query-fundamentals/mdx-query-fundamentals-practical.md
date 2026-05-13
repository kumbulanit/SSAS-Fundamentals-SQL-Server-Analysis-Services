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

### Step 1: Open an Analysis Services connection and confirm the cube is browse-ready

**Set up the MDX workspace first:**
1. Open SSMS.
2. Choose **Connect > Analysis Services**.
3. Enter the SSAS server used for the training cube.
4. Expand **Databases** and find `Assmang Mining Analytics`.
5. Verify the cube is already deployed and processed before you begin querying.
6. Open a new MDX query window from the Analysis Services connection.

**What to confirm before typing MDX:**
- You are connected to Analysis Services, not the Database Engine.
- The cube exists under the expected database.
- You can browse the metadata tree for measures and dimensions.

**Expected result:** You have a live MDX query window aimed at the correct cube.

**If something goes wrong:**
- If the cube is missing, revisit deployment and processing before continuing.
- If the connection fails, verify the SSAS service name and your permissions.
- If metadata browsing is unavailable, reconnect and confirm you did not open a SQL query window by mistake.

---

### Step 2: Run the simplest useful MDX query: one measure on columns, one hierarchy on rows

**Build the query in the classic MDX shape:**
1. Start with `SELECT`.
2. Put `[Measures].[TonnesProduced]` on **COLUMNS**.
3. Put the mine-name members on **ROWS**.
4. Point the query at `[Assmang Mining Analytics]` in the `FROM` clause.
5. Execute the query and inspect the grid output.

**What learners should notice:**
- MDX thinks in axes, not in a `SELECT column FROM table` pattern like SQL.
- Measures usually go on columns first for readability.
- A hierarchy returns members rather than raw relational rows.

**Expected result:** One row per mine with production values visible.

**If something goes wrong:**
- If the measure name fails, drag it from metadata rather than typing from memory.
- If the row axis returns nothing, confirm the hierarchy path is valid.
- If the query runs but values look blank, the cube may not be fully processed.

---

### Step 3: Add a slicer to restrict the result to calendar year 2024

**Extend the same query instead of rewriting from scratch:**
1. Keep the measure and row axis from Step 2.
2. Add a `WHERE` clause using the 2024 member from the date hierarchy.
3. Execute the query again.
4. Compare the result to the unsliced query from Step 2.
5. Write down what changed.

**What this teaches:** The slicer axis narrows the query context without adding another visible axis to the grid.

**Expected result:** The mine totals change to reflect only the 2024 slice.

**If something goes wrong:**
- If the year member path fails, expand the date hierarchy in metadata and drag the correct member into the query.
- If values do not change, verify that the date dimension is related correctly to the production measure group.
- If you see syntax errors near `WHERE`, check parentheses and member path formatting.

---

### Step 4: Query by a higher business level instead of individual mine members

**Shift from detailed members to a summarised hierarchy level:**
1. Replace the mine-name level on rows with the mine-type hierarchy level.
2. Switch the measure to `[Measures].[RevenueZAR]`.
3. Keep the 2024 slicer if you want the comparison to stay time-bounded.
4. Execute the query.
5. Compare the number of returned rows with the mine-level query.

**What to observe:** MDX becomes powerful when you change the level of the hierarchy and ask the same business question at a different grain.

**Expected result:** Revenue is aggregated by commodity grouping such as Iron Ore, Manganese, and Chrome rather than by mine.

**If something goes wrong:**
- If the hierarchy level does not exist, inspect the mine dimension design and browser metadata.
- If totals seem identical to the detailed query, make sure you changed the level, not just the caption.
- If the mine-type level is empty, revisit dimension processing.

---

### Step 5: Create a named set to isolate the iron ore mines

**Use MDX logic, not manual filtering in the result grid:**
1. Add a `WITH` clause.
2. Define a named set for the descendants of the Iron Ore member at the mine-name level.
3. Place the named set on rows.
4. Put `TonnesProduced` and `RevenueZAR` on columns.
5. Execute the query and compare it to the full mine list.

**Why this matters:** Named sets let you define reusable business groupings such as iron ore operations, chrome operations, or high-performing mines.

**Expected result:** Only the iron ore mines appear on rows and the output is easier to reuse in later exercises.

**If something goes wrong:**
- If the set returns nothing, double-check the member path for the Iron Ore parent.
- If descendants return the wrong level, confirm the target hierarchy level in the `DESCENDANTS` call.
- If the syntax feels fragile, build the set with metadata drag-and-drop and then clean the formatting.

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
