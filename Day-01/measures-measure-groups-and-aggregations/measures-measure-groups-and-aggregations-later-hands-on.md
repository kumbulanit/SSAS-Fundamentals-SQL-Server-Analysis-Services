# Later Hands-On Exercises — Measures, Measure Groups, and Aggregations
## Day 01 | Assmang Pty Ltd — SSAS Fundamentals

---

## 📋 Before You Begin

| Requirement | Status to check |
|-------------|----------------|
| Guided practical lab | Must be fully complete |
| AssmangMining database | Must exist in SQL Server with data |
| SSAS cube deployed and processed | Browser tab must show results |
| Dataset v2 loaded | `FactProduction` and `FactOperatingCosts` must have rows |

**Time:** Allow 45–60 minutes for all three exercises.

---

## How to Use These Exercises

These are **independent practice exercises** — no instructor will walk you through them. Each one has exact steps to follow. Read each step fully before you do anything.

**If you get stuck:**
1. Go back to the practical lab and find the closest matching step
2. Check that your cube is deployed and processed (most problems come from this)
3. Run the SQL validation queries to check if the source data is the issue

---

## Exercise 1 — Classify the Assmang Measures

### What you are doing

You will look at each measure in the cube and decide whether it is additive, semi-additive, or non-additive. Then you will check if SSAS is set up correctly.

### Why this matters

If SSAS uses the wrong setting (e.g., summing Grade%), the cube will show impossible numbers. A manager who sees "iron grade = 128%" will stop trusting your reports entirely.

---

### Step 1: Open the cube in Visual Studio

1. Open **Visual Studio**
2. Open your SSAS project (File → Open → Project/Solution)
3. In **Solution Explorer**, expand **Cubes**
4. Double-click the cube file to open the **Cube Designer**
5. Click the **Cube Structure** tab

---

### Step 2: Find the Measures panel

1. On the left side of the Cube Designer, look for a panel labelled **Measures**
2. Expand the **Production** measure group by clicking the arrow next to it
3. You should see individual measures listed: TonnesProduced, RevenueZAR, Grade, etc.
4. Write down each measure name — you will classify each one

---

### Step 3: Classify each measure using this guide

For each measure you found, ask yourself: **"What happens if I add this number across all shifts and all mines?"**

Use this table to decide:

| Answer | Classification | Correct SSAS setting |
|--------|---------------|---------------------|
| The total makes sense (e.g., total tonnes = sum of all mines) | **Additive** | AggregationFunction = Sum |
| Adding it across time doesn't make sense, but across mines does | **Semi-Additive** | AggregationFunction = Max or LastNonEmpty |
| Adding it produces a number that is impossible or meaningless | **Non-Additive** | Write a calculated measure formula instead |

**Write your classification for each measure before the next step.**

Example to guide you:
- `TonnesProduced` → Khumani 45,000t + Beeshoek 32,000t = 77,000t total → Makes sense → **Additive**
- `Grade` → Khumani 64% + Beeshoek 58% = 122% → Impossible → **Non-Additive**
- `EmployeesAssigned` → Day shift 120 + Night shift 95 = 215 headcount → May be double-counting → **Semi-Additive**

---

### Step 4: Check the AggregationFunction in SSAS

1. In the Measures panel, click **TonnesProduced** to select it
2. Press **F4** to open the **Properties** window (or go to View → Properties Window)
3. Find the property called **AggregationFunction**
4. Note what it is set to (Sum, None, Max, etc.)
5. Compare it to your classification from Step 3
6. Repeat for **RevenueZAR** and **Grade**

**What you should find:**
- TonnesProduced → should be **Sum** ✅
- RevenueZAR → should be **Sum** ✅
- Grade → should be **None** or a formula, NOT Sum ← if it is set to Sum, this is a problem

---

### Step 5: Fix any wrong settings

1. If you found a measure with the wrong AggregationFunction:
   - Click the measure to select it
   - In the Properties window, click the AggregationFunction dropdown
   - Change it to the correct value from your classification
2. Press **Ctrl+S** to save
3. Rebuild: **Build → Build Solution**
4. Redeploy: Right-click project → **Deploy**
5. Reprocess the cube (SSMS → Analysis Services → right-click database → Process)

---

### Step 6: Document your findings

Write a simple table like this (fill it in with your actual findings):

| Measure | My Classification | SSAS Was Set To | Correct? | Action Taken |
|---------|------------------|----------------|----------|--------------|
| TonnesProduced | Additive | Sum | ✅ Yes | None needed |
| RevenueZAR | Additive | Sum | ✅ Yes | None needed |
| Grade | Non-Additive | Sum | ❌ No | Changed to None; added formula |

---

### What to hand in

- Your completed classification table
- A screenshot of the Properties window showing AggregationFunction for at least two measures
- One sentence explaining what would go wrong if Grade was left as Sum

---

## Exercise 2 — Design an Equipment Efficiency Measure Group

### What you are doing

You will look at the v3 dataset's equipment table and propose a new measure group for it. You will decide which columns become measures and what aggregation rule to use.

### Why this matters

Assmang needs to track equipment uptime and breakdown counts to plan maintenance. If you model the uptime% as a Sum, you will get percentages above 100% — meaningless to engineers. This exercise teaches you to think before clicking.

---

### Step 1: Load the v3 dataset and find the equipment table

1. Open **SSMS**
2. Click **New Query** and select database **`AssmangMining`** from the dropdown
3. Run this query to check if the equipment table already exists:

```sql
SELECT TABLE_NAME
FROM INFORMATION_SCHEMA.TABLES
WHERE TABLE_NAME LIKE '%Equipment%';
```

4. If it does not appear, you need to load v3:
   - Go to **File → Open → File**
   - Navigate to `datasets/v3_assmang_mining_complete.sql`
   - Press **F5** to run it
   - Wait for "Commands completed successfully"

5. Once the table exists, run:

```sql
SELECT TOP 10 *
FROM dbo.FactEquipmentEfficiency;
```

6. Write down the column names you see in the result

---

### Step 2: Identify which columns are measures

Look at each column from Step 1. For each column, answer: "Is this a number I would want to analyse?"

**Use this guide:**
- Column ends in `ID` → It is a foreign key, NOT a measure
- Column is a date → It is a dimension link, NOT a measure
- Column is a number that represents a business value (hours, count, percentage) → **YES, this is a measure candidate**

Write down which columns qualify as measure candidates.

---

### Step 3: Classify each measure candidate

For each candidate, decide its aggregation type using the same method from Exercise 1:

**Common equipment measures you will likely find:**

| Column | Classification | Reason |
|--------|---------------|--------|
| UptimePercentage | **Non-Additive** | It is a percentage. 95% + 90% ≠ 185% uptime. Use Average. |
| MaintenanceHours | **Additive** | Hours can be summed: 8h + 6h = 14h total maintenance |
| BreakdownCount | **Additive** | Count of failures can be summed across equipment and time |

---

### Step 4: Write out your proposed measure group design

Create a table like this:

| Measure Name | Source Column | AggregationFunction | Business Question It Answers |
|-------------|--------------|--------------------|-----------------------------|
| Equipment Uptime % | UptimePercentage | Average | "What was average uptime for haul trucks in Q1?" |
| Total Maintenance Hours | MaintenanceHours | Sum | "How many total maintenance hours did we log in January?" |
| Breakdown Count | BreakdownCount | Sum | "How many breakdowns happened at Khumani this year?" |

---

### Step 5: Check your design makes business sense

For each measure, ask:
1. "If I drill down to one mine, one week — does this number still make sense?"
2. "If I zoom out to all mines, full year — does this number still make sense?"

**Example check:**
- Uptime% Average for one truck on one day = 95% → Makes sense ✅
- Uptime% Average for all trucks for the whole year = 87% → Makes sense ✅
- Uptime% Sum for all trucks = 8,700% → Makes NO sense ❌ → confirms Average is correct

---

### What to hand in

- Your measure candidate list from Step 2
- Your completed measure group design table from Step 4
- One worked example showing why UptimePercentage must use Average not Sum (show the math, like above)

---

## Exercise 3 — Prove Why CostPerTonne Must Be Calculated, Not Stored

### What you are doing

You will use actual numbers to prove that storing `CostPerTonne` in the fact table and summing it gives wrong answers — and that building it as a calculated measure gives correct answers.

### Why this matters

This is one of the most common mistakes in real SSAS projects. Hundreds of reports across mining companies have been wrong because of this exact error. You need to understand why it happens and how to prevent it.

---

### Step 1: Get the raw numbers from SQL

1. Open **SSMS**
2. Select database **`AssmangMining`**
3. Run this query to get cost and production per shift:

```sql
SELECT
    m.MineName,
    fp.DateID,
    fp.TonnesProduced,
    oc.LaborCostZAR + oc.MaintenanceCostZAR + oc.EquipmentCostZAR AS TotalCostZAR
FROM dbo.FactProduction fp
JOIN dbo.Dim_Mine m ON fp.MineID = m.MineID
JOIN dbo.FactOperatingCosts oc
    ON fp.MineID = oc.MineID AND fp.DateID = oc.DateID
WHERE m.MineName = 'Khumani Mine'
ORDER BY fp.DateID
```

4. Look at the first 2 or 3 rows in the result
5. Write down:
   - Row 1: TonnesProduced = ?, TotalCostZAR = ?
   - Row 2: TonnesProduced = ?, TotalCostZAR = ?

---

### Step 2: Calculate CostPerTonne the WRONG way (to see why it fails)

Using your numbers from Step 1, simulate what SSAS does if CostPerTonne is a stored column set to SUM:

```
Row 1 CostPerTonne = TotalCostZAR ÷ TonnesProduced
Row 2 CostPerTonne = TotalCostZAR ÷ TonnesProduced

Naive SUM = Row 1 CostPerTonne + Row 2 CostPerTonne
```

Write that SUM down. Then ask yourself: **"Is this number a meaningful cost per tonne?"**

It is NOT — because you just added two ratios together. There is no business meaning to "Row1 cost/tonne + Row2 cost/tonne".

---

### Step 3: Calculate CostPerTonne the CORRECT way

Using the same numbers from Step 1:

```
Correct CostPerTonne = (Row1 TotalCost + Row2 TotalCost) ÷ (Row1 Tonnes + Row2 Tonnes)
```

Calculate this with your actual numbers.

**Example with made-up numbers:**
- Row 1: 1,500 tonnes, R 600,000 cost → CostPerTonne = R 400/t
- Row 2: 1,200 tonnes, R 420,000 cost → CostPerTonne = R 350/t
- Wrong SUM: 400 + 350 = **R 750/tonne** ← WRONG
- Correct formula: (600,000 + 420,000) ÷ (1,500 + 1,200) = 1,020,000 ÷ 2,700 = **R 378/tonne** ✅

---

### Step 4: Verify the calculated measure in your cube gives the right answer

1. Open **Visual Studio** → your SSAS project → Cube Designer
2. Click the **Calculations** tab
3. Check if `Cost Per Tonne ZAR` already exists from the practical lab
4. If it exists, click it and read the formula — it should be:
   ```
   [Measures].[Labor Cost (ZAR)] / [Measures].[Tonnes Produced]
   ```
   (or similar, using total cost divided by tonnes)
5. Click the **Browser** tab
6. Drag **Cost Per Tonne ZAR** into the data area
7. Drag **Mine Name** to the rows
8. Compare the cube result for Khumani to your Step 3 correct calculation — they should be in the same range

---

### Step 5: Write your explanation (2–3 sentences)

Answer this question in your own words:

> "Why should CostPerTonne be a calculated measure and NOT a stored fact column set to Sum?"

Use your Step 2 and Step 3 numbers as your proof. Example answer format:

> "If CostPerTonne is stored and summed, adding Row 1 (R400/t) and Row 2 (R350/t) gives R750/t — a meaningless number that no mine manager would recognise. The correct value is R378/t, calculated by dividing total cost by total tonnes across both rows. SSAS computed measures perform this division dynamically at whatever level the user is viewing, giving the correct answer every time."

---

### What to hand in

- Your Step 1 raw numbers (from the SQL query)
- Your Step 2 wrong calculation and the number it produces
- Your Step 3 correct calculation and the number it produces
- Your Step 5 explanation (2–3 sentences)
- A screenshot of the calculated measure formula in the Calculations tab

---

## ✅ All Exercises Complete When

- [ ] Exercise 1: Classification table done, AggregationFunction verified in SSAS
- [ ] Exercise 2: Measure group design table complete with aggregation justification
- [ ] Exercise 3: Both wrong and correct cost-per-tonne calculations shown with real numbers

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
