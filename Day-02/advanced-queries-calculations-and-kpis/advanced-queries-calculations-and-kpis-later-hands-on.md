# Later Hands-On Exercises — Advanced Queries, Calculations, and KPIs
## Day 02 | Assmang Pty Ltd — SSAS Fundamentals

---

## 🎯 Purpose

These exercises are designed for **independent practice** after the guided lab. They are slightly more challenging and are presented with clear step-by-step procedures so you can execute each task confidently.

## 📋 Before You Begin

- Ensure the guided lab for **Advanced Queries, Calculations, and KPIs** is complete
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

Design a Safety Compliance KPI for Assmang that translates raw compliance scores into visual status indicators (red/amber/green) for executive dashboards.

### Procedure

**Step 1: Understand Assmang Safety Context**
- Assmang safety team tracks compliance with regulations (PPE, hazard reporting, incident follow-up)
- ComplianceScore ranges 0–100% (100% = perfect, 0% = no compliance)
- Executives need dashboard status at a glance: Is this mine safe? Is compliance trending well?
- Need: Thresholds that convert score to color (green/amber/red) to support rapid decision-making

**Step 2: Define Business Thresholds**
- Research Assmang's safety standards and regulatory requirements
	- Example: Mine Safety and Health Administration (MSHA) compliance expectations
	- Assmang internal policy: 95%+ is "safe", 80–94% is "at risk", <80% is "critical"
- Document: What does each threshold mean operationally?
	- Green (≥95%): All safety procedures in place, incidents reported and resolved, no audit findings
	- Amber (80–94%): Minor issues identified, corrective actions in progress, next audit needed soon
	- Red (<80%): Serious non-compliance, regulatory risk, mandatory immediate action required

**Step 3: Design KPI Structure in Cube**
- In SSDT cube designer, create new KPI (or calculated measure + status expression)
- KPI component 1 (Value): [Measures].[ComplianceScore]
- KPI component 2 (Goal): 95 (target is ≥95%)
- KPI component 3 (Status Expression): IIF([ComplianceScore] >= 95, 1, IIF([ComplianceScore] >= 80, 0, -1))
	- Status = 1 (Green), 0 (Amber), -1 (Red)

**Step 4: Test KPI in Browser**
- In SSMS Cube Browser, browse KPI and observe:
	- If ComplianceScore = 98% → Green
	- If ComplianceScore = 87% → Amber
	- If ComplianceScore = 75% → Red
- Slice by Mine dimension: Does each mine show correct status?

**Step 5: Validate Thresholds Against Real Data**
- Run SQL to find current ComplianceScore values by mine
- Question: Do the red/amber/green assignments make business sense?
	- Example: "Sishen is at 92% (amber), Khumani is at 78% (red). Is that accurate? Does amber really need a corrective action plan?"
- Adjust thresholds if needed (e.g., move amber to 75–90% if 80–94% too conservative)

**Step 6: Document KPI**
- Write 1–2 paragraphs explaining:
	- What ComplianceScore measures (regulatory adherence, safety incidents, audit findings)
	- Threshold definitions (why 95% for green, 80% for amber, <80% for red)
	- Business impact (green mines get routine audits, amber mines get increased monitoring, red mines get executive escalation)
	- Any assumptions (e.g., "assumes compliance scores are calculated monthly; assumes audits occur quarterly")

### Deliverable

- **Input:** ComplianceScore data; Assmang safety standards
- **Output:** 1–2 paragraph KPI design + threshold table (Score Range | Status | Action)
- **Evidence:** Screenshot of SSDT KPI definition showing status expression; screenshot of browser showing red/amber/green indicators for different mines
- **Assmang Context:** Example: \"Assmang's Executive Safety Committee reviews compliance by mine daily. Red status (Sishen at 76%) triggers immediate investigation: equipment failure rate, reporting delays, or training gaps? Amber status (Khumani at 87%) indicates corrective action is working but not yet closed. Green status (Phalaborwa at 97%) indicates baseline compliance maintained. The KPI converts 0–100% scores into business-actionable color coding.\"

---

## Exercise 2

### Objective

Create a calculated measure that expresses maintenance costs as a percentage of total operating costs, enabling trend analysis and budget variance detection.

### Procedure

**Step 1: Understand the Business Question**
- Assmang operations directors need to track: "What percentage of operating cost is maintenance?"
- Example: If total operating cost = 1 M ZAR and maintenance = 150 K ZAR, then percentage = 15%
- Goal: Trend maintenance costs over time; identify mines with high maintenance burden
- Use case: "Sishen's maintenance is 18% of costs (high); Khumani is 8% (low). Why? Is Sishen equipment aging?"

**Step 2: Identify Source Measures**
- In SSDT cube designer, inspect measure groups to find:
	- [Measures].[MaintenanceCost] (or [MaintenanceExpense])
	- [Measures].[TotalOperatingCost] (or [OperatingCost])
- Verify both measures exist in the cube
- Note aggregation function for each (should be Sum)

**Step 3: Design Calculated Measure**
- Calculated measure name: `MaintenanceCostPercent` or `MaintenanceCostPct`
- MDX formula:
	```
	([Measures].[MaintenanceCost] / [Measures].[TotalOperatingCost]) * 100
	```
- Test formula logic: If MaintenanceCost = 150 and TotalOperatingCost = 1000, result = 15% ✓

**Step 4: Add to Cube in SSDT**
- In Calculations tab of cube designer, insert new calculation
- Set name, formula, format string (percentage with 2 decimals)
- Optional: Add FORMAT_STRING = "0.00%" to format display

**Step 5: Test in Browser**
- Deploy and process cube
- In SSMS Cube Browser, slice by Mine dimension
- Query: SELECT MaintenanceCostPercent by Mine
- Verify: Sishen shows 18%, Khumani shows 8%, Phalaborwa shows 12% (realistic values)
- Cross-check: Manual calc (Sishen: 180K / 1M * 100 = 18%) ✓

**Step 6: Document Calculated Measure**
- Write 1–2 paragraphs explaining:
	- What the measure calculates (maintenance as % of total cost)
	- Why percentage is better than raw dollars (enables cross-mine and cross-period comparison)
	- Business insight (mines with high % may need equipment replacement or process optimization)
	- Any assumptions (e.g., "assumes MaintenanceCost only includes proactive/preventive maintenance, not emergency repairs")

### Deliverable

- **Input:** MaintenanceCost and TotalOperatingCost measures from cube
- **Output:** Calculated measure formula + 1–2 paragraph explanation
- **Evidence:** Screenshot of SSDT Calculations tab showing formula; screenshot of browser query result (MaintenanceCostPercent by Mine); manual verification calculation
- **Assmang Context:** Example: \"Assmang tracks MaintenanceCostPct to monitor equipment health and budget efficiency. Sishen at 18% suggests aging equipment or intensive maintenance schedule. CFO uses this metric to justify capital allocation: 'Sishen needs new loaders to reduce maintenance from 18% to 12%.'"

---

## Exercise 3

### Objective

Create a reusable named set for Assmang's chrome mining operations and demonstrate how it simplifies query writing and improves consistency across reports.

### Procedure

**Step 1: Understand Named Sets**
- Named set: A predefined group of members that can be referenced in queries
- Benefit: Write set once, reuse in many queries (instead of retyping mine names each time)
- Example: Instead of ([Mine].[Sishen], [Mine].[Khumani]) in every query, reference [ChromeMines]
- Advantage for Assmang: If chrome operations expand (add a new mine), update named set once; all queries automatically use the new list

**Step 2: Identify Chrome Mines**
- Inspect Assmang's mine portfolio: Sishen and Khumani are chrome-focused
- Other mines: Phalaborwa (platinum), etc.
- Define named set members: [Mine].[Sishen] and [Mine].[Khumani]

**Step 3: Create Named Set in SSDT Cube**
- In cube designer, go to Calculations tab
- Add new calculation > Named Set
- Name: `ChromeMines`
- Expression: `{[Mine].[Sishen], [Mine].[Khumani]}`
- Save and deploy

**Step 4: Write Query #1 Using Named Set**
- Query: "Show total production for chrome operations, by year"
- Without named set:
	```
	SELECT [Measures].[TonnesProduced] ON COLUMNS,
				 [Date].[Year].Members ON ROWS
	FROM [AssmangMiningAnalytics]
	WHERE ([Mine].[Sishen], [Mine].[Khumani])
	```
- With named set:
	```
	SELECT [Measures].[TonnesProduced] ON COLUMNS,
				 [Date].[Year].Members ON ROWS
	FROM [AssmangMiningAnalytics]
	WHERE [ChromeMines]
	```
- Execute in SSMS and record result (e.g., 1.5 M tonnes in 2024)

**Step 5: Write Query #2 Using Same Named Set**
- Query: "Show cost per tonne for chrome operations, by mine"
- With named set:
	```
	SELECT [Measures].[CostPerTonneZAR] ON COLUMNS,
				 [ChromeMines] ON ROWS
	FROM [AssmangMiningAnalytics]
	WHERE [Date].[2024]
	```
- Execute in SSMS and record result (e.g., Sishen 450 ZAR/t, Khumani 480 ZAR/t)

**Step 6: Document Named Set**
- Write 1–2 paragraphs explaining:
	- What the named set represents (chrome mines: Sishen + Khumani)
	- Why it's useful (consistency, maintainability, reduces query complexity)
	- Business meaning (enables quick chrome-vs-platinum comparisons)
	- Example: "If Assmang acquires a third chrome mine in the future, update [ChromeMines] once; all reports automatically include new mine"

### Deliverable

- **Input:** Mine dimension with chrome mines identified (Sishen, Khumani)
- **Output:** Named set definition + two complete MDX queries using the named set
- **Evidence:** Screenshots of (1) SSDT Calculations tab showing [ChromeMines] definition, (2) Query #1 result (production by year), (3) Query #2 result (cost per tonne by mine); one-line comparison showing how named set simplified the WHERE clause
- **Assmang Context:** Example: \"Chrome represents 40% of Assmang's revenue. Operations dashboard has 15+ reports filtering by chrome mines. Using [ChromeMines] named set, queries are consistent and maintainable. When Assmang adds Mogalakwena mine to chrome portfolio next year, they update [ChromeMines] once and all 15 reports automatically reflect the expansion without code changes.\"

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
