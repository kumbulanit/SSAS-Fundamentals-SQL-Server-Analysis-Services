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

- [ ] The relevant SQL dataset was loaded and verified
- [ ] The SSAS project was opened without errors
- [ ] All objects created in this lab are visible in Solution Explorer
- [ ] Processing completed successfully (check Output window)
- [ ] The cube browser or SSMS query returns expected results
- [ ] You can explain what each object does in business terms

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
