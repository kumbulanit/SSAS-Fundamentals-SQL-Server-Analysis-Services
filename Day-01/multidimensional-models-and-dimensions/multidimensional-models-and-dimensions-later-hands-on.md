# Later Hands-On Exercises — Multidimensional Models and Dimensions
## Day 01 | Assmang Pty Ltd — SSAS Fundamentals

---

## 🎯 Purpose

These exercises are designed for **independent practice** after the guided lab. They are slightly more challenging and are presented with clear step-by-step procedures so you can execute each task confidently.

## 📋 Before You Begin

- Ensure the guided lab for **Multidimensional Models and Dimensions** is complete
- Dataset **`v1_assmang_mining_base.sql`** must be loaded
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

Design and justify a Dim_Shift dimension structure that supports shift-based mining analytics.

### Procedure

**Step 1: Understand Assmang Shift Operations**
- Assmang mines operate 24/7 with shifts (Day, Night, Swing)
- Each shift has supervisor, equipment assigned, production targets
- Need to analyze production, safety incidents, and equipment efficiency by shift

**Step 2: Design Dimension Attributes**
- Identify required attributes: ShiftID, ShiftName, StartTime, EndTime, ShiftType, EquipmentAssigned, SupervisorName
- Categorize as: User-facing (ShiftName, ShiftType) vs. Technical (ShiftID)
- Document which attributes support business questions

**Step 3: Propose Hierarchies**
- Option 1 (Simple): Shift Name only
- Option 2 (Moderate): ShiftType > ShiftName
- Option 3 (Complex): Company > Mine > Department > ShiftType > ShiftName
- Write why one hierarchy fits Assmang shift analytics best

**Step 4: Consider Processing Impact**
- Note: Adding a new dimension requires:
	1. Adding table to DSV
	2. Creating new dimension
	3. Adding to cube (new dimension usage row)
	4. Re-processing entire cube
- Document: estimated processing time, storage impact, query performance trade-offs

**Step 5: Validate Concept**
- In SSDT, inspect current dimensions to see attribute and hierarchy patterns
- Check whether Dim_Shift should follow the same design pattern

### Deliverable

- **Input:** Shift operations context from Assmang business requirements
- **Output:** 1–2 paragraph Dim_Shift design proposal
- **Evidence:** Attribute list; hierarchy options with business justification; processing impact assessment
- **Assmang Context:** Example: "Assmang operates Day, Night, and Swing shifts at each mine. A ShiftType > ShiftName hierarchy lets production managers see total output per shift across mines, then drill to individual shift operational details. Adding this dimension requires full cube reprocessing but enables drill-down analysis that wasn't possible before.\"

---

## Exercise 2

### Objective

Analyze a business scenario involving employee transfers and recommend a Slowly Changing Dimension (SCD) strategy for Assmang.

### Procedure

**Step 1: Define the Scenario**
- Assmang employee Thabo has been in the Extraction Department
- In Q2 2024, Thabo is promoted to the Planning Department
- Business question: Does Assmang want historical production (Q1 2024) credited to Extraction or re-assigned to Planning?

**Step 2: Review SCD Type 1 (Overwrite)**
- Definition: Update the employee record; history shows current department
- Example: Update Thabo's record to Planning; old FactProduction rows still point to Planning via DimEmployee FK
- Impact on reporting: Department totals unchanged (Planning gets all Thabo's production), but employee mobility is hidden
- Best for: When only current organizational structure matters

**Step 3: Review SCD Type 2 (History)**
- Definition: Keep two employee records (old and new with dates); old FactProduction rows point to old record, new rows to new
- Example: Insert two Thabo records (EmployeeKey 101 = Extraction/Q1, EmployeeKey 102 = Planning/Q2+)
- Impact on reporting: Q1 production stays with Extraction; Q2+ with Planning; true department history preserved
- Best for: When historical accuracy and department accountability matter

**Step 4: Decide for Assmang**
- Write 1–2 paragraphs answering:
	- Which type fits Assmang's business model?
	- Do mine managers care about where production physically happened (Q1 Extraction) or only current organization?
	- Does Thabo's promotion signal he was doing Planning work (Type 1) or he moved from Extraction to Planning (Type 2)?

**Step 5: Document ETL Impact**
- Type 1 implications: Simpler ETL, smaller dimension, but loses history
- Type 2 implications: More complex ETL (insert on change, manage dates), larger dimension, but preserves business truth

### Deliverable

- **Input:** Scenario (employee promotion in Q2) + current Dim_Employee structure
- **Output:** 1–2 paragraph recommendation (Type 1 or Type 2)
- **Evidence:** Pros/cons analysis; impact on department reporting; ETL complexity
- **Assmang Context:** Example: "Use Type 2 because mining production is tied to where the work physically occurred. Q1 tons extracted by Thabo's team happened in Extraction, not Planning. For accurate departmental cost-per-ton and productivity analysis, those tons must stay credited to Extraction. Type 2 preserves business integrity.\"

---

## Exercise 3

### Objective

Audit each Assmang dimension and recommend which attributes should be hidden from end users to improve usability.

### Procedure

**Step 1: List Current Attributes in Each Dimension**
- Open SSDT and inspect each dimension:
	- Dim_Mine: MineID, MineName, Region, RegionID, Country, MineCode, MineType, Latitude, Longitude, CostCenter
	- Dim_Department: DepartmentID, DepartmentName, CompanyID, DepartmentCode, SafetyRating
	- Dim_Employee: EmployeeID, EmployeeName, EmployeeCode, Department, JobTitle, HireDate, EmployeeKey
	- Dim_Date: DateKey, FullDate, YearKey, QuarterKey, MonthKey, DayOfWeek, CalendarYear, QuarterName, MonthName
- Document all visible attributes per dimension

**Step 2: Classify Attributes by Role**
- **User-Facing** (business analysis): MineName, Region, MineType, DepartmentName, JobTitle, CalendarYear, MonthName
- **Technical/Keys** (system only): MineID, RegionID, DepartmentID, EmployeeID, DateKey, YearKey, QuarterKey, MonthKey
- **Specialized** (use case specific): Latitude, Longitude (maps), CostCenter (accounting), EmployeeCode (HR systems)
- **Legacy** (rarely used): MineCode, DepartmentCode, EmployeeCode (if not needed for daily analysis)

**Step 3: Hide Technical Attributes in SSDT**
- For each ID/Key attribute, right-click → Properties → Hidden = True
- Hide attributes where Hidden makes user interface cleaner without losing business capability
- Example: Hide MineID because "M1", "M2", "M3" are meaningless; keep MineName because "Sishen" is the business meaning

**Step 4: Review Impact on Hierarchies**
- Confirm hidden attributes are NOT used as levels in user hierarchies
- If a key attribute is used in a hierarchy, do NOT hide it (it would break the hierarchy)
- Document any attributes that cannot be hidden due to hierarchy dependencies

**Step 5: Document Changes**
- Write 1–2 paragraphs summarizing:
	- Which attributes are hidden and why
	- How hiding improves user experience (cleaner drill lists)
	- Any constraints (hidden attributes still used for keys/joins, just not visible)

### Deliverable

- **Input:** All dimensions and attributes from SSDT
- **Output:** 1–2 paragraph summary + itemized hidden attributes list
- **Evidence:** Specific attribute names marked as Hidden; screenshot from SSDT showing Hidden = True in Properties pane
- **Assmang Context:** Example: \"Hide MineID (surrogate keys like 1, 2, 3 are meaningless to operators). Keep MineName visible because 'Sishen' is the business meaning. Hidden attributes reduce visual clutter without losing functionality. Users still drill and slice on the business concepts that matter.\"

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
