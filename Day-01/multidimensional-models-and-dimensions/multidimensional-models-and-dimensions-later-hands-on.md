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
