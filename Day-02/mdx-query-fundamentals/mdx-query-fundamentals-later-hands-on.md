# Later Hands-On Exercises — MDX Query Fundamentals
## Day 02 | Assmang Pty Ltd — SSAS Fundamentals

---

## 🎯 Purpose

These exercises are designed for **independent practice** after the guided lab. They are slightly more challenging and are presented with clear step-by-step procedures so you can execute each task confidently.

## 📋 Before You Begin

- Ensure the guided lab for **MDX Query Fundamentals** is complete
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

Write and validate an MDX query that isolates production for chrome-specific mining operations at Assmang.

### Procedure

**Step 1: Understand the Business Question**
- Assmang mines multiple commodities: iron ore, manganese, and chrome
- The chrome mine is **Dwarsrivier** (Limpopo province)
- Business question: "What was total chrome production in 2024?"
- Expected answer: A single number representing all chrome tonnes from Dwarsrivier

**Step 2: Identify the Correct Member Reference**
- In SSMS, open the Assmang Mining Analytics cube browser
- Expand the **Mine** dimension → **Mine Geography** hierarchy
- Expand Chrome → Limpopo → you will see **Dwarsrivier Mine**
- The correct member path is: `[Mine].[Mine Geography].[Mine Name].&[Dwarsrivier]`
- For filtering by commodity group, use: `[Mine].[Mine Type].&[Chrome]`

> ⚠️ **Common mistake:** `[Mine].[Chrome Mines]` is **not** a valid member expression — it looks like an attribute value but is not. Always specify the full hierarchy path: `[Mine].[Mine Type].&[Chrome]` or `[Mine].[Mine Name].&[Dwarsrivier]`.

**Step 3: Write the MDX Query**

> ✅ **COPY AND PASTE into a new SSMS MDX query window:**

```mdx
-- Exercise 1: Chrome production in 2024
-- Uses Mine Type hierarchy to filter to chrome operations
SELECT
    { [Measures].[TonnesProduced] } ON COLUMNS
FROM [Assmang Mining Analytics]
WHERE (
    [Mine].[Mine Type].&[Chrome],
    [Date].[Calendar Year].&[2024]
);
```

> 📸 **Expected result:** A single value — Dwarsrivier chrome tonnes for 2024, approximately 187,200 tonnes (based on ~15,600 t/month × 12 months).

**Step 4: Validate Against SQL Baseline**

> ✅ **COPY AND PASTE into an SSMS SQL query window (Database Engine connection):**

```sql
-- SQL baseline for chrome production 2024
SELECT SUM(fp.TonnesProduced) AS ChromeTonnes2024
FROM FactProduction fp
INNER JOIN Dim_Mine dm ON fp.MineID = dm.MineID
INNER JOIN Dim_Date dd ON fp.DateID = dd.DateID
WHERE dm.MineType = 'Chrome'
  AND dd.CalendarYear = 2024;
```

> The MDX result and the SQL result should match exactly. If they differ, check that the cube has been processed after the latest data load.

**Step 5: Extend the Query to Show Mine Name on Rows**

> ✅ **COPY AND PASTE:**

```mdx
-- Extended: show chrome production by mine name on rows
SELECT
    { [Measures].[TonnesProduced] } ON COLUMNS,
    [Mine].[Mine Geography].[Mine Name].MEMBERS ON ROWS
FROM [Assmang Mining Analytics]
WHERE (
    [Mine].[Mine Type].&[Chrome],
    [Date].[Calendar Year].&[2024]
);
```

> 📸 **Expected result:** 1 row — Dwarsrivier Mine with its 2024 total. (There is only one chrome mine in the Assmang dataset.)

### Deliverable

- **Input:** Chrome mine filter requirement, 2024 date filter
- **Output:** Working MDX query + SQL baseline comparison
- **Evidence:** Screenshot of SSMS MDX window with result; SQL baseline query showing same total
- **Assmang Context:** "Dwarsrivier is Assmang's chrome mine in Limpopo. The query shows how MDX can isolate one commodity group from a mixed-commodity cube using the Mine Type attribute hierarchy."

---

## Exercise 2

### Objective

Write an MDX query that displays revenue by quarter for a single Assmang mine, structured with proper axis organisation.

### Procedure

**Step 1: Clarify the Business Question**
- Mine managers want: "Show Khumani revenue for each quarter in 2024"
- Khumani is Assmang's **largest iron ore mine** in the Northern Cape (~45,200 t/month)
- Expected result: 4 rows — one revenue value per quarter

**Step 2: Identify MDX Components**
- Measure: `[Measures].[Revenue (ZAR)]`
- Dimension for rows: Calendar Quarter members within 2024
- Slicer (WHERE): `[Mine].[Mine Name].&[Khumani]`

> ⚠️ **Correct member syntax:** Write `[Mine].[Mine Name].&[Khumani]` — NOT `[Mine].[Khumani]`. The `.&[value]` syntax is the key-value lookup for an attribute member.

**Step 3: Write the MDX Query**

> ✅ **COPY AND PASTE into a new SSMS MDX query window:**

```mdx
-- Exercise 2: Khumani revenue by quarter for 2024
SELECT
    { [Measures].[Revenue (ZAR)] } ON COLUMNS,
    [Date].[Calendar].[Calendar Quarter].MEMBERS ON ROWS
FROM [Assmang Mining Analytics]
WHERE (
    [Mine].[Mine Name].&[Khumani],
    [Date].[Calendar Year].&[2024]
);
```

> 📸 **Expected result:** 4 rows — Q1 2024, Q2 2024, Q3 2024, Q4 2024 — each with a ZAR revenue figure.

**Step 4: Validate Against SQL Baseline**

> ✅ **COPY AND PASTE into an SSMS SQL query window:**

```sql
-- SQL baseline: Khumani revenue by quarter 2024
SELECT
    dd.CalendarYear,
    dd.CalendarQuarterOfYear,
    SUM(fp.RevenueZAR) AS RevenueZAR
FROM FactProduction fp
INNER JOIN Dim_Mine dm ON fp.MineID = dm.MineID
INNER JOIN Dim_Date dd ON fp.DateID = dd.DateID
WHERE dm.MineName = 'Khumani'
  AND dd.CalendarYear = 2024
GROUP BY dd.CalendarYear, dd.CalendarQuarterOfYear
ORDER BY dd.CalendarQuarterOfYear;
```

> The SQL result should show 4 rows (Q1–Q4) matching the MDX output. If totals differ, confirm the cube has been processed.

**Step 5: Document the Query Structure**

Write one short paragraph explaining:
- Why `[Date].[Calendar].[Calendar Quarter].MEMBERS` goes on ROWS (it lists the quarters as row labels)
- Why `[Mine].[Mine Name].&[Khumani]` goes in WHERE (it slices to one mine without creating a row for it)
- What the result tells a manager: "Q2 was Khumani's strongest quarter" or similar

### Deliverable

- **Input:** Khumani 2024 revenue by quarter requirement
- **Output:** Working MDX query showing 4 quarterly rows + SQL baseline
- **Evidence:** Screenshot of MDX result (4 rows); SQL baseline matching totals; explanation of axis choices
- **Assmang Context:** "Khumani is Assmang's highest-volume iron ore mine. Quarterly revenue tracking helps operations and finance teams compare against production targets and identify seasonal patterns."

---

## Exercise 3

### Objective

Explain the three axes of MDX queries (COLUMNS, ROWS, WHERE/slicer) using Assmang examples and concrete business scenarios.

### Procedure

**Step 1: Understand Query Structure**
- MDX queries are structured like this:
	```
	SELECT [measure or dimension] ON COLUMNS,
				 [dimension] ON ROWS
	FROM [Cube]
	WHERE [slicer dimensions]
	```
- Think of it as: building a spreadsheet with rows, columns, and a filter

**Step 2: Define ROWS (Y-axis, vertical)**
- ROWS: What do you want to see listed vertically (as row labels)?
- Example: Mine dimension → Sishen, Khumani, Phalaborwa (each mine is a separate row)
- Assmang use: Production manager browses the cube, sees each mine down the left side
- Question answered: "How much production for each mine?"

**Step 3: Define COLUMNS (X-axis, horizontal)**
- COLUMNS: What do you want to see across the top (as column headers)?
- Example 1: Measure → TonnesProduced (one column, one number per row)
- Example 2: Date hierarchy → 2024 Q1, Q2, Q3, Q4 (four columns, one per quarter)
- Assmang use: Production manager sees quarters across the top, mines down the left
- Question answered: "What was production by mine by quarter?"

**Step 4: Define WHERE/Slicer (filter)**
- WHERE: What do you want to filter OUT of the result? (constraints on the data)
- Example 1: WHERE [Department].[Extraction] (only show extraction dept; exclude planning, admin)
- Example 2: WHERE [Date].[2024] (only show 2024; exclude other years)
- Assmang use: "Show me production by mine by quarter, but only for Extraction Department and only 2024"
- Note: WHERE hides unwanted dimensions; they don't appear in the spreadsheet

**Step 5: Construct an Assmang Example**
- Business question: "Show production by mine by quarter for 2024"
- Query structure:
	```
	ROWS: [Mine].[Mine Name].[Mine Name].MEMBERS → Beeshoek, Black Rock, Dwarsrivier, Khumani
	COLUMNS: [Date].[Calendar].[Calendar Quarter].MEMBERS → Q1 2024, Q2 2024, Q3 2024, Q4 2024
	WHERE: [Date].[Calendar Year].&[2024]
	MEASURE: [Measures].[TonnesProduced]
	```
- Result: 4 mines × 4 quarters = 16-cell grid
- Each cell = tonnes produced by that mine in that quarter for 2024

**Step 6: Document Explanation**
- Write 1–2 paragraphs or a table explaining:
	- ROWS: Vertical dimension (e.g., Mine, Employee); shows the "drill-down" axis
	- COLUMNS: Horizontal dimension or measure (e.g., quarters, revenue); shows comparative values
	- WHERE: Filter/slicer (e.g., date, department); selects subset of data
	- Visual metaphor: "Excel spreadsheet where rows are row headers, columns are column headers, slicer is the autofilter dropdown"
	- Assmang example confirming each role

### Deliverable

- **Input:** MDX query structure template; Assmang business scenario
- **Output:** 1–2 paragraph explanation + visual table showing roles (ROWS/COLUMNS/WHERE)
- **Evidence:** Screenshot of one full MDX query with ROWS/COLUMNS/WHERE marked; resulting browser/MDX output grid showing how data aligns
- **Assmang Context:** Example: \"ROWS is 'Mine' because managers want to compare Sishen vs. Khumani. COLUMNS is 'Quarter' because trends matter month-to-month. WHERE is '2024 Extraction' because we need current-year production data for the active extraction team only. The result is a 2×4 grid: 2 mines × 4 quarters, each cell showing tonnes.\"

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
