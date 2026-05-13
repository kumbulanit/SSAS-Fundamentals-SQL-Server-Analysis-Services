# Later Hands-On Exercises — MDX Query Fundamentals
## Day 02 | Assmang Pty Ltd — SSAS Fundamentals

---

## 🎯 Purpose

These exercises are designed for **independent practice** after the guided lab. They are slightly more challenging and require you to apply what you've learned without step-by-step guidance.

## 📋 Before You Begin

- Ensure the guided lab for **MDX Query Fundamentals** is complete
- Dataset **`v3_assmang_mining_complete.sql`** must be loaded
- Your SSAS project should be in a working state
- Allow 30-45 minutes for these exercises

---

## How To Work Through These Exercises

Use this repeatable method for every exercise instead of jumping straight to the answer:

1. Read the task and rewrite it as a simple business question in your own words.
2. Decide whether the answer should come from explanation only, SSDT inspection, SSMS browsing, SQL validation, or MDX output.
3. If the task depends on model objects, first confirm the relevant cube, dimension, measure, hierarchy, or KPI exists before writing conclusions.
4. If the task depends on numbers, get a baseline from SQL or existing browser output before writing the final answer.
5. Start with the smallest possible test. For example, browse one measure for one mine before trying a more complex view.
6. Expand gradually until you have enough evidence to answer the question confidently.
7. Record what you checked, what result you saw, and what that result means in plain business language.
8. If an exercise asks for a recommendation or explanation, support it with one concrete observation from the model or data.

## Evidence Checklist For Each Exercise

Before you mark an exercise complete, make sure you can show all of the following where relevant:

- The object you inspected, such as a dimension, hierarchy, measure group, KPI, or MDX query.
- The output you observed, such as a browser grid, MDX result, build result, or processing result.
- A short explanation of why that output answers the task.
- At least one Assmang-specific business interpretation, not just a technical description.

## If You Get Stuck

Use this recovery sequence:

1. Return to the guided practical for the same topic and repeat the closest worked example.
2. Check the theory page for the business meaning of the concept before changing the model.
3. Validate source data in SQL if the cube result looks suspicious.
4. Validate deployment and processing state if the SSAS object exists but numbers look incomplete.
5. Reduce the query or browser slice to something smaller and rebuild from there.

---

## Exercise 1

### Objective

Write and validate an MDX query that isolates production for chrome-specific mining operations at Assmang.

### Procedure

**Step 1: Understand the Business Question**
- Assmang mines multiple commodities: chrome, platinum, iron ore
- Chrome operations: Sishen and Khumani mines
- Business question: "What was total chrome production in 2024?"
- Expected answer: A single number representing all chrome tonnes (summed across both chrome mines)

**Step 2: Identify Dimensions and Members**
- In SSMS, open Assmang Mining Analytics cube browser
- Expand Mine dimension; identify chrome mine members: "Sishen", "Khumani"
- Expand Date dimension; identify 2024 members: "2024" (if exists) or navigate via hierarchy
- Note: If no "Commodity" or "OperationType" dimension exists, must filter by mine name

**Step 3: Write Basic MDX Query**
- Template:
	```
	SELECT [Measures].[TonnesProduced] ON COLUMNS,
				 [Mine].[Chrome Mines] ON ROWS
	FROM [AssmangMiningAnalytics]
	WHERE [Date].[2024]
	```
- Issue: [Mine].[Chrome Mines] is not a member; must use set or filter

**Step 4: Refine Query with Filtering**
- Approach 1 (Explicit Set):
	```
	SELECT [Measures].[TonnesProduced] ON COLUMNS
	FROM [AssmangMiningAnalytics]
	WHERE ([Mine].[Sishen], [Mine].[Khumani], [Date].[2024])
	```
- Approach 2 (Named Set, if exists):
	```
	SELECT [Measures].[TonnesProduced] ON COLUMNS
	FROM [AssmangMiningAnalytics]
	WHERE ([CromeMines], [Date].[2024])
	```

**Step 5: Test and Validate**
- In SSMS Analysis Services query window, paste query and execute
- Result should show: Single number (total chrome tonnes in 2024)
- Cross-check: Run SQL baseline query (SUM(TonnesProduced) FROM FactProduction WHERE MineID IN (Sishen, Khumani) AND DateID >= 2024-01-01)
- Verify: MDX result = SQL result (exact match required)

**Step 6: Document Query and Interpretation**
- Write 1–2 paragraphs explaining:
	- What the query does (filters to chrome mines and 2024)
	- Why this structure (WHERE clause for slicing, one measure on columns)
	- Business interpretation (e.g., "Assmang's chrome operations produced X tonnes in 2024")
	- Any variations tried (if Approach 1 vs Approach 2 were compared)

### Deliverable

- **Input:** Chrome mine names; requirement to filter to 2024 only
- **Output:** Working MDX query + 1–2 paragraph explanation
- **Evidence:** Screenshot of SSMS query window showing MDX query and result; comparison to SQL baseline showing matching result
- **Assmang Context:** Example: \"Chrome production is a key line of business for Assmang. The query 'SELECT TonnesProduced WHERE Sishen + Khumani + 2024' gives us exactly 1.2M tonnes for the year. Operations team uses this number to compare against budget and plan Q1 next year's chrome volume.\"

---

## Exercise 2

### Objective

Write an MDX query that displays revenue by quarter for a single Assmang mine, structured with proper axis organization.

### Procedure

**Step 1: Clarify the Business Question**
- Mine managers want: "Show Sishen revenue for each quarter in 2024"
- Expected result: A matrix with quarters as rows and revenue as the value
- Example output:
	```
	Sishen 2024 Revenue
	Q1 2024: 45.5 M ZAR
	Q2 2024: 52.3 M ZAR
	Q3 2024: 48.1 M ZAR
	Q4 2024: 53.2 M ZAR
	```

**Step 2: Identify MDX Components**
- Measure: [Measures].[RevenueMln] (or [OperatingCost] or appropriate revenue measure)
- Dimension for rows: [Date].[Quarter] members (Q1 2024, Q2 2024, etc.)
- Slicer (WHERE): [Mine].[Sishen]
- Note: Quarters are typically nested in years in the Date hierarchy

**Step 3: Write Query Structure**
- Template:
	```
	SELECT [Measures].[RevenueMln] ON COLUMNS,
				 [Date].[Quarter].Members ON ROWS
	FROM [AssmangMiningAnalytics]
	WHERE ([Mine].[Sishen], [Date].[2024])
	```
- Structure explanation: Measure on COLUMNS (vertical axis), Date/Quarter on ROWS (horizontal axis)

**Step 4: Refine for 2024 Only**
- If query returns all quarters (not just 2024), add year filter:
	```
	SELECT [Measures].[RevenueMln] ON COLUMNS,
				 [Date].[2024].[Quarter].Members ON ROWS
	FROM [AssmangMiningAnalytics]
	WHERE [Mine].[Sishen]
	```

**Step 5: Test and Validate**
- Paste query into SSMS Analysis Services query window
- Execute and inspect results
- Verify: Four quarters (Q1, Q2, Q3, Q4) with one revenue value each
- Cross-check: Run SQL baseline (SUM(Revenue) FROM FactProduction WHERE MineID=Sishen AND Quarter=Q1 2024, etc.)
- Confirm: MDX quarterly totals = SQL sum for each quarter

**Step 6: Document Query**
- Write 1–2 paragraphs explaining:
	- Query structure (measure on COLUMNS, quarter on ROWS, mine in WHERE)
	- Why this layout (readable for managers; quarters down column, one revenue value)
	- Business interpretation (e.g., "Q2 was Sishen's strongest quarter with 52.3 M ZAR")

### Deliverable

- **Input:** Requirement to show Sishen 2024 revenue by quarter
- **Output:** Working MDX query + 1–2 paragraph explanation
- **Evidence:** Screenshot of query and result (4 rows of quarterly revenue); SQL baseline validation; explanation of why ROWS/COLUMNS structure was chosen
- **Assmang Context:** Example: \"Sishen mine leadership tracks quarterly revenue for budget planning and production scheduling. The query 'SELECT RevenueMln ON COLUMNS, Date.Quarter.Members ON ROWS WHERE Sishen, 2024' gives them the exact trend: Q2 peak (52.3M), Q3 dip (48.1M). They use this to adjust Q4 strategy and staffing plans.\"

@@## Exercise 3

---

## Exercise 3

### Objective

Explain the three axes of MDX queries (COLUMNS, ROWS, WHERE/slicer) using Assmang examples and concrete business scenarios.

### Procedure

**Step 1: Understand Query Structure**
- MDX queries are structured like this:
	```
	SELECT [measure or dimension] ON COLUMNS,
				 [dimension] ON ROWS
	FROM [Cube]
	WHERE [slicer dimensions]
	```
- Think of it as: building a spreadsheet with rows, columns, and a filter

**Step 2: Define ROWS (Y-axis, vertical)**
- ROWS: What do you want to see listed vertically (as row labels)?
- Example: Mine dimension → Sishen, Khumani, Phalaborwa (each mine is a separate row)
- Assmang use: Production manager browses the cube, sees each mine down the left side
- Question answered: "How much production for each mine?"

**Step 3: Define COLUMNS (X-axis, horizontal)**
- COLUMNS: What do you want to see across the top (as column headers)?
- Example 1: Measure → TonnesProduced (one column, one number per row)
- Example 2: Date hierarchy → 2024 Q1, Q2, Q3, Q4 (four columns, one per quarter)
- Assmang use: Production manager sees quarters across the top, mines down the left
- Question answered: "What was production by mine by quarter?"

**Step 4: Define WHERE/Slicer (filter)**
- WHERE: What do you want to filter OUT of the result? (constraints on the data)
- Example 1: WHERE [Department].[Extraction] (only show extraction dept; exclude planning, admin)
- Example 2: WHERE [Date].[2024] (only show 2024; exclude other years)
- Assmang use: "Show me production by mine by quarter, but only for Extraction Department and only 2024"
- Note: WHERE hides unwanted dimensions; they don't appear in the spreadsheet

**Step 5: Construct an Assmang Example**
- Business question: "Show production by mine by quarter for 2024"
- Query structure:
	```
	ROWS: [Mine].[Mine].Members → Sishen, Khumani, Phalaborwa
	COLUMNS: [Date].[Quarter].Members → Q1, Q2, Q3, Q4
	WHERE: [Date].[2024], [Department].[Extraction]
	MEASURE: [Measures].[TonnesProduced]
	```
- Result: 3 mines × 4 quarters = 12-cell grid
- Each cell = tonnes produced by that mine in that quarter (extraction dept only)

**Step 6: Document Explanation**
- Write 1–2 paragraphs or a table explaining:
	- ROWS: Vertical dimension (e.g., Mine, Employee); shows the "drill-down" axis
	- COLUMNS: Horizontal dimension or measure (e.g., quarters, revenue); shows comparative values
	- WHERE: Filter/slicer (e.g., date, department); selects subset of data
	- Visual metaphor: "Excel spreadsheet where rows are row headers, columns are column headers, slicer is the autofilter dropdown"
	- Assmang example confirming each role

### Deliverable

- **Input:** MDX query structure template; Assmang business scenario
- **Output:** 1–2 paragraph explanation + visual table showing roles (ROWS/COLUMNS/WHERE)
- **Evidence:** Screenshot of one full MDX query with ROWS/COLUMNS/WHERE marked; resulting browser/MDX output grid showing how data aligns
- **Assmang Context:** Example: \"ROWS is 'Mine' because managers want to compare Sishen vs. Khumani. COLUMNS is 'Quarter' because trends matter month-to-month. WHERE is '2024 Extraction' because we need current-year production data for the active extraction team only. The result is a 2×4 grid: 2 mines × 4 quarters, each cell showing tonnes.\"

---

## ✅ Success Criteria

Your exercises are considered successful when:

- Your answer reflects the topic's **business purpose**, not only the technical steps.
- You can explain **why** the design or query choice fits Assmang's reporting needs.
- You can connect your answer back to dimensions, measures, hierarchies, MDX, or deployment where relevant.
- Your work is **documented clearly** enough that a colleague could understand it.

---

## 💡 Stretch Challenge (Optional)

If you finish early, try to extend one of the exercises above by combining it with a concept from a previous topic. For example, if this topic covers measures, try connecting your measure design to a specific dimension hierarchy from an earlier topic.

---

*Assmang Pty Ltd — SSAS Fundamentals | Day 02 Independent Practice*

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
