# Practical Lab — MDX Query Fundamentals
## Day 02 | Assmang Pty Ltd — SSAS Fundamentals

---

## 🎯 Lab Goal

Apply the theory from **MDX Query Fundamentals** by completing a guided, step-by-step exercise in SQL Server Data Tools (SSDT) and SQL Server Management Studio (SSMS).

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

### Step 1: Load the dataset and run the SQL baseline check

**What you are doing:** Loading the v3 data and verifying it before you write a single MDX query. Never query a cube without first knowing what the source data contains.

**In SSMS — connect to the Database Engine first:**

**1.1** Open SSMS

**1.2** Click **Connect** in Object Explorer → select **Database Engine**

**1.3** In the **Server name** box, type your SQL Server instance name (e.g., `localhost` or `.\SQLEXPRESS`)

**1.4** Click **Connect**

> 📸 **Screenshot Reference 1a — What you should see after connecting:**
> Object Explorer on the left shows a tree with your server name at the top. Underneath you see folders: Databases, Security, Server Objects, etc.

**1.5** Click **New Query** in the toolbar (or press **Ctrl+N**)

**1.6** In the database dropdown at the top of the query window, click it and select **`master`** (to ensure the script runs in the right context)

**1.7** Click **File → Open → File** in the top menu

**1.8** Navigate to your training folder, open `datasets/v3_assmang_mining_complete.sql`

**1.9** Press **F5** to run the script

**1.10** Watch the **Messages** tab at the bottom — wait for:
```
Commands completed successfully.
```

**1.11** Click **New Query** again

**1.12** In the database dropdown, select **`AssmangMining`**

**1.13** Copy and paste the following SQL, then press **F5**:

> ✅ **COPY THIS ENTIRE SQL BLOCK — paste it into the query window:**

```sql
SELECT
    m.MineName,
    SUM(fp.TonnesProduced) AS TotalTonnes,
    SUM(fp.RevenueZAR)     AS TotalRevenueZAR
FROM dbo.FactProduction fp
JOIN dbo.Dim_Mine m ON fp.MineID = m.MineID
GROUP BY m.MineName
ORDER BY m.MineName;
```

**1.14** Write down the numbers you see — you will compare them to MDX results in later steps

> 📸 **Screenshot Reference 1b — Expected SQL result:**
> You should see a grid with 4–5 rows (one per mine). Each row has MineName, TotalTonnes (a large number like 32,500 or 45,200), and TotalRevenueZAR. If the grid is empty, the dataset did not load — repeat from Step 1.6.

---

### Step 2: Open an Analysis Services connection in the same SSMS session

**What you are doing:** Opening a SECOND connection in SSMS — this time to Analysis Services (SSAS), not the database. Both connections stay open at the same time.

**2.1** In SSMS Object Explorer, click the **Connect** button again (top-left of Object Explorer panel)

**2.2** Select **Analysis Services** from the menu

> 📸 **Screenshot Reference 2a — The connection type menu:**
> A small dropdown menu appears listing: Database Engine, Analysis Services, Integration Services, Reporting Services. Click "Analysis Services".

**2.3** In the **Server name** box, type your SSAS server (usually the same machine name, e.g., `localhost` or `.\SSASDEV`)

**2.4** Click **Connect**

**2.5** In Object Explorer, expand the new connection → expand **Databases**

**2.6** You should see **`AssmangMiningAnalytics`** (or similar) listed

**2.7** Expand it → expand **Cubes** — you should see the cube name listed

> 📸 **Screenshot Reference 2b — What Object Explorer shows after connecting to SSAS:**
> Object Explorer now has TWO separate connections shown as two tree roots:
> - One shows your SQL Server (Database Engine) — labelled with a cylinder icon
> - One shows your SSAS server — labelled with a different icon (looks like a cube/grid)
> Expand the SSAS connection → Databases → AssmangMiningAnalytics → Cubes → you should see one cube listed

**If no cube appears:** The cube has not been deployed yet. Go to Visual Studio → right-click the project → Deploy — then come back and refresh.

---

### Step 3: Open an MDX query window and set the database context

**⚠️ CRITICAL STEP — Skipping this causes a parser error. Do not rush through this.**

**3.1** In Object Explorer, right-click on the **`AssmangMiningAnalytics`** database (under the SSAS connection)

**3.2** Click **New Query → MDX**

> 📸 **Screenshot Reference 3a — The MDX query window:**
> A blank white query editor opens. It looks just like a regular SQL query window EXCEPT the toolbar at the top shows a different database dropdown. This is your MDX workspace.

**3.3** Look at the toolbar at the very top of the query window — find the **database dropdown**

> 📸 **Screenshot Reference 3b — The database dropdown in the MDX toolbar:**
> In the toolbar row above your query text, you will see a dropdown box (it may show a database name or be blank/show "master"). This is different from the SQL query toolbar. It controls which SSAS cube the MDX parser connects to.

**3.4** Click the database dropdown

**3.5** Select **`AssmangMiningAnalytics`** from the list

**3.6** Confirm the dropdown now shows `AssmangMiningAnalytics`

> ⚠️ **If you skip Step 3.5 and try to run MDX, you will get this error:**
> `The CurrentCatalog XML/A property was not specified.`
> **Fix: Always select the cube database from the toolbar dropdown BEFORE writing any MDX.**

---

### Step 4: Run your first MDX query — Tonnes by mine

**What you are doing:** Your first real MDX query. This shows total tonnes for each mine — the same answer you got from SQL in Step 1.

**4.1** Click inside the MDX query window (click in the white text area)

**4.2** Select all existing text (Ctrl+A) and delete it

**4.3** Copy and paste the following query:

> ✅ **COPY THIS ENTIRE BLOCK — everything from SELECT to the semicolon:**

```mdx
SELECT
    { [Measures].[TonnesProduced] } ON COLUMNS,
    [Mine].[Mine Name].[Mine Name].MEMBERS ON ROWS
FROM [Assmang Mining Analytics];
```

> ℹ️ **What each part means:**
> - `{ [Measures].[TonnesProduced] }` — the number you want to see (curly braces = a set)
> - `ON COLUMNS` — display it as a column header
> - `[Mine].[Mine Name].[Mine Name].MEMBERS` — show every mine as a separate row
> - `FROM [Assmang Mining Analytics]` — the cube to query (NOT a table name)
> - `;` — end of query (semicolon is required)

**4.4** Press **F5** to execute

> 📸 **Screenshot Reference 4 — Expected MDX result grid:**
> The results panel at the bottom shows a grid:
> ```
> (row header)       TonnesProduced
> Beeshoek Mine      32,500
> Black Rock Mine    28,100
> Dwarsrivier Mine   15,600
> Khumani Mine       45,200
> ```
> Compare these numbers to your SQL result from Step 1. They should match.

**4.5** Compare each mine's total to the SQL result from Step 1.13

If they match ✅ → proceed to Step 5

If they do not match ❌ → check that the cube was processed (reprocess in SSMS if needed)

---

### Step 5: Add a year filter using the WHERE clause

**What you are doing:** Adding a slicer to show only 2024 data. The WHERE clause in MDX is a filter, not a condition like SQL WHERE.

**5.1** Clear the query window (Ctrl+A, Delete)

**5.2** Copy and paste the following:

> ✅ **COPY THIS ENTIRE BLOCK:**

```mdx
SELECT
    { [Measures].[TonnesProduced] } ON COLUMNS,
    [Mine].[Mine Name].[Mine Name].MEMBERS ON ROWS
FROM [Assmang Mining Analytics]
WHERE ( [Date].[Calendar Year].&[2024] );
```

> ℹ️ **What changed from Step 4:**
> - `WHERE ( [Date].[Calendar Year].&[2024] )` — this restricts the entire query to 2024 only
> - The `&` before `[2024]` means "match by key value" (the exact year value in the data)
> - Parentheses around the WHERE value are required

**5.3** Press **F5** to execute

**5.4** Compare the numbers to Step 4 — they should be smaller (only 2024 data, not all years)

> 📸 **Screenshot Reference 5 — Expected result:**
> The same mines appear in rows, but the TonnesProduced numbers are now smaller (showing only 2024 production). If the numbers are identical to Step 4, your Date dimension may not be linked to the Production measure group — ask your trainer.

---

### Step 6: Show two measures side-by-side

**What you are doing:** Adding Revenue next to Tonnes to compare both numbers per mine.

**6.1** Clear the query window (Ctrl+A, Delete)

**6.2** Copy and paste the following:

> ✅ **COPY THIS ENTIRE BLOCK:**

```mdx
SELECT
    { [Measures].[TonnesProduced], [Measures].[RevenueZAR] } ON COLUMNS,
    [Mine].[Mine Name].[Mine Name].MEMBERS ON ROWS
FROM [Assmang Mining Analytics]
WHERE ( [Date].[Calendar Year].&[2024] );
```

> ℹ️ **What changed:**
> - `{ [Measures].[TonnesProduced], [Measures].[RevenueZAR] }` — two measures separated by a comma inside curly braces
> - Both measures appear as separate columns in the result

**6.3** Press **F5**

> 📸 **Screenshot Reference 6 — Expected result:**
> ```
> (row header)       TonnesProduced    RevenueZAR
> Beeshoek Mine      32,500            18,200,000
> Black Rock Mine    28,100            12,600,000
> Dwarsrivier Mine   15,600             9,500,000
> Khumani Mine       45,200            28,500,000
> ```

---

### Step 7: Query by commodity type instead of individual mines

**What you are doing:** Changing the ROWS axis to a higher level — grouping by Mine Type (commodity) instead of individual mine name.

**7.1** Clear the query window (Ctrl+A, Delete)

**7.2** Copy and paste the following:

> ✅ **COPY THIS ENTIRE BLOCK:**

```mdx
SELECT
    { [Measures].[RevenueZAR] } ON COLUMNS,
    [Mine].[Mine Type].[Mine Type].MEMBERS ON ROWS
FROM [Assmang Mining Analytics]
WHERE ( [Date].[Calendar Year].&[2024] );
```

> ℹ️ **What changed:**
> - `[Mine].[Mine Type].[Mine Type].MEMBERS` — uses the Mine Type level (Iron Ore, Manganese, Chrome) instead of individual mine names
> - Result has fewer rows but each row is a group of mines aggregated together

**7.3** Press **F5**

> 📸 **Screenshot Reference 7 — Expected result:**
> ```
> (row header)    RevenueZAR
> Chrome          9,500,000
> Iron Ore        46,700,000
> Manganese       12,600,000
> ```
> Notice: There are only 3 rows now (one per commodity), not 4+ individual mines.

**If only 1 row labelled "All" appears:** The Mine Type hierarchy level was not defined. Ask your trainer to verify the dimension hierarchy was built correctly.

---

### Step 8: Use a named set to show only iron ore mines

**What you are doing:** Defining a reusable group of mines (iron ore only) using a WITH clause — the MDX equivalent of a saved filter.

**8.1** Clear the query window (Ctrl+A, Delete)

**8.2** Copy and paste the following:

> ✅ **COPY THIS ENTIRE BLOCK — including the WITH clause at the top:**

```mdx
WITH
SET [Iron Ore Mines] AS
    DESCENDANTS(
        [Mine].[Mine Type].&[Iron Ore],
        [Mine].[Mine Name].[Mine Name]
    )
SELECT
    { [Measures].[TonnesProduced], [Measures].[RevenueZAR] } ON COLUMNS,
    [Iron Ore Mines] ON ROWS
FROM [Assmang Mining Analytics]
WHERE ( [Date].[Calendar Year].&[2024] );
```

> ℹ️ **What each part does:**
> - `WITH SET [Iron Ore Mines] AS ...` — defines a reusable named set (lives only for this query)
> - `DESCENDANTS(...)` — gets all members that belong to Iron Ore at the mine-name level
> - `[Iron Ore Mines] ON ROWS` — uses the named set as the row axis

**8.3** Press **F5**

> 📸 **Screenshot Reference 8 — Expected result:**
> ```
> (row header)     TonnesProduced    RevenueZAR
> Beeshoek Mine    32,500            18,200,000
> Khumani Mine     45,200            28,500,000
> ```
> Only the 2 iron ore mines appear. Black Rock (Manganese) and Dwarsrivier (Chrome) are excluded.

**If an error says member not found:** The Mine Type member key might be different in your dataset. Expand `[Mine].[Mine Type].Members` in the metadata tree (left panel) to see the exact member name.

---

### Step 9: Validate — Compare MDX to your SQL baseline

**What you are doing:** Confirming the cube gives the same answer as SQL. If they match, the cube is correct. If they don't match, something is wrong.

**9.1** Look at your SQL result from Step 1 (you wrote this down)

**9.2** Look at your MDX result from Step 4 (unfiltered tonnes)

**9.3** Compare Khumani mine specifically — the numbers should be identical (or within 1%)

**9.4** If they match, write: ✅ "Cube validated — MDX matches SQL baseline for Khumani"

**9.5** If they do not match:
- Check: Was the cube processed? (SSMS → SSAS → Databases → right-click cube → Process)
- Check: Is the MDX querying all years? (Remove the WHERE clause to remove the year filter)
- Check: Are the measure names correct? (Drag from metadata instead of typing)

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

By the end of this lab, you should be able to demonstrate the core workflow for **MDX Query Fundamentals** in the Assmang training environment. You should be able to:

- Understand the structure of a basic MDX SELECT statement.
- Work with measures, members, sets, tuples, and slicers.
- Query the Assmang cube for common analytical views.
- Recognise how MDX differs from SQL thinking.

---

## 💡 Tips for Success

- **Read each step fully** before executing it.
- **Save your project** after each major step.
- **Ask questions** if something doesn't look right — it's better to clarify early.
- **Take notes** on what you observe — this helps with the assessment later.

## SQL Precheck (Run in SSMS Database Engine)

> ✅ **COPY AND PASTE into a new SSMS query window. Set database to `AssmangMining` first.**

```sql
USE AssmangMining;
GO

SELECT
    m.MineName,
    SUM(fp.TonnesProduced) AS TotalTonnes,
    SUM(fp.RevenueZAR) AS TotalRevenueZAR
FROM dbo.FactProduction fp
JOIN dbo.Dim_Mine m ON fp.MineID = m.MineID
GROUP BY m.MineName
ORDER BY m.MineName;
```

---

## MDX Quick Reference — All Queries for This Lab

> ⚠️ **Before running any MDX query:** Open an MDX query window in SSMS (connected to Analysis Services) and select **`AssmangMiningAnalytics`** from the database dropdown in the toolbar.

> ℹ️ **About the labels like `-- Step 4:`** These are comments (lines starting with `--`). They are explanations only and **will not affect the query**. You can include them or leave them out — SSAS ignores everything after `--` on that line.

---

**Query 1 — Tonnes by mine (all years):**

> ✅ COPY THIS — everything from SELECT to the semicolon:

```mdx
-- Step 4: Tonnes by mine (all years, no filter)
SELECT
    { [Measures].[TonnesProduced] } ON COLUMNS,
    [Mine].[Mine Name].[Mine Name].MEMBERS ON ROWS
FROM [Assmang Mining Analytics];
```

---

**Query 2 — Tonnes by mine, 2024 only:**

> ✅ COPY THIS:

```mdx
-- Step 5: Add year filter
SELECT
    { [Measures].[TonnesProduced] } ON COLUMNS,
    [Mine].[Mine Name].[Mine Name].MEMBERS ON ROWS
FROM [Assmang Mining Analytics]
WHERE ( [Date].[Calendar Year].&[2024] );
```

---

**Query 3 — Two measures side by side:**

> ✅ COPY THIS:

```mdx
-- Step 6: Tonnes AND Revenue in one grid
SELECT
    { [Measures].[TonnesProduced], [Measures].[RevenueZAR] } ON COLUMNS,
    [Mine].[Mine Name].[Mine Name].MEMBERS ON ROWS
FROM [Assmang Mining Analytics]
WHERE ( [Date].[Calendar Year].&[2024] );
```

---

**Query 4 — Revenue by commodity type:**

> ✅ COPY THIS:

```mdx
-- Step 7: Group by Mine Type (Iron Ore, Chrome, Manganese)
SELECT
    { [Measures].[RevenueZAR] } ON COLUMNS,
    [Mine].[Mine Type].[Mine Type].MEMBERS ON ROWS
FROM [Assmang Mining Analytics]
WHERE ( [Date].[Calendar Year].&[2024] );
```

---

**Query 5 — Iron ore mines only (named set):**

> ✅ COPY THIS — include the WITH clause at the top:

```mdx
-- Step 8: Named set for iron ore mines only
WITH
SET [Iron Ore Mines] AS
    DESCENDANTS(
        [Mine].[Mine Type].&[Iron Ore],
        [Mine].[Mine Name].[Mine Name]
    )
SELECT
    { [Measures].[TonnesProduced], [Measures].[RevenueZAR] } ON COLUMNS,
    [Iron Ore Mines] ON ROWS
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
14. **CRITICAL:** After opening the MDX query window, select the cube database from the toolbar dropdown. Click the dropdown and select **`AssmangMiningAnalytics`**. This sets the `CurrentCatalog` property required by the MDX parser. If you skip this step, you will get "CurrentCatalog XML/A property was not specified" error.
15. Start with the simplest possible MDX pattern: one measure on columns and one hierarchy on rows.
16. Add a slicer only after the base query works.
17. Compare at least one SSAS result against the SQL baseline from the Database Engine connection.
18. Save important queries with meaningful names so you can reuse them during assessments.
19. Capture evidence for every exercise: the input, the output, and one sentence explaining what the result means for Assmang.
20. If the numbers look wrong, troubleshoot in this order: SQL source data, deployment state, processing state, dimension relationships, then MDX syntax.
21. Before submission, write down what you tested, what result you obtained, and why the result matters to the business.

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
