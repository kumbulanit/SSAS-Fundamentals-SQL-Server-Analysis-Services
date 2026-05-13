# Later Hands-On Exercises — Measures, Measure Groups, and Aggregations
## Day 01 | Assmang Pty Ltd — SSAS Fundamentals

---

## 🎯 Purpose

These exercises are designed for **independent practice** after the guided lab. They are slightly more challenging and require you to apply what you've learned without step-by-step guidance.

## 📋 Before You Begin

- Ensure the guided lab for **Measures, Measure Groups, and Aggregations** is complete
- Dataset **`v2_assmang_mining_extended.sql`** must be loaded
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

Classify measures in FactProduction by aggregation function and recommend appropriate modeling for each.

### Procedure

**Step 1: Review FactProduction Fact Table**
- Open SSDT Data Source View
- Inspect FactProduction table: columns, data types, and which columns represent business measures (not keys or dates)
- List candidate measures: TonnesProduced, EquipmentHours, ProductionCost, EmployeesAssigned

**Step 2: Define Aggregation Types**
- **Additive**: Can sum across all dimensions (e.g., Tonnes: total tonnes across mines, dates, departments)
- **Semi-Additive**: Sum across some dimensions but NOT others (e.g., EmployeesAssigned: sum by date is meaningless, max/min makes sense)
- **Non-Additive**: Cannot sum anywhere (e.g., EquipmentUptime%: percentage, must average or use max/min)
- **Calculated**: Not in fact table; built from other measures (e.g., CostPerTonne = ProductionCost / TonnesProduced)

**Step 3: Classify Each FactProduction Measure**
- For each measure, ask: "What does it mean to sum this across dimensions?"
- TonnesProduced: Sum across mines, departments, dates → ADDITIVE ✓
- ProductionCost: Sum across time periods within a fact row → SEMI-ADDITIVE (last value, not sum)
- EquipmentHours: Sum across equipment and shifts → ADDITIVE ✓
- EmployeesAssigned: Count of people, max during shift → SEMI-ADDITIVE (use Max, not Sum)

**Step 4: Verify with SSDT Cube Designer**
- Open the Production measure group in the cube
- Inspect each measure's AggregationFunction property (Sum, Min, Max, Average, Count, Distinct Count)
- Does the AggregationFunction match your classification?
- If measure is set to Sum but should be Max (semi-additive), note this as a potential error

**Step 5: Document Recommendations**
- Write 1–2 paragraphs recommending:
	- Which measures are correctly configured as Sum
	- Which measures should use Max/Min/Average instead
	- Whether any new calculated measures would add value (e.g., EfficiencyRatio = TonnesProduced / EquipmentHours)

### Deliverable

- **Input:** FactProduction table structure from DSV
- **Output:** 1–2 paragraph classification summary + measure-by-measure table (Measure Name | Type | AggregationFunction | Recommendation)
- **Evidence:** Specific measure names from cube; screenshot of AggregationFunction property in SSDT
- **Assmang Context:** Example: \"EquipmentHours is additive (sum across shifts). EmployeesAssigned is semi-additive (use Max, not Sum, because summing '10 employees on Day shift' + '8 employees on Night shift' = '18 employees' is wrong; what matters is peak headcount). If we sum EmployeesAssigned, staffing metrics become meaningless.\"

---

## Exercise 2

### Objective

Design a new Equipment Efficiency measure group using v3 dataset and recommend three business measures for Assmang equipment analytics.

### Procedure

**Step 1: Review v3 Dataset for Equipment Table**
- Load v3 dataset script and inspect FactEquipmentEfficiency table
- Identify columns: EquipmentID, DateID, EquipmentType, UptimePercentage, MaintenanceHours, BreakdownCount
- Document grain: is each row one equipment per day? Per shift? Per week?

**Step 2: Understand Assmang Equipment Needs**
- Assmang tracks: Truck loaders, haul trucks, drill rigs, excavators
- Key questions: Which equipment types are most efficient? When do breakdowns happen? Is maintenance preventing downtime?
- Business metrics: Uptime%, maintenance cost per equipment, breakdown frequency trends

**Step 3: Propose Three Measures**
- Measure 1: **Equipment Uptime %** (AggregationFunction = Average, not Sum)
	- Reasoning: Percentage, must average across dates/equipment types (weighted avg by operating hours preferred)
- Measure 2: **Total Maintenance Hours** (AggregationFunction = Sum)
	- Reasoning: Hours spent, sum across equipment and dates to see total maintenance load
- Measure 3: **Breakdown Count** (AggregationFunction = Sum)
	- Reasoning: Count of failures, sum across time/equipment to identify problem equipment or time periods

**Step 4: Document Aggregation Functions**
- For each measure, justify the AggregationFunction choice
- Example: "Uptime% uses Average because summing percentages is nonsensical. If Truck 1 has 95% uptime and Truck 2 has 90%, the fleet doesn't have 185% uptime."
- Consider: Does the measure need weights (e.g., weighted average by equipment age)?

**Step 5: Consider Dimension Relationships**
- Equipment Efficiency fact table relates to: Equipment (dimEquipment), Date (dimDate), Mine (dimMine)
- Sketch: Can users slice maintenance hours by mine? By equipment type? By month?
- Document: Is there a separate Equipment dimension, or do you infer EquipmentType from the fact table?

### Deliverable

- **Input:** v3 FactEquipmentEfficiency table structure
- **Output:** 1–2 paragraph measure group design + three-measure specification table (Measure | Source Column | AggregationFunction | Business Purpose)
- **Evidence:** Specific column names from v3 dataset; aggregation function reasoning; screenshot of v3 table structure
- **Assmang Context:** Example: \"Assmang's operations team needs to identify underperforming equipment before failure impacts production. Equipment Efficiency measure group enables drill-down: 'Show breakdown count by equipment type by month.' Measuring uptime% instead of just raw hours makes cross-equipment comparison valid (95% uptime on a truck is comparable to 95% on a drill rig).\"

### Deliverable

- A written answer (1-2 paragraphs) OR a screenshot of your SSDT/SSMS result.
- Be prepared to explain your reasoning to the trainer.
-   **Input:** v3 FactEquipmentEfficiency table structure
-   **Output:** 1–2 paragraph measure group design + three-measure specification
-   **Evidence:** Specific column names; aggregation function reasoning
-   **Assmang Context:** Example: \"Assmang's operations team needs to identify underperforming equipment. Equipment Efficiency measure group enables: 'Show breakdown count by equipment type by month.' Uptime% instead of raw hours makes cross-equipment comparison valid.\"

---

## Exercise 3

### Objective

Demonstrate why CostPerTonneZAR should be calculated (derived) rather than pre-aggregated, using mathematics and business context.

### Procedure

**Step 1: Understand the Problem**
- Assmang tracks OperatingCost (ZAR) and TonnesProduced for each mine/day/shift
- Business question: "What is the cost per tonne for Sishen mine in Q1?"
- Naive approach: Pre-calculate CostPerTonne in FactProduction, sum it in the cube
- Issue: What does summing ratios mean? Is it correct?

**Step 2: Show Why Summing Ratios Fails**
- Example: Two shifts at Sishen produce:
	- Shift 1: Cost 50,000 ZAR for 100 tonnes = 500 ZAR/tonne
	- Shift 2: Cost 60,000 ZAR for 150 tonnes = 400 ZAR/tonne
- Naive sum: 500 + 400 = 900 ZAR/tonne (WRONG! This is meaningless)
- Correct calculation: (50,000 + 60,000) / (100 + 150) = 110,000 / 250 = 440 ZAR/tonne

**Step 3: Demonstrate the Aggregation Error**
- In SSDT cube designer, calculate what happens if you set CostPerTonneZAR to Sum:
	- Browser shows: Shift 1 CostPerTonne = 500; Shift 2 CostPerTonne = 400
	- Total CostPerTonne (summed) = 900 (INVALID: it's not a true metric anymore)
- Document: Why SSAS ignores the business meaning when you ask it to sum a ratio

**Step 4: Implement as Calculated Measure**
- In cube designer, add calculated measure: CostPerTonneZAR_Calculated
- MDX formula: [Measures].[OperatingCost] / [Measures].[TonnesProduced]
- Test in browser: Does it show 440 ZAR/tonne for both shifts combined? (Expected: Yes)
- If summed incorrectly: 900, document that it's a design error

**Step 5: Document Trade-offs**
- Pre-calculated approach (in fact table, sum in cube):
	- Pros: No SSAS calculation overhead
	- Cons: Only one aggregation option; summing is wrong; can't drill to different granularity
- Calculated measure approach (MDX formula):
	- Pros: Mathematically correct at any drill level; flexible
	- Cons: Slight SSAS CPU cost; requires end-user education about what "calculated" means

### Deliverable

- **Input:** Two-shift scenario with costs and tonnes (per Step 2)
- **Output:** 1–2 paragraph explanation + worked example showing why summing fails
- **Evidence:** Browser screenshot showing calculated CostPerTonneZAR = 440 for combined shifts; MDX formula used; comparison to summed approach (900, marked as WRONG)
- **Assmang Context:** Example: \"Assmang's cost-per-tonne metric must roll up correctly from shifts to daily to monthly. If we sum pre-calculated CostPerTonne, Q1 shows nonsense numbers (e.g., '9,000 ZAR/tonne'). Calculated measures ensure 'Sum of all Q1 tonnes / Sum of all Q1 costs' gives the true Q1 rate, enabling honest production efficiency analysis.\"

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

*Assmang Pty Ltd — SSAS Fundamentals | Day 01 Independent Practice*

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
