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
