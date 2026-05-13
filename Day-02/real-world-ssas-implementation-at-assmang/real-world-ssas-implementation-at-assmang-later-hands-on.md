# Later Hands-On Exercises — Real-World SSAS Implementation at Assmang
## Day 02 | Assmang Pty Ltd — SSAS Fundamentals

---

## 🎯 Purpose

These exercises are designed for **independent practice** after the guided lab. They are slightly more challenging and require you to apply what you've learned without step-by-step guidance.

## 📋 Before You Begin

- Ensure the guided lab for **Real-World SSAS Implementation at Assmang** is complete
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

## Exercise 1

Create a mini solution blueprint for an executive production dashboard sourced from the cube.

### Hints

- Think about how this connects to a real business question at Assmang.
- There may be multiple correct approaches — choose the one you can explain clearly.
### Deliverable

- Be prepared to explain your reasoning to the trainer.
Objective

Procedure
**Step 2:** Dashboard pages: (1) Operations = TonnesProduced by Mine/Month drillable to dept, (2) Finance = RevenueMln vs BudgetMln quarterly trends, (3) Safety = ComplianceScore KPI by mine  
**Step 3:** MDX queries: Production by Mine/Dept/Date; Revenue by Mine/Quarter; Safety KPI slice
**Step 5:** Architecture: SSAS cube → Power BI/Tableau; role-based security (COO all mines, regional director assigned only)
**Step 6:** Performance: <2 sec query response SLA; audit logging; read-only access
- **Evidence:** Wireframe, sample queries, role matrix
- **Assmang Context:** "Executives drive staffing/budget/escalation daily. Dashboard: 'Khumani -8% → investigate; Sishen safety red → audit.' Facts enable decisions across 5 mines, 3K employees."

### Deliverable

- A written answer (1-2 paragraphs) OR a screenshot of your SSDT/SSMS result.
- Be prepared to explain your reasoning to the trainer.

---

## Exercise 3

### Task

List risks that could reduce trust in the cube and propose controls for each one.

### Hints

- Refer back to the theory for **Real-World SSAS Implementation at Assmang** if you get stuck.
- Think about how this connects to a real business question at Assmang.
- There may be multiple correct approaches — choose the one you can explain clearly.

### Deliverable

- A written answer (1-2 paragraphs) OR a screenshot of your SSDT/SSMS result.
- Be prepared to explain your reasoning to the trainer.

---

## ✅ Success Criteria

Your exercises are considered successful when:

- Your answer reflects the topic's **business purpose**, not only the technical steps.
- You can explain **why** the design or query choice fits Assmang's reporting needs.
- You can connect your answer back to dimensions, measures, hierarchies, MDX, or deployment where relevant.
- Your work is **documented clearly** enough that a colleague could understand it.
## 💡 Stretch Challenge (Optional)

If you finish early, try to extend one of the exercises above by combining it with a concept from a previous topic. For example, if this topic covers measures, try connecting your measure design to a specific dimension hierarchy from an earlier topic.

*Assmang Pty Ltd — SSAS Fundamentals | Day 02 Independent Practice*

---
1. Open SSMS and connect to the **Database Engine** that hosts `AssmangMining`.
2. Open the topic dataset script only if the lab requires a fresh load, then execute it and wait for a clean completion message in the Messages pane.
8. Expand the SSAS database and inspect the cube, dimensions, and other objects so you know the metadata you are about to query.
9. If you need to process objects, remember the project must already be deployed and the account must have SSAS admin rights plus read access to the relational source through the data source impersonation settings.
16. Compare at least one SSAS result against the SQL baseline from the Database Engine connection.
17. Save important queries with meaningful names so you can reuse them during assessments.
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
