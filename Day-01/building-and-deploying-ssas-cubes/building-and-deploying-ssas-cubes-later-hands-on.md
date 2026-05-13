# Later Hands-On Exercises — Building and Deploying SSAS Cubes
## Day 01 | Assmang Pty Ltd — SSAS Fundamentals

---

## 🎯 Purpose

These exercises are designed for **independent practice** after the guided lab. They are slightly more challenging and require you to apply what you've learned without step-by-step guidance.

## 📋 Before You Begin

- Ensure the guided lab for **Building and Deploying SSAS Cubes** is complete
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

Create a production-ready deployment checklist that ensures data integrity and deployment success without requiring trainer intervention.

### Procedure

**Step 1: Review Current Assmang Cube Deployment**
- In SSDT, open Project Properties > Deployment
- Document: Target server, target database name, deployment options
- Check: Is deployment server correct? Is database name production-safe (not "TestCube1")?

**Step 2: Design Pre-Deployment Validation**
- Create checklist section 1: **Before Building**
	- [ ] Data source connection tested and valid
	- [ ] DSV relationships verified (FK joins look correct)
	- [ ] All required dimensions exist (Mine, Department, Employee, Date)
	- [ ] All required fact tables present (FactProduction, FactOperatingCosts)
	- [ ] No unresolved design errors in dimensions or cube
	- [ ] Documentation of any known warnings (if unavoidable)

**Step 3: Build and Test Locally**
- Create checklist section 2: **Build Process**
	- [ ] Run Build > Build Solution in Visual Studio
	- [ ] Read Error List; zero errors required to proceed
	- [ ] Review warnings; document any accepted warnings with justification
	- [ ] Build completed successfully message displayed

**Step 4: Deployment Sequence**
- Create checklist section 3: **Deployment**
	- [ ] Right-click SSAS Project > Deploy
	- [ ] Deployment dialog shows correct target database name
	- [ ] Click Deployment Process; review target server, user account, SSAS database objects
	- [ ] Deployment completes without errors
	- [ ] In SSMS, verify SSAS database exists with all objects visible

**Step 5: Post-Deployment Processing**
- Create checklist section 4: **Processing**
	- [ ] Right-click Cube > Process
	- [ ] Processing dialog: review objects to process (dimension + measure groups + cube)
	- [ ] Note cascade processing effect (processing cube triggers dimension/measure group processing)
	- [ ] Click Run and wait for completion
	- [ ] Read warnings in processing log, not just success message
	- [ ] Confirm all objects processed, no failures

**Step 6: Validation**
- Create checklist section 5: **Post-Deployment Validation**
	- [ ] In SSMS Object Explorer, expand cube and verify objects exist (dimensions, measure groups)
	- [ ] Open Cube Browser; query one measure (e.g., TonnesProduced) by Mine dimension
	- [ ] Verify numbers are non-zero and reasonable
	- [ ] Run one MDX query in Analysis Services connection; compare to SQL source data
	- [ ] Document success: "Production cube deployed and verified [date/time]"

### Deliverable

- **Input:** Current Assmang deployment setup in SSDT
- **Output:** Checklist document (5-6 sections, 20-25 items) written for junior BI developer
- **Evidence:** Specific checkbox items from actual Assmang deployment procedure; screenshot of SSDT deployment settings; example browser output
- **Assmang Context:** Example: \"A junior developer must verify the target database name is 'AssmangMiningProduction', not 'TestCube', before deploying. Our checklist ensures no data overwrites wrong production cubes. If processing fails, the 'Read warnings not just success message' step catches errors that appear in the log but miss casual observers.\"

---

## Exercise 2

### Objective

Design a production-grade incremental processing strategy that refreshes Assmang's daily mining data while minimizing cube downtime and server load.

### Procedure

**Step 1: Understand Assmang's Refresh Requirements**
- Assmang mines operate 24/7; production data flows to warehouse continuously
- Business need: Daily production reports in the cube (refreshed at 06:00 AM each day)
- Constraint: Users query the cube starting at 07:00 AM; cannot afford 1+ hour downtime
- Current approach: Full cube process each night (loads entire fact tables from scratch)
- Problem: Full processing takes 45 minutes; during refresh, cube unavailable

**Step 2: Define Incremental Processing Strategy**
- **Full vs. Incremental:**
	- Full: Process entire dimensions and fact tables (required first time, or when structure changes)
	- Incremental: Process only new/changed data since last refresh (faster, smaller memory footprint)
- **For Assmang:**
	- Frequency: Daily at 06:00 AM
	- Scope: Only yesterday's production data (new rows in FactProduction)
	- Impact: Reduces processing from 45 minutes to ~10 minutes

**Step 3: Design Incremental Process Steps**
- Step 1 (06:00 AM): SQL ETL loads new rows to FactProduction WHERE DateID = [yesterday]
- Step 2 (06:15 AM): SSAS Incremental Process on measure groups
	- Right-click FactProduction measure group > Process
	- Choose Incremental (not Full)
	- SSAS adds only new fact rows to cube
- Step 3 (06:25 AM): Validate cube (select one measure, confirm yesterday's totals)
- Step 4 (06:30 AM): Notify users "Cube refreshed; ready for queries"
- By 07:00 AM: Cube available, fresh, under 5-minute downtime

**Step 4: Consider Failure Recovery**
- If incremental process fails: Fall back to full process (slower but guaranteed)
- If ETL fails (no new data loaded): Skip SSAS process; use old data (acceptable short-term)
- Document: What happens if process runs twice by accident? (Idempotent design needed)

**Step 5: Document Strategy**
- Write 1–2 paragraphs explaining:
	- Why incremental beats full for daily refresh
	- Processing time and downtime estimate
	- Assumptions (new data only, no SCD Type 2 updates, no dimension changes)
	- Failure scenario (what if process fails at 06:20 AM with 40 minutes until users arrive?)

### Deliverable

- **Input:** Assmang's refresh requirements (24/7 operations, 06:00 daily refresh, 07:00 user access)
- **Output:** 1–2 paragraph strategy + timeline diagram (SQL load 0-15 min → SSAS process 15-30 min → Validate 30-35 min)
- **Evidence:** Processing time savings calculation (45 min full → 10 min incremental); screenshot of SSDT Process dialog with Incremental option selected
- **Assmang Context:** Example: \"Assmang's shift supervisors need yesterday's production in the cube by 07:00 AM for daily standup meetings. Full processing (45 min) would delay the 06:00 refresh window by business hours, missing the 07:00 meeting. Incremental processing (10 min) gets fresh data ready in time, with 50-minute safety margin before queries start.\"

---

## Exercise 3

### Objective

Create five concrete validation checks that ensure a new Assmang cube version is production-ready before hand-off to management.

### Procedure

**Step 1: Define "Production-Ready"**
- New cube version includes: new dimensions, new measures, or design changes
- Example: Assmang wants to add Equipment Efficiency measure group to existing Production cube
- Risk: Bad data or broken logic could mislead management decisions
- Goal: Five checks to catch errors before release

**Step 2: Check 1 — Deployment Verification**
- Confirm: Cube deployed successfully to production SSAS server
- Action: In SSMS, connect to Analysis Services, expand Databases, verify database name is "AssmangMiningProduction" (not Dev/Test)
- Validation: All dimensions and measure groups visible in Object Explorer
- Evidence: Screenshot showing correct database and all objects present

**Step 3: Check 2 — Processing Verification**
- Confirm: All objects processed, no errors in processing log
- Action: Right-click Cube > Process > review dialog; Run; read results pane carefully
- Validation: Message shows "Successfully processed [Date/Time]"; no failed objects listed
- Evidence: Screenshot of processing completion message; confirm all warnings documented

**Step 4: Check 3 — Data Volume Baseline**
- Confirm: Cube contains expected volume of data
- Action: Write baseline MDX query: SELECT [Measures].[TonnesProduced] ON COLUMNS, [Dimension].[Mine].[Member].Members ON ROWS
- Validation: Compare SSAS result against SQL baseline query (SUM(TonnesProduced) FROM FactProduction)
- Evidence: Screenshot of MDX result; SQL result; numerical match verification

**Step 5: Check 4 — Hierarchy Navigation**
- Confirm: Dimensions drill correctly at every level
- Action: In SSMS Cube Browser, expand Mine dimension; click each hierarchy level (if any)
- Validation: Hierarchies expand; members load at each level; no errors or timeouts
- Evidence: Screenshot showing drill-down from top to leaf level; counts match expected

**Step 6: Check 5 — Business Logic Accuracy**
- Confirm: New measures aggregate correctly; calculated measures compute accurately
- Action: Hand-pick one real business scenario
	- Example: "Show Equipment Efficiency % for Sishen mine, Q1 2024"
	- In Browser, slice by Mine=Sishen, Date=Q1 2024, verify Equipment Efficiency%
	- Manually verify: (EquipmentUptime hours / Total operating hours) = displayed % matches expected
- Validation: Calculated measure formula correct; business interpretation sound
- Evidence: Browser output; manual calculation; one-sentence business interpretation (e.g., "Sishen equipment was 94% efficient in Q1")

**Step 7: Document Release Certificate**
- Write 1–2 paragraphs or checklist form confirming:
	- All five checks passed
	- Deployment date and version number
	- Any known limitations or caveats
	- Sign-off: "Release approved for management queries as of [date]"

### Deliverable

- **Input:** New cube version with new measures/dimensions ready for release
- **Output:** Five-check validation form + release certificate (1–2 paragraphs)
- **Evidence:** Screenshots for Check 1 (deployment), Check 2 (processing), Check 3 (data volume match), Check 4 (hierarchy drill), Check 5 (business logic verification)
- **Assmang Context:** Example: \"Before releasing the Equipment Efficiency cube update to production managers, we verify: (1) Cube deployed to production database, (2) All objects processed error-free, (3) Total tonnes match SQL baseline, (4) Mine dimension drills correctly, (5) Equipment Efficiency% for Sishen = 94%, matching manual calc (1500/1600 operating hours). Release approved: 2024-01-15.\"

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
