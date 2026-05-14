# Practical Lab — Advanced Queries, Calculations, and KPIs
## Day 02 | Assmang Pty Ltd — SSAS Fundamentals

---

## 🎯 Lab Goal

Apply the theory from **Advanced Queries, Calculations, and KPIs** by completing a guided, step-by-step exercise in SQL Server Data Tools (SSDT) and SQL Server Management Studio (SSMS).

## 📋 Prerequisites

- Dataset **`v3_assmang_mining_complete.sql`** loaded into SQL Server
- SQL Server Analysis Services running
- Visual Studio with SSDT installed
- SSMS available for verification

## 🔧 Lab Environment

| Component | Value |
|-----------|-------|
| SQL Server Instance | localhost\SSASDEV (or your instance) |
| Database | AssmangMining |
| SSAS Project | AssmangMiningCube |
| Dataset Version | `v3_assmang_mining_complete.sql` |

---

## 📝 Guided Steps

---

### Step 1: Validate the SQL source data before opening Visual Studio

**What you are doing:** Checking the v3 dataset is loaded and the key numbers look right. Always do this before building any calculation.

**1.1** Open SSMS → connect to **Database Engine**

**1.2** Click **New Query** → in the database dropdown, select **`AssmangMining`**

**1.3** Copy and paste this SQL, then press **F5**:

> ✅ **COPY THIS ENTIRE SQL BLOCK:**

```sql
USE AssmangMining;
GO

WITH MonthlyProduction AS (
    SELECT
        fp.MineID,
        fp.DateID,
        SUM(fp.TonnesProduced) AS TonnesProduced,
        SUM(fp.RevenueZAR) AS RevenueZAR
    FROM dbo.FactProduction fp
    GROUP BY fp.MineID, fp.DateID
),
MonthlyCosts AS (
    SELECT
        oc.MineID,
        oc.DateID,
        SUM(oc.LaborCostZAR + oc.EquipmentCostZAR + oc.MaintenanceCostZAR
            + oc.SafetyCostZAR + oc.UtilitiesCostZAR + oc.OtherCostZAR) AS TotalCostZAR
    FROM dbo.FactOperatingCosts oc
    GROUP BY oc.MineID, oc.DateID
)
SELECT
    m.MineName,
    p.DateID,
    p.TonnesProduced,
    c.TotalCostZAR,
    CASE WHEN p.TonnesProduced = 0 THEN NULL
         ELSE c.TotalCostZAR / p.TonnesProduced
    END AS CostPerTonneZAR
FROM MonthlyProduction p
JOIN MonthlyCosts c ON p.MineID = c.MineID AND p.DateID = c.DateID
JOIN dbo.Dim_Mine m ON p.MineID = m.MineID
ORDER BY p.DateID, m.MineName;
```

**1.4** Write down **Khumani Mine's CostPerTonneZAR** for one month — you will compare this to the cube result later

> 📸 **Screenshot Checkpoint 1 — SQL baseline result:**
> You should see a grid with columns: MineName, DateID, TonnesProduced, TotalCostZAR, CostPerTonneZAR
> Example rows:
> ```
> MineName         DateID    TonnesProduced    TotalCostZAR    CostPerTonneZAR
> Beeshoek Mine    20240101  2,700             1,080,000       400.00
> Khumani Mine     20240101  3,800             1,330,000       350.00
> ```
> If this query returns 0 rows — the v3 dataset was not loaded. Load `datasets/v3_assmang_mining_complete.sql` first.

---

### Step 2: Open the cube and go to the Calculations tab

**What you are doing:** Opening Visual Studio and navigating to the place where calculated measures are defined.

**2.1** Open Visual Studio

**2.2** Open your SSAS project (File → Open → Project → select `.sln` file)

**2.3** In Solution Explorer, expand **Cubes** → double-click the cube file (`.cube` extension)

**2.4** The Cube Designer opens. Click the **Calculations** tab

> 📸 **Screenshot Checkpoint 2 — Calculations tab in Cube Designer:**
> The Calculations tab shows:
> - Left panel: "Script Organizer" — lists any existing calculated members/named sets
> - Right panel: empty formula editor (or shows the selected item's expression)
> - Toolbar: buttons for "New Calculated Member", "New Named Set", "New Script Command"
> If you see no toolbar buttons, the Calculations tab may not be fully loaded — click somewhere else and click back.

---

### Step 3: Create a calculated measure for Total Operating Cost

**What you are doing:** Building a helper measure that adds up all 6 cost columns into one number. You need this before you can calculate Cost Per Tonne.

**3.1** In the Calculations tab toolbar, click **New Calculated Member** (formula icon)

**3.2** In the **Name** field, type: `Total Operating Cost ZAR`

**3.3** In the **Expression** box, copy and paste:

> ✅ **COPY THIS FORMULA — paste into the Expression box:**

```
[Measures].[Labor Cost (ZAR)] +
[Measures].[Equipment Cost (ZAR)] +
[Measures].[Maintenance Cost (ZAR)] +
[Measures].[Safety Cost (ZAR)] +
[Measures].[Utilities Cost (ZAR)] +
[Measures].[Other Cost (ZAR)]
```

> ⚠️ **The measure names in `[ ]` must match exactly how they appear in the Measures panel.** If your measures were renamed differently (e.g., `[LaborCostZAR]` instead of `[Labor Cost (ZAR)]`), update the formula to match.

**3.4** Press **Ctrl+S** to save

---

### Step 4: Create the Cost Per Tonne calculated measure

**What you are doing:** Dividing total cost by tonnes produced to get cost efficiency. Protected against divide-by-zero so it shows NULL instead of an error.

**4.1** In the Calculations tab toolbar, click **New Calculated Member** again

**4.2** In the **Name** field, type: `Cost Per Tonne ZAR`

**4.3** In the **Expression** box, copy and paste:

> ✅ **COPY THIS FORMULA — paste into the Expression box:**

```
IIF(
    [Measures].[Tonnes Produced] = 0,
    NULL,
    [Measures].[Total Operating Cost ZAR] / [Measures].[Tonnes Produced]
)
```

> ℹ️ **What each part does:**
> - `IIF(condition, value_if_true, value_if_false)` — MDX version of IF/ELSE
> - `[Measures].[Tonnes Produced] = 0, NULL` — if no tonnes were produced, show blank (not ÷0 error)
> - `[Measures].[Total Operating Cost ZAR] / [Measures].[Tonnes Produced]` — the actual calculation

**4.4** In the **Format String** dropdown, select **`Currency`** (or type `"R #,##0"` for South African Rand)

**4.5** Press **Ctrl+S** to save

> 📸 **Screenshot Checkpoint 3 — Calculations tab with both measures:**
> The Script Organizer (left panel) now shows:
> ```
> ▼ Calculated Members
>     [Total Operating Cost ZAR]
>     [Cost Per Tonne ZAR]
> ```
> Both entries should appear without any red error icons.

---

### Step 5: Create a named set for above-average production mines

**What you are doing:** Building a reusable filter that shows only mines where production exceeds the average across all mines.

**5.1** In the Calculations tab toolbar, click **New Named Set** button (different from Calculated Member)

**5.2** In the **Name** field, type: `Above Average Production Mines`

**5.3** In the **Expression** box, copy and paste:

> ✅ **COPY THIS FORMULA — paste into the Expression box:**

```
FILTER(
    [Mine].[Mine Name].[Mine Name].MEMBERS,
    [Measures].[Tonnes Produced] >
        AVG(
            [Mine].[Mine Name].[Mine Name].MEMBERS,
            [Measures].[Tonnes Produced]
        )
)
```

> ℹ️ **What each part does:**
> - `FILTER(set, condition)` — keeps only members where the condition is true
> - `[Mine].[Mine Name].[Mine Name].MEMBERS` — start with all mines
> - `AVG(same set, measure)` — calculate the average tonnes across all mines
> - Result: only mines whose production exceeds that average

**5.4** Press **Ctrl+S** to save

---

### Step 6: Define a KPI for production target attainment

**What you are doing:** Creating a KPI in the SSDT KPI designer. A KPI adds green/amber/red status logic on top of a calculated value.

**6.1** Click the **KPIs** tab in the Cube Designer

**6.2** Click **New KPI** in the toolbar

**6.3** Fill in the KPI properties:

| Field | Value to enter |
|-------|---------------|
| **Name** | `Production Target Attainment` |
| **Associated measure group** | Select your Production measure group |
| **Value expression** | `[Measures].[Tonnes Produced]` |
| **Goal expression** | `300000` (assumed monthly target of 300,000 tonnes) |
| **Status expression** | Copy from below |
| **Trend expression** | Leave blank for now |

**6.4** In the **Status expression** box, copy and paste:

> ✅ **COPY THIS STATUS FORMULA:**

```
CASE
    WHEN [Measures].[Tonnes Produced] / 300000 >= 0.95 THEN  1
    WHEN [Measures].[Tonnes Produced] / 300000 >= 0.80 THEN  0
    ELSE                                                     -1
END
```

> ℹ️ **What the numbers mean:**
> - `1` = Green (on target, ≥95% of goal)
> - `0` = Amber (near target, 80–94%)
> - `-1` = Red (below target, <80%)

**6.5** Press **Ctrl+S** to save

> 📸 **Screenshot Checkpoint 4 — KPIs tab:**
> The KPIs tab shows your new KPI listed on the left. On the right, the KPI fields are filled in. The Status Indicator dropdown shows a traffic light or gauge icon — you can change the visual style here (select "Shapes" or "Traffic Light" from the dropdown).

---

### Step 7: Build and deploy

**7.1** Click **Build → Build Solution**

**7.2** Wait for: `Build succeeded` in the Output window (0 errors)

**7.3** In Solution Explorer, right-click the project → **Deploy**

**7.4** Wait for: `Deployment completed successfully` in the Output window

> 📸 **Screenshot Checkpoint 5 — Successful deployment output:**
> The Output panel at the bottom shows:
> ```
> ------ Build started ------
> Build succeeded.
> ------ Deploy started ------
> Deploying database...
> Deploying dimensions...
> Deploying cubes...
> Deployment completed successfully.
> ```

---

### Step 8: Process the cube and validate in SSMS

**What you are doing:** Loading the data into the cube (processing), then querying in SSMS to verify the calculated measures return the right numbers.

**8.1** In SSMS, connect to **Analysis Services** (if not already connected)

**8.2** Expand **Databases** → right-click **`AssmangMiningAnalytics`** → **Process**

**8.3** Click **Run** → wait for all items to show **Success** → click **Close**

**8.4** Open a new **MDX query window** (right-click the SSAS database → New Query → MDX)

**8.5 CRITICAL:** In the toolbar dropdown, select **`AssmangMiningAnalytics`** before typing any MDX

**8.6** Copy and paste this query:

> ✅ **COPY THIS ENTIRE MDX BLOCK:**

```mdx
WITH
MEMBER [Measures].[Total Operating Cost ZAR] AS
    [Measures].[Labor Cost (ZAR)] +
    [Measures].[Equipment Cost (ZAR)] +
    [Measures].[Maintenance Cost (ZAR)] +
    [Measures].[Safety Cost (ZAR)] +
    [Measures].[Utilities Cost (ZAR)] +
    [Measures].[Other Cost (ZAR)]
MEMBER [Measures].[Cost Per Tonne] AS
    IIF(
        [Measures].[Tonnes Produced] = 0,
        NULL,
        [Measures].[Total Operating Cost ZAR] / [Measures].[Tonnes Produced]
    ),
    FORMAT_STRING = "R #,##0"
SET [Above Avg Production Mines] AS
    FILTER(
        [Mine].[Mine Name].[Mine Name].MEMBERS,
        [Measures].[Tonnes Produced] >
            AVG(
                [Mine].[Mine Name].[Mine Name].MEMBERS,
                [Measures].[Tonnes Produced]
            )
    )
SELECT
    { [Measures].[Tonnes Produced], [Measures].[Cost Per Tonne] } ON COLUMNS,
    [Above Avg Production Mines] ON ROWS
FROM [Assmang Mining Analytics]
WHERE ( [Date].[Calendar Year].&[2024] );
```

**8.7** Press **F5**

> 📸 **Screenshot Checkpoint 6 — Expected MDX result:**
> The result grid shows only the mines with above-average production (typically 2–3 mines):
> ```
> Mine Name          Tonnes Produced    Cost Per Tonne
> Khumani Mine       45,200             R 350
> Beeshoek Mine      32,500             R 400
> ```
> Compare Cost Per Tonne to your SQL result from Step 1. The numbers should be very close (small differences are due to rounding at different grains).

---

### Step 9: Validate the KPI in the Browser

**9.1** In Visual Studio, in the Cube Designer, click the **Browser** tab

**9.2** Click **Reconnect** if prompted

**9.3** In the KPIs section of the metadata tree, drag **Production Target Attainment** into the data area

**9.4** Drag **Mine Name** to rows

**9.5** Look for the traffic light / shape icons next to each mine

> 📸 **Screenshot Checkpoint 7 — KPI in Browser:**
> The Browser shows a grid with mine names in rows and KPI columns (Value, Goal, Status, Trend). The Status column shows green circles (1), yellow triangles (0), or red crosses (-1) depending on each mine's attainment.
> Example:
> ```
> Mine Name          Value     Goal      Status
> Khumani Mine       45,200    300,000   🔴 (-1)   ← below 80% of 300,000
> ```
> (Note: 300,000 is an assumed monthly target — adjust this to match real Assmang targets when in production.)

---

### Step 10: Document the business meaning

Before finishing this lab, write down:

**10.1** Cost Per Tonne in one sentence — *what does this tell a mine manager?*
> Example: "Cost Per Tonne tells the mine manager how much it costs Assmang to produce one tonne of ore — a lower number means the mine is more efficient."

**10.2** Above Average Mines in one sentence — *what decision does this enable?*
> Example: "This named set quickly identifies which mines are producing more than average, so the operations team can study what those mines are doing right."

**10.3** KPI Target Attainment in one sentence — *what does a red KPI mean to an executive?*
> Example: "A red KPI means the mine produced less than 80% of its monthly target — this triggers a management review."

**10.4** Note any assumptions:
> "The monthly production target of 300,000 tonnes is hard-coded in this training lab. In the real Assmang cube, this would come from a budget table."

---

## ✅ Validation Checklist

Before marking this lab as complete, confirm:

- [ ] SQL baseline shows `CostPerTonneZAR` in the range R 350–R 500/tonne for Khumani (not zero, not > R 1,000)
- [ ] `Cost Per Tonne ZAR` calculated measure exists in the Calculations tab with an IIF formula protecting against divide-by-zero
- [ ] `Above Average Production Mines` named set returns exactly 2–3 mines when browsed
- [ ] Production Target Attainment KPI exists with a status expression returning 1 (green), 0 (amber), or -1 (red)
- [ ] MDX validation query returns Cost Per Tonne within 5% of the SQL baseline value for Khumani
- [ ] You can explain why `IIF([Measures].[TonnesProduced] = 0, NULL, ...)` protects against divide-by-zero errors

---

## 🎓 Expected Outcome

By the end of this lab, you should be able to demonstrate the core workflow for **Advanced Queries, Calculations, and KPIs** in the Assmang training environment. You should be able to:

- Create calculated measures and members for business-friendly analytics.
- Understand named sets and reusable MDX logic.
- Design practical KPIs for production, cost, and safety monitoring.
- Use time-based calculations to support trend analysis.

---

## 💡 Tips for Success

- **Read each step fully** before executing it.
- **Save your project** after each major step.
- **Ask questions** if something doesn't look right — it's better to clarify early.
- **Take notes** on what you observe — this helps with the assessment later.

## SQL Baseline Checks (Run in SSMS Database Engine)

Use SQL first to validate the source numbers used by your calculations:

```sql
USE AssmangMining;
GO

WITH MonthlyProduction AS (
	SELECT
		fp.MineID,
		fp.DateID,
		SUM(fp.TonnesProduced) AS TonnesProduced,
		SUM(fp.RevenueZAR) AS RevenueZAR
	FROM dbo.FactProduction fp
	GROUP BY fp.MineID, fp.DateID
),
MonthlyCosts AS (
	SELECT
		oc.MineID,
		oc.DateID,
		SUM(oc.LaborCostZAR + oc.EquipmentCostZAR + oc.MaintenanceCostZAR + oc.SafetyCostZAR + oc.UtilitiesCostZAR + oc.OtherCostZAR) AS TotalCostZAR
	FROM dbo.FactOperatingCosts oc
	GROUP BY oc.MineID, oc.DateID
)
SELECT
	m.MineName,
	p.DateID,
	p.TonnesProduced,
	c.TotalCostZAR,
	CASE WHEN p.TonnesProduced = 0 THEN NULL ELSE c.TotalCostZAR / p.TonnesProduced END AS CostPerTonneZAR
FROM MonthlyProduction p
JOIN MonthlyCosts c ON p.MineID = c.MineID AND p.DateID = c.DateID
JOIN dbo.Dim_Mine m ON p.MineID = m.MineID
ORDER BY p.DateID, m.MineName;
```

## MDX Validation Queries (Run in SSMS against SSAS)

> ⚠️ **Before running MDX in SSMS:** Open an MDX query window (Analysis Services connection → right-click database → New Query → MDX), then select `AssmangMiningAnalytics` from the toolbar dropdown.

> ℹ️ **About the `-- labels` in these queries:** Lines starting with `--` are comments. They explain what the query does but **do not affect the result**. You can include them or delete them — SSAS ignores them.

---

**Query 1 — Cost Per Tonne with above-average mines filter:**

> ✅ COPY THIS ENTIRE BLOCK — from WITH to the semicolon:

```mdx
-- Calculated measures + named set: Steps 3-5
WITH
MEMBER [Measures].[Total Operating Cost ZAR] AS
    [Measures].[Labor Cost (ZAR)] +
    [Measures].[Equipment Cost (ZAR)] +
    [Measures].[Maintenance Cost (ZAR)] +
    [Measures].[Safety Cost (ZAR)] +
    [Measures].[Utilities Cost (ZAR)] +
    [Measures].[Other Cost (ZAR)]
MEMBER [Measures].[Cost Per Tonne] AS
    IIF(
        [Measures].[Tonnes Produced] = 0,
        NULL,
        [Measures].[Total Operating Cost ZAR] / [Measures].[Tonnes Produced]
    ),
    FORMAT_STRING = "R #,##0"
SET [Above Avg Production Mines] AS
    FILTER(
        [Mine].[Mine Name].[Mine Name].MEMBERS,
        [Measures].[Tonnes Produced] >
            AVG(
                [Mine].[Mine Name].[Mine Name].MEMBERS,
                [Measures].[Tonnes Produced]
            )
    )
SELECT
    { [Measures].[Tonnes Produced], [Measures].[Cost Per Tonne] } ON COLUMNS,
    [Above Avg Production Mines] ON ROWS
FROM [Assmang Mining Analytics];
```

---

**Query 2 — KPI target attainment view:**

> ✅ COPY THIS ENTIRE BLOCK:

```mdx
-- KPI-style target attainment: Steps 6-7
WITH
MEMBER [Measures].[Monthly Target Tonnes] AS 300000
MEMBER [Measures].[Target Attainment %] AS
    IIF(
        [Measures].[Monthly Target Tonnes] = 0,
        NULL,
        [Measures].[Tonnes Produced] / [Measures].[Monthly Target Tonnes]
    ),
    FORMAT_STRING = "0.00%"
SELECT
    {
        [Measures].[Tonnes Produced],
        [Measures].[Monthly Target Tonnes],
        [Measures].[Target Attainment %]
    } ON COLUMNS,
    [Mine].[Mine Name].[Mine Name].MEMBERS ON ROWS
FROM [Assmang Mining Analytics]
WHERE ( [Date].[Calendar Year].&[2024] );
```

---

*Assmang Pty Ltd — SSAS Fundamentals | Day 02 Practical Lab*

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
