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
