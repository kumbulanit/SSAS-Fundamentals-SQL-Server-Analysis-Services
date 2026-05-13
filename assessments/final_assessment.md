# FINAL ASSESSMENT — SSAS Fundamentals (Aligned Evidence Standard)

## Overview
This assessment validates mastery of SSAS fundamentals across all 8 training topics:
- **Section A:** Assmang-specific multiple choice (concept understanding)
- **Section B:** Procedural scenario validation (application + evidence)
- **Section C:** End-to-end cube design challenge (synthesis + business justification)

**Total time:** 90 minutes  
**Passing score:** 70%+ with evidence quality meeting "Input + Output + Evidence + Assmang Context" standard

---

## SECTION A: MULTIPLE CHOICE (Assmang Mining Analytics Context)

**Question 1:** In the Assmang Mining Analytics cube, which dimension member represents a mine location?
- A) 2024 Q1
- B) TonnesProduced
- C) Sishen
- D) Extract

**Question 2:** Which of the following is a valid drill-down path in Assmang's Date hierarchy?
- A) Mine → Sishen → Chrome
- B) Date → Year → Quarter → Month → Day
- C) Measure → Sum → Average
- D) KPI → Status → Color

**Question 3:** Assmang's FactProduction table is the source for which cube object?
- A) Dimension (Dim_Production)
- B) Measure group (Production)
- C) Hierarchy (Production Year)
- D) Calculated measure (AvgProduction)

**Question 4:** When you deploy an SSAS project in SSDT and then process the cube in SSMS, what happens during processing?
- A) The project is recompiled and errors are checked
- B) Data from FactProduction and dimensions is loaded into memory cubes
- C) Cube objects are created on the SSAS server
- D) Security roles are assigned to users

**Question 5:** Which MDX query correctly shows Sishen's production by quarter for 2024?
- A) SELECT [Measures].[TonnesProduced] WHERE [Mine].[Sishen], [Date].[2024]
- B) SELECT [Measures].[TonnesProduced] ON COLUMNS, [Date].[2024].[Quarter].Members ON ROWS FROM [AssmangMiningAnalytics] WHERE [Mine].[Sishen]
- C) Both A and B are correct syntax
- D) Neither query is valid

**Question 6:** For Assmang's real-time production dashboard (refreshed hourly), which storage mode balances speed with freshness?
- A) MOLAP (fastest, but requires 2+ hour processing)
- B) ROLAP (reads directly from warehouse, slow but fresh)
- C) HOLAP (hybrid: dimension cache + fact on-demand)
- D) Partitioned MOLAP (best for archival data)

**Question 7:** What is the ComplianceScore KPI used for in Assmang's cube?
- A) Tracking safety compliance status (red/amber/green) by mine
- B) Measuring equipment uptime percentage
- C) Calculating cost per tonne
- D) Defining user access roles

**Question 8:** Year-based partitioning of FactProduction helps Assmang because:
- A) It enables parallel processing and faster incremental updates
- B) It reduces query scope to recent data, improving speed
- C) It allows archiving old data separately
- D) All of the above

---

## SECTION B: SCENARIO VALIDATION (Procedural, Evidence-Based)

### Scenario 1: Production Cube Deployment Verification

**Context:** Assmang deployed a new Assmang Mining Analytics cube to production SSAS server. Before releasing to executives, validate it works correctly.

**Your Procedure:**

**Step 1 - Confirm Cube Exists:**
- In SSMS, connect to Analysis Services
- Expand: Databases > Assmang Mining Analytics > Cubes > [Cube Name]
- **Record:** Cube name, deployment date, last processed date

**Step 2 - Validate Structure:**
- Expand Dimensions: Document count and names (should be 4: Mine, Date, Department, Employee)
- Expand Measure Groups: Document count and names (should be 2: Production, OperatingCosts)
- **Record:** Dimension list and measure group list

**Step 3 - Test Baseline Data:**
- SQL Query: `SELECT COUNT(*), SUM(TonnesProduced) FROM FactProduction`
- MDX Query: `SELECT [Measures].[TonnesProduced] WHERE [Mine].[Sishen]`
- **Record:** SQL count/sum; MDX result; do numbers match expectations? (e.g., ~1M tonnes for Sishen)

**Step 4 - Test Drill-Down:**
- In Cube Browser: Drag [Mine] to rows; [Date].[Quarter] to columns; [TonnesProduced] to values
- Inspect: Do all 3–5 mines appear? Do all quarters appear? Are numbers non-zero and reasonable?
- **Record:** Screenshot showing drill-down grid; identify which mine has highest production

**Step 5 - Approval Decision:**
- Write 1–2 sentences: "The cube is production-ready because: [specific evidence from steps 1–4]"

**Deliverable - Evidence Checklist:**
- **Input:** Deployed cube; SSMS connection to SSAS
- **Output:** Validation report with screenshots and validation results
- **Evidence:** 
  - [ ] Screenshot: Cube exists with correct name in Object Explorer
  - [ ] List: All 4 dimensions and 2 measure groups documented
  - [ ] Comparison: SQL count/sum vs MDX result (matching?)
  - [ ] Screenshot: Cube browser showing mine/quarter grid with non-zero values
  - [ ] Decision: "Release approved" or "Hold—issue found: [specific problem]"
- **Assmang Context:** Example: "Cube deployment successful: 3 mines with data, quarters Q1–Q4 visible, Sishen total production = 1.2M tonnes (matches SQL). EquipmentEfficiency KPI showing green for Phalaborwa, amber for Sishen. Ready for executive dashboards."

---

### Scenario 2: Date Hierarchy for Reporting

**Context:** Production supervisors ask: "Why do we need a Date hierarchy instead of just filtering by DateID?"

**Your Procedure:**

**Step 1 - Understand Hierarchy Structure:**
- In SSMS Cube Browser, expand [Date] dimension
- List hierarchy levels: Year > Quarter > Month > Day
- **Record:** How many months in Q1? How many days in January 2024?

**Step 2 - Compare Query Approaches:**
- Without hierarchy: "Get production for Jan 2024: WHERE DateID IN (20240101, 20240102, ..., 20240131)" [30 date IDs, tedious]
- With hierarchy: "Get production for Jan 2024: WHERE [Date].[2024].[Q1].[January]" [one click, intuitive]

**Step 3 - Demonstrate Flexibility:**
- Write two example questions:
  1. "Show Sishen production for Q2 2024" → navigates Date.2024.Q2
  2. "Compare Q1 vs Q2 by day" → drills Date to Month level, then compares aggregates
- **Record:** How does hierarchy enable these questions? (flexible drill-down at any level)

**Step 4 - Explain Business Benefit:**
- Write 1–2 sentences answering: "Why is hierarchy better than flat DateID lookup?"

**Deliverable - Evidence Checklist:**
- **Input:** Assmang cube with Date hierarchy deployed
- **Output:** Explanation with hierarchy walkthrough
- **Evidence:**
  - [ ] Screenshot: Date hierarchy levels shown in Object Explorer
  - [ ] Comparison: "Flat DateID approach vs hierarchy approach" table (rows = complexity/clicks/flexibility)
  - [ ] Example: Two business questions and how hierarchy enables them
  - [ ] Reasoning: 1–2 sentence business justification
- **Assmang Context:** Example: "Hierarchy enables supervisors to click 'Date > 2024 > Q1 > March' and instantly see March production by mine without writing code. Without hierarchy, they'd need date ID lists. Hierarchy makes BI self-service for operational users."

---

### Scenario 3: Pre-Release Quality Checklist

**Context:** You are the BI lead. Executives need the Assmang cube tomorrow for 07:00 AM standup. What checks must pass before release?

**Your Procedure:**

**Step 1 - Data Completeness:**
- SQL: `SELECT COUNT(*) FROM FactProduction` → confirm ≥900K rows
- SQL: `SELECT COUNT(DISTINCT MineID) FROM FactProduction` → confirm all 3–5 mines have data
- **Record:** Total rows, mines represented

**Step 2 - Processing Completeness:**
- Right-click cube > Process (inspect dialog, do NOT confirm)
- Review: Which objects will process? (all dimensions? measure groups? cube?)
- **Record:** Processing objects and order

**Step 3 - Query Performance:**
- MDX: `SELECT [Measures].[TonnesProduced] ON COLUMNS, [Mine].Members ON ROWS FROM [Cube] WHERE [Date].[2024]`
- Measure execution time: Should be <2 seconds
- **Record:** Query time; SLA status (pass/fail)

**Step 4 - Number Validation:**
- SQL baseline: `SELECT SUM(TonnesProduced) FROM FactProduction WHERE MineID=Sishen AND DateID >= 20240101 AND DateID <= 20240331` (Q1 2024)
- MDX check: `SELECT [Measures].[TonnesProduced] WHERE [Mine].[Sishen], [Date].[2024].[Q1]`
- **Record:** SQL sum vs MDX result (must match exactly)

**Step 5 - Release Decision:**
- Write 1 sentence: "Release approved" OR "Hold release—issue: [specific problem]"

**Deliverable - Evidence Checklist:**
- **Input:** Cube deployed and processed
- **Output:** Pre-release validation report
- **Evidence:**
  - [ ] SQL query results: Row count, mine list
  - [ ] Processing dialog screenshot: Objects to be processed
  - [ ] Query performance: Execution time <2 sec?
  - [ ] SQL vs MDX baseline: Results match?
  - [ ] Go/No-Go decision with specific justification
- **Assmang Context:** Example: "Data complete: 1.2M rows, 3 mines. Processing: 4 dimensions + 2 measure groups (est. 5 min). Query latency: 1.2 sec (within SLA). Sishen Q1 SQL=1.5M tonnes = MDX result (valid). RELEASE APPROVED for 07:00 standup."

---

## SECTION C: PRACTICAL CHALLENGE (Cube Design)

### Challenge: Design a Complete Assmang Cube Solution

**Scenario:** Assmang needs a production + costs cube with equipment efficiency metrics. You have v2 dataset loaded. Design the solution.

**Objective:** Create a design document that a developer can implement.

---

### Part C1: Data Model Architecture

**Step 1 - Dimensions (4 total)**

List dimensions and key attributes:

1. **Dim_Mine**
   - Keys: MineID (surrogate), MineName (business)
   - Attributes: Region, MineType, OperatingStatus
   - Hierarchy: (optional) Company > Region > Mine

2. **Dim_Date**
   - Keys: DateID, Date
   - Attributes: Month, Quarter, Year, DayOfWeek
   - Hierarchy: Year > Quarter > Month > Day

3. **Dim_Department**
   - Keys: DepartmentID, DepartmentName
   - Attributes: CostCenter, SupportLevel

4. **Dim_Employee**
   - Keys: EmployeeID, EmployeeName
   - Attributes: JobTitle, Department, HireDate

**Step 2 - Fact Tables (2 total)**

1. **FactProduction**
   - Foreign Keys: DateID, MineID, DepartmentID, EmployeeID
   - Measures: TonnesProduced (Sum), EquipmentHours (Sum)
   - Grain: One row per employee per department per mine per day

2. **FactOperatingCosts**
   - Foreign Keys: DateID, MineID
   - Measures: MaintenanceCost (Sum), LaborCost (Sum), TotalCost (Sum)
   - Grain: One row per mine per day

**Step 3 - Measure Groups (2 total)**

**Measure Group 1: Production**
- Measures: TonnesProduced (Sum), EquipmentHours (Sum), EquipmentCount (Max)
- Dimensions: Mine, Date, Department, Employee (all drillable)

**Measure Group 2: OperatingCosts**
- Measures: MaintenanceCost (Sum), LaborCost (Sum), TotalCost (Sum)
- Dimensions: Mine, Date (not Employee or Department)

**Step 4 - Calculated Measures (1 required)**

**Calculated Measure 1: CostPerTonneZAR**
- Formula: `[Measures].[TotalCost] / [Measures].[TonnesProduced]`
- Aggregation: Calculated (not Sum)
- Why: Enables cost efficiency comparison across mines; semi-additive metric
- Example: "Sishen = 450 ZAR/tonne; Khumani = 480 ZAR/tonne" helps identify high-cost operations

**Step 5 - KPI (1 required)**

**KPI 1: EquipmentEfficiencyKPI**
- Value: `[Measures].[TonnesProduced] / [Measures].[EquipmentHours]`
- Goal: 50 (tonnes per equipment hour target)
- Status Expression: `IIF([EquipmentEfficiencyKPI] >= 50, 1, IIF([EquipmentEfficiencyKPI] >= 40, 0, -1))`
  - Status=1: Green (≥50 tonnes/hr, equipment running efficiently)
  - Status=0: Amber (40–49 tonnes/hr, trending down, investigate)
  - Status=-1: Red (<40 tonnes/hr, equipment underperforming, maintenance needed)
- Why: Operations team needs equipment health status; red status triggers maintenance review

**Step 6 - Processing & Deployment Plan**

| Step | Action | Timing | Owner |
|------|--------|--------|-------|
| 1 | Build project in SSDT | 5 min | Dev |
| 2 | Validate no build errors | 5 min | Dev |
| 3 | Deploy to production SSAS | 10 min | Dev |
| 4 | Full process (all dimensions + measure groups) | 15 min | DBA |
| 5 | Validate: SQL baseline vs MDX query | 10 min | QA |
| 6 | Release approved for executives | 2 min | Lead |
| | **Total** | **~45 min** | |

---

### Part C2: Solution Submission (Evidence Standard)

**Input:** v2 dataset (FactProduction, FactOperatingCosts, Dim_* tables loaded)

**Output:** Cube design document (1–2 pages) with:
- [ ] Dimension definitions (4 total) with attributes
- [ ] Fact table definitions (2 total) with grain and foreign keys
- [ ] Measure group specifications (measures, dimensions, aggregation functions)
- [ ] Calculated measure formula and business justification
- [ ] KPI definition (value, goal, status thresholds, business purpose)
- [ ] Processing/deployment timeline with time estimates

**Evidence to Submit:**
- [ ] Design document (Word, PDF, or screenshot from SSDT)
- [ ] Sample MDX Query #1 using CostPerTonneZAR: "Show cost per tonne by mine for 2024"
  - Query: `SELECT [Measures].[CostPerTonneZAR] ON COLUMNS, [Mine].Members ON ROWS FROM [Cube] WHERE [Date].[2024]`
  - Expected result: 3–5 mines with cost per tonne values (e.g., 450–500 ZAR/tonne)
- [ ] Sample MDX Query #2 using EquipmentEfficiencyKPI: "Show equipment efficiency status by mine"
  - Query: `SELECT [KPI].[EquipmentEfficiencyKPI] ON COLUMNS, [Mine].Members ON ROWS`
  - Expected result: Red/Amber/Green status for each mine
- [ ] Processing validation plan: "After deployment, run [MDX Query #1] and confirm results match SQL baseline"

**Assmang Context:**

Write 1–2 sentences explaining how this cube supports Assmang operations:

Example: "This cube enables production managers to see tonnes produced per equipment hour by mine by month, identifying which mines and shifts are most efficient. The CostPerTonneZAR calculated measure helps CFO compare mining economics across Sishen, Khumani, and Phalaborwa, justifying equipment investments in high-cost operations. The EquipmentEfficiencyKPI provides daily status flags: green mines run normal, amber mines warrant investigation, red mines trigger maintenance escalation. Together, these metrics support production optimization and predictive equipment maintenance."

---

## ASSESSMENT RUBRIC

| Criterion | Exceeds (90–100%) | Meets (70–89%) | Below (< 70%) |
|-----------|------------------|-----------------|---------------|
| **Section A** | 8/8 MC correct with Assmang context | 6–7/8 correct | < 6 correct |
| **Section B: Procedural Depth** | All 5 steps documented with screenshots; evidence clear | 4 steps documented; some evidence missing | < 3 steps; minimal evidence |
| **Section B: Evidence Quality** | Input + Output + Evidence + Assmang interpretation all present | 2–3 of 4 evidence elements present | < 2 elements; vague |
| **Section C: Design Completeness** | All 4 dimensions, 2 fact tables, 1 calc measure, 1 KPI documented | 3–4 dimensions, 1 fact table, partial calc measure | < 3 dimensions; missing KPI |
| **Section C: Business Justification** | Clear link to Assmang operations; specific metrics named | Generic explanation; limited context | No business connection |
| **Overall Score** | ≥90% across all sections | 70–89% average | < 70% |

---

## PASSING CRITERIA

To pass this assessment, you must:
1. Score ≥70% on Section A (≥5/8 correct)
2. Complete ALL procedure steps in Section B with documented evidence
3. Submit complete cube design (Section C) with Assmang business context
4. Use Assmang-specific terminology (dimension names, measure group names, KPI examples) throughout

Strong answers demonstrate mastery of SSAS concepts AND ability to apply them to real business scenarios (Assmang mining operations).

---

*Assmang Pty Ltd — SSAS Fundamentals Final Assessment*
*Evidence-Based Standard: Input + Output + Explanation + Assmang Context*
