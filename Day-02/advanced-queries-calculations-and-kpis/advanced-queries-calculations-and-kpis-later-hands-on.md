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
- KPI component 3 (Status Expression):

> ✅ **COPY AND PASTE this expression into the KPI Status Expression field in the SSDT KPI designer:**

```mdx
IIF([Measures].[ComplianceScore] >= 95, 1,
    IIF([Measures].[ComplianceScore] >= 80, 0, -1))
```

> `1` = Green (≥95%), `0` = Amber (80–94%), `-1` = Red (<80%)

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
- Calculated measure name: `MaintenanceCostPercent`
- MDX formula:

> ✅ **COPY AND PASTE this formula into the Calculations tab expression field in SSDT:**

```mdx
([Measures].[MaintenanceCost] / [Measures].[TotalOperatingCost]) * 100
```

> Add `FORMAT_STRING = "0.00"` to display with 2 decimal places.

- Test formula logic: If MaintenanceCost = 150 and TotalOperatingCost = 1000, result = 15.00 ✓

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

**Step 2: Identify the Chrome Mine**
- Inspect Assmang's mine portfolio:
  - **Khumani** — iron ore, Northern Cape
  - **Beeshoek** — iron ore, Northern Cape
  - **Black Rock** — manganese, Northern Cape
  - **Dwarsrivier** — **chrome**, Limpopo ← this is the only chrome mine
- Define named set member: `[Mine].[Mine Name].&[Dwarsrivier]`

> ⚠️ **Common mistake:** Sishen does not exist in the Assmang dataset. Khumani is an **iron ore** mine, not chrome. The chrome mine is **Dwarsrivier**.

**Step 3: Create Named Set in SSDT Cube**
- In cube designer, go to Calculations tab
- Add new calculation → Named Set
- Name: `ChromeMines`
- Expression:

> ✅ **COPY AND PASTE this expression into the Named Set Expression field in SSDT:**

```mdx
{ [Mine].[Mine Name].&[Dwarsrivier] }
```

> This set contains only Dwarsrivier, Assmang's single chrome mine. If additional chrome mines are ever added to the dataset, add them to this set and all queries update automatically.

- Save and deploy

**Step 4: Write Query #1 Using Named Set**
- Query: "Show total production for chrome operations by year"

> ✅ **COPY AND PASTE into a new SSMS MDX query window:**

```mdx
-- Without named set (verbose):
SELECT { [Measures].[TonnesProduced] } ON COLUMNS,
       [Date].[Calendar].[Calendar Year].MEMBERS ON ROWS
FROM [Assmang Mining Analytics]
WHERE ( [Mine].[Mine Name].&[Dwarsrivier] );

-- With named set (concise — after defining [ChromeMines] in the cube):
SELECT { [Measures].[TonnesProduced] } ON COLUMNS,
       [Date].[Calendar].[Calendar Year].MEMBERS ON ROWS
FROM [Assmang Mining Analytics]
WHERE [ChromeMines];
```

> 📸 **Expected result:** 2 rows — 2023 and 2024 — each showing Dwarsrivier's total chrome tonnes (~187,200 per year)

**Step 5: Write Query #2 Using Same Named Set**
- Query: "Show cost per tonne for chrome operations in 2024"

> ✅ **COPY AND PASTE into a new SSMS MDX query window:**

```mdx
SELECT { [Measures].[Cost Per Tonne ZAR] } ON COLUMNS,
       [ChromeMines] ON ROWS
FROM [Assmang Mining Analytics]
WHERE ( [Date].[Calendar Year].&[2024] );
```

> 📸 **Expected result:** 1 row — Dwarsrivier Mine with its 2024 cost per tonne figure (approximately R350–R500/t depending on dataset values)

**Step 6: Document Named Set**
- Write 1–2 paragraphs explaining:
	- What the named set represents (Dwarsrivier — Assmang's only chrome mine in Limpopo)
	- Why it's useful (consistency, maintainability, reduces query complexity)
	- Business meaning (enables quick chrome-vs-iron-ore comparisons across reports)
	- Example: "If Assmang acquires a second chrome mine in future, update [ChromeMines] once; all reports automatically include the new mine"

### Deliverable

- **Input:** Mine dimension with chrome mine identified (Dwarsrivier)
- **Output:** Named set definition + two complete MDX queries using the named set
- **Evidence:** Screenshots of (1) SSDT Calculations tab showing [ChromeMines] definition, (2) Query #1 result (production by year for Dwarsrivier), (3) Query #2 result (cost per tonne for chrome); one-line comparison showing how named set simplified the WHERE clause
- **Assmang Context:** "Dwarsrivier is Assmang's only chrome mine. Chrome is a high-value commodity. Using a [ChromeMines] named set means all dashboards filtering to chrome operations stay consistent. When a second chrome mine is added to the portfolio, update one expression and all 10+ reports update automatically."

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
