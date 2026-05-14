# Later Hands-On Exercises — Introduction to SQL Server Analysis Services
## Day 01 | Assmang Pty Ltd — SSAS Fundamentals

---

## 🎯 Purpose

These exercises are designed for **independent practice** after the guided lab. They are slightly more challenging and are presented with clear step-by-step procedures so you can execute each task confidently.

## 📋 Before You Begin

- Ensure the guided lab for **Introduction to SQL Server Analysis Services** is complete
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

## Exercise 1: Cube Value vs. Traditional Reporting

### Objective

Demonstrate understanding of when and why a multidimensional cube is superior to a static operational report for business analysis.

### Procedure

**Step 1: Review the Theory Context**
- Open **introduction-to-sql-server-analysis-services-theory.md**
- Read the section on "Why Multidimensional Models?"
- Note three limitations of operational reports mentioned

**Step 2: Inspect the Current Cube**
- Open SSMS and connect to Analysis Services
- Navigate to the **Assmang Mining Analytics** cube
- Expand and list the dimensions present: Mine, Department, Employee, Date
- Expand the Date dimension and list the visible hierarchies

**Step 3: Think Like a Manager**
- For each dimension listed above, write one business question that requires flexible drill-down or slicing
- Example: "How do we see production by mine, then by department within a selected mine?"
- Write five such questions, one for each of: Mine, Department, Date, Product/Commodity, and one combining two dimensions

**Step 4: Verify Why Cubes Win**
- For each question from Step 3, consider: Could I answer this with a single SQL report?
- Record why the operational report would fail (static columns, no drill-down, etc.)

**Step 5: Document Your Answer**
- Write 1–2 paragraphs explaining:
  - What the five questions are
  - Why each one is hard to answer with an operational report
  - How the cube enables the answer (flexibility, drill-down, slicing)
  - What Assmang gains from this capability

### Deliverable

- **Input:** List of five business questions + reasoning
- **Output:** 1–2 paragraph explanation or screenshot of cube structure
- **Evidence:** Specific dimension names and hierarchy paths from the Assmang cube
- **Assmang Context:** Example: "The Production Supervisor needs to see tonnes by mine, but also wants to drill into departments within a mine to debug bottlenecks. A traditional report showing all departments across all mines at once is too wide and doesn't support this drill-down workflow."

---

## Exercise 2: Multidimensional vs. Tabular Model Selection

### Objective

Understand the trade-offs between multidimensional and tabular models, and justify the choice for Assmang's environment.

### Procedure

**Step 1: Set Up the Comparison Table**
- Create a simple text table with columns: **Aspect**, **Multidimensional**, **Tabular**, **Assmang Best Choice**
- Rows: Query Language, Hierarchy Support, Performance on Large Fact Tables, Learning Curve, Deployment Size, Real-Time Updates, KPI Support, Maintenance Complexity

**Step 2: Research Each Aspect**
- For each row, check the theory and lecture notes
- Fill in the **Multidimensional** and **Tabular** columns with 2–3 bullet points each
- Example for "Query Language": Multidim = "MDX (custom syntax, steep learning curve)"; Tabular = "DAX (Excel-like formulas, familiar to BI analysts)"

**Step 3: Score Against Assmang Needs**
- In the **Assmang Best Choice** column, write why one model fits Assmang better
- Consider: mine operations, technical skill level of your team, reporting frequency, cube size

**Step 4: Validate with the Deployed Cube**
- Open SSMS and connect to Analysis Services
- Expand **Assmang Mining Analytics** and right-click Properties
- Note the **Storage Mode** (MOLAP = Multidimensional)
- Confirm the deployed model is multidimensional and record why this was chosen

**Step 5: Write Your Recommendation**
- Write 1–2 paragraphs justifying which model (Multidimensional or Tabular) best fits this training environment
- Reference at least two specific Assmang requirements (e.g., complex hierarchies, MDX skills, processing windows)

### Deliverable

- **Input:** Comparison table completed for 8 aspects
- **Output:** 1–2 paragraph recommendation
- **Evidence:** At least two specific Assmang requirements; deployment properties from SSMS
- **Assmang Context:** Example: "Assmang's mine operations team relies on drill-down by mine → department → date, which multidimensional hierarchies support elegantly. The production volume justifies the MDX learning investment because operators already think in dimensional hierarchies."

---

## Exercise 3: Vocabulary Mastery and Assmang Examples

### Objective

Demonstrate understanding of core SSAS vocabulary by defining each term and providing a concrete Assmang example.

### Procedure

**Step 1: Gather Evidence from the Deployed Cube**
- Open SSMS and connect to Analysis Services
- Expand **Databases > Assmang Mining Analytics > Cubes > [Cube Name]**
- Note the cube name and expand **Dimensions** and **Measures**
- Screenshot or note: at least two dimension names, two hierarchy names, two measure names

**Step 2: Define Each Term Using Assmang Objects**
- For each term (Cube, Hierarchy, Attribute, Member, Processing), write 2–3 sentences
- Each definition must include a reference to an actual Assmang object from the cube
- Example for "Cube": "A cube is a multidimensional data container combining measures (like Production Tonnes) and dimensions (like Mine). The Assmang Mining Analytics cube holds production, cost, and KPI data organized by mine, date, and department."

**Step 3: Hierarchy and Member Examples**
- Open the Date dimension in SSDT or SSMS Object Explorer
- Expand a hierarchy (e.g., Date > Year > Quarter > Month > Day)
- Identify and document: the hierarchy name, the attribute levels, and two example members at different levels
- Example: "The Date.Calendar Year hierarchy contains Year (2023, 2024, 2025 are members), Quarter (Q1, Q2, Q3, Q4), and Month (Jan, Feb, ...). Assmang uses this to analyze production trends by month and compare across quarters."

**Step 4: Processing Narrative**
- In SSMS, right-click the Assmang cube and choose **Process** (do not confirm; just inspect the dialog)
- Note the objects listed and their processing type (Full, Incremental, etc.)
- Document: what objects will be processed, why processing is necessary before querying, and what happens if processing fails

**Step 5: Write Your Glossary**
- Write 1–2 paragraphs or a brief glossary table defining all five terms
- Each term must include an Assmang example, not generic SSAS language

### Deliverable

- **Input:** Cube exploration; dimension/hierarchy inspection in SSDT or SSMS
- **Output:** 1–2 paragraph glossary or definition table
- **Evidence:** Specific Assmang dimension names, hierarchy paths, and member examples; screenshot of Processing dialog
- **Assmang Context:** Example: "A Member is a single value within an attribute level. In the Assmang Mining Analytics cube, 'Sishen' is a member of the Mine attribute, and 'Q1 2024' is a member of the Quarter level of the Date hierarchy. Processing must run after deployment so that warehouse tables are loaded into memory for fast queries."

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
