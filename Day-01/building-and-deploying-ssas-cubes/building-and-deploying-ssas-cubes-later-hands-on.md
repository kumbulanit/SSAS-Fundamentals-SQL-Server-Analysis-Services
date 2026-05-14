# Later Hands-On Exercises — Building and Deploying SSAS Cubes
## Day 01 | Assmang Pty Ltd — SSAS Fundamentals

---

## 🎯 Purpose

These exercises are designed for **independent practice** after the guided lab. They are slightly more challenging and are presented with clear step-by-step procedures so you can execute each task confidently.

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
