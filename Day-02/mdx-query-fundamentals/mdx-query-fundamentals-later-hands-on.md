# Later Hands-On Exercises — MDX Query Fundamentals
## Day 02 | Assmang Pty Ltd — SSAS Fundamentals

---

## 🎯 Purpose

These exercises are designed for **independent practice** after the guided lab. They are slightly more challenging and require you to apply what you've learned without step-by-step guidance.

## 📋 Before You Begin

- Ensure the guided lab for **MDX Query Fundamentals** is complete
- Dataset **`v3_assmang_mining_complete.sql`** must be loaded
- Your SSAS project should be in a working state
- Allow 30-45 minutes for these exercises

---

## Exercise 1

### Task

Write an MDX query that returns total production for chrome operations only.

### Hints

- Refer back to the theory for **MDX Query Fundamentals** if you get stuck.
- Think about how this connects to a real business question at Assmang.
- There may be multiple correct approaches — choose the one you can explain clearly.

### Deliverable

- A written answer (1-2 paragraphs) OR a screenshot of your SSDT/SSMS result.
- Be prepared to explain your reasoning to the trainer.

---

## Exercise 2

### Task

Write a query that shows revenue by quarter for one selected mine.

### Hints

- Refer back to the theory for **MDX Query Fundamentals** if you get stuck.
- Think about how this connects to a real business question at Assmang.
- There may be multiple correct approaches — choose the one you can explain clearly.

### Deliverable

- A written answer (1-2 paragraphs) OR a screenshot of your SSDT/SSMS result.
- Be prepared to explain your reasoning to the trainer.

---

## Exercise 3

### Task

Explain the difference between rows, columns, and slicers in your own words.

### Hints

- Refer back to the theory for **MDX Query Fundamentals** if you get stuck.
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

---

## 💡 Stretch Challenge (Optional)

If you finish early, try to extend one of the exercises above by combining it with a concept from a previous topic. For example, if this topic covers measures, try connecting your measure design to a specific dimension hierarchy from an earlier topic.

---

*Assmang Pty Ltd — SSAS Fundamentals | Day 02 Independent Practice*

---

## 🧰 Detailed SSMS Workflow (Use This If You Are Not Using Visual Studio)

Use this exact sequence when completing the lab/exercises primarily in SSMS:

1. Open SSMS and connect to the SQL Database Engine hosting `AssmangMining`.
2. Open a **new query window** and run the dataset script for your topic (`v1`, `v2`, or `v3`) if required.
3. Validate dataset load with `SELECT COUNT(*)` checks on key dimension and fact tables.
4. Open a second SSMS connection: **Connect > Analysis Services**.
5. In Object Explorer, expand **Databases** and confirm the target SSAS database is visible.
6. If the SSAS database is missing, ask your trainer for the deployed project name and deployment server.
7. Expand the SSAS database and inspect:
   - **Data Sources**
   - **Data Source Views**
   - **Cubes**
   - **Dimensions**
8. Right-click the target cube and open **Browse** to validate dimensional navigation.
9. Test at least one business slice per task (for example Mine, Month, Commodity, or Department).
10. Run MDX in an SSAS query window: **New Query > MDX**.
11. Save each important query with meaningful names (for example `01-production-by-mine.mdx`).
12. Capture evidence after each exercise:
   - Query text
   - Output grid screenshot
   - One-sentence interpretation in business language
13. If results look incorrect, run this troubleshooting chain:
   - Check source table row counts in SQL Engine
   - Confirm cube processing completed
   - Validate dimension relationships and hierarchy levels
   - Re-run the MDX with simpler axes first
14. Before submission, record:
   - What you tested
   - What answer you obtained
   - Why the answer is relevant to Assmang operations

### SSMS Menu Path Quick Reference

- Connect to SQL Engine: `File > Connect Object Explorer > Database Engine`
- Connect to SSAS: `Object Explorer > Connect > Analysis Services`
- Open SQL query: `Toolbar > New Query`
- Open MDX query: `Analysis Services connection > New Query > MDX`
- Browse cube: `SSAS Database > Cubes > [Cube Name] > Browse`
- Process object (if permissions allow): `Right-click Cube/Dimension > Process`

## Detailed Visual Studio (SSDT) Workflow (Step-by-Step)

Use this path when you are building and validating directly in Visual Studio with SSDT:

1. Open Visual Studio and load your SSAS solution.
2. In Solution Explorer, confirm these project objects exist and are not showing warning icons:
   - Data Sources
   - Data Source Views
   - Dimensions
   - Cubes
3. Open Data Source and click Test Connection.
4. Open Data Source View (DSV) and confirm all required tables are present and related correctly.
5. For each required dimension in this topic:
   - Open the dimension designer.
   - Check KeyColumns and NameColumn.
   - Confirm user hierarchies are logically ordered.
6. Open the cube designer and verify:
   - Correct measure groups
   - Correct aggregation function per measure (SUM/AVG/etc.)
   - Dimension usage relationships are correctly mapped
7. Deploy configuration check:
   - Right-click project > Properties
   - Confirm Deployment Server, Database, and Processing Option
8. Build the project: Build > Build Solution.
9. Fix all build errors before deployment (do not ignore warnings related to key columns or relationships).
10. Deploy: right-click project > Deploy.
11. Process objects if prompted; if not prompted, run manual processing:
   - Right-click SSAS database/cube in SSDT or SSMS > Process
12. Validate in the cube browser:
   - Drag at least one measure
   - Slice by at least one hierarchy related to this exercise
13. Open SSMS (Analysis Services connection) and run 1-2 MDX validation queries for the same result.
14. Compare browser output vs MDX output; values should align.
15. If values differ, troubleshoot in this order:
   - Relationship mapping in Dimension Usage
   - Measure aggregation type
   - Processing freshness (reprocess impacted objects)
   - Source data quality in SQL Engine tables
16. Save evidence for each exercise:
   - Build/deploy outcome
   - Browser or MDX result
   - Short interpretation in plain business language

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
