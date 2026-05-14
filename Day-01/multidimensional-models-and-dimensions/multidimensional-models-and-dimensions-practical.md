# Practical Lab — Multidimensional Models and Dimensions
## Day 01 | Assmang Pty Ltd — SSAS Fundamentals

---

## 🎯 Lab Goal

Apply the theory from **Multidimensional Models and Dimensions** by completing a guided, step-by-step exercise in SQL Server Data Tools (SSDT) and SQL Server Management Studio (SSMS).

## 📋 Prerequisites

- Dataset **`v1_assmang_mining_base.sql`** loaded into SQL Server
- SQL Server Analysis Services running
- Visual Studio with SSDT installed
- SSMS available for verification

## 🔧 Lab Environment

| Component | Value |
|-----------|-------|
| SQL Server Instance | localhost\SSASDEV (or your instance) |
| Database | AssmangMining |
| SSAS Project | AssmangMiningCube |
| Dataset Version | `v1_assmang_mining_base.sql` |

---

## 📝 Guided Steps

### Step 1: Create the `Dim_Mine` dimension from the Data Source View

**Build the first business dimension carefully:**
1. Open the SSAS project from Topic 1 and confirm the DSV already contains `Dim_Mine`.
2. Right-click **Dimensions** and choose **New Dimension**.
3. In the Dimension Wizard, choose **Use an existing table**.
4. Select `Dim_Mine` as the main table.
5. Keep the dimension type as a regular dimension for this training exercise.
6. Finish the wizard and open the new dimension in the designer.

**What to look for immediately:**
- The dimension should appear under the Dimensions folder.
- The attributes pane should show mine-related fields rather than generic placeholders.
- The designer should open without warnings about missing keys.

**Expected result:** You now have a draft mine dimension built from relational metadata, ready to be cleaned up for business use.

**If something goes wrong:**
- If `Dim_Mine` is not available in the wizard, go back to the DSV and confirm the table exists there.
- If the wizard suggests the wrong key automatically, do not accept it without checking.
- If the dimension opens with errors, inspect the underlying SQL table for nulls or duplicate values.

> 📸 **Screenshot Checkpoint 1 — Dimension Designer after creating Dim_Mine:**
> The Dimension Designer shows two panes:
> - **Attributes pane** (left): lists all columns from Dim_Mine as draggable attributes
>   ```
>   MineID (key icon — shown with a small key symbol)
>   MineName
>   MineType
>   Province
>   EstablishedYear
>   ```
> - **Hierarchies pane** (right): empty at this stage — you'll add the drill path in Step 4
> If you see an error icon on the dimension, the key attribute is not set correctly.

---

### Step 2: Set `MineID` as the key and `MineName` as the business-friendly name

**Refine the dimension so users see meaningful names:**
1. In the mine dimension designer, click the key attribute.
2. Open the Properties pane.
3. Set **KeyColumns** to `MineID`.
4. Set **NameColumn** to `MineName`.
5. Confirm the attribute name shown to users is readable.
6. Save the dimension.

**Why this is important:** SSAS can use technical keys internally while presenting business-friendly labels to the user. If you skip this, users may browse numeric IDs instead of mine names.

**Expected result:** The dimension uses stable keys for uniqueness and meaningful mine names for browsing.

**If something goes wrong:**
- If the attribute still shows IDs after the change, recheck the NameColumn property.
- If you see duplicate-name warnings, inspect whether multiple mines share the same display name.
- If the Properties pane is not visible, turn it on from **View > Properties Window**.

> 📸 **Screenshot Checkpoint 2 — Properties panel for the key attribute:**
> When you click `MineID` in the Attributes pane, the Properties panel (bottom-right, or press F4) shows:
> ```
> Properties
> MineID Attribute
> ─────────────────────────────────────────
> AggregationUsage     Default
> KeyColumns           MineID (integer key)    ← Should be the ID column
> Name                 MineID
> NameColumn           MineName                ← Should be the display name column
> OrderBy              Name
> ```
> The **NameColumn = MineName** is the critical setting. If it still shows MineID, click the NameColumn dropdown and change it.

---

### Step 3: Add and organise the supporting mine attributes

**Turn the raw table into an analytical dimension:**
1. In the Attributes pane, add or keep `MineType`, `Province`, and `EstablishedYear`.
2. Remove attributes that add little analytical value for beginners if they clutter the view.
3. Rename attributes if needed so they read well in the browser.
4. Open the **Attribute Relationships** tab and think about whether province naturally groups mines.
5. Save after each meaningful change.

**What you should be aiming for:**
- A business user should be able to answer "Which mine type is this?" and "Which province is this in?" without seeing technical noise.
- The attribute list should feel curated, not dumped straight from the SQL table.

**Expected result:** The dimension now contains the right descriptive fields for drill-down and filtering.

**If something goes wrong:**
- If too many technical attributes are exposed, hide the ones that are not useful to learners.
- If the designer becomes messy, tidy names now before cube design starts.
- If you are unsure whether to keep an attribute, ask whether a manager would realistically browse by it.

---

### Step 4: Build the `Mine Type > Province > Mine Name` hierarchy and process the dimension

**Create the drill path explicitly:**
1. In the Hierarchies pane, create a new user hierarchy.
2. Drag `Mine Type` to the top level.
3. Drag `Province` underneath it.
4. Drag the mine name attribute underneath province.
5. Rename the hierarchy clearly if needed.
6. Process the dimension when prompted, or right-click the dimension and choose **Process**.
7. After processing, open the browser tab and test the drill-down path from mine type to province to mine.

**What to check after processing:**
- The hierarchy should expand in a sensible order.
- Chrome, Iron Ore, and Manganese should separate correctly.
- Province members should appear under the right mine type branch.

**Expected result:** Learners can now browse the mine dimension the way a business user thinks about operations.

**If something goes wrong:**
- If processing fails, verify the project is deployed and the SSAS server is reachable.
- If the hierarchy looks flat or odd, review which attributes were dragged into the hierarchy.
- If province members appear duplicated unexpectedly, revisit key and name choices.

> 📸 **Screenshot Checkpoint 3 — Hierarchies pane after building Mine Type > Province > Mine Name:**
> The Hierarchies pane shows:
> ```
> ▼ Mine Geography (or whatever you named it)
>     Level 1: Mine Type        ← Top of the drill path
>     Level 2: Province
>     Level 3: Mine Name        ← Bottom level — individual mines
> ```
> After processing, click the **Browser** tab and expand the hierarchy:
> ```
> ▼ Iron Ore
>     ▼ Northern Cape
>         Beeshoek Mine
>         Khumani Mine
> ▼ Chrome
>     ▼ Limpopo
>         Dwarsrivier Mine
> ▼ Manganese
>     ▼ Northern Cape
>         Black Rock Mine
> ```

---

### Step 5: Build the date dimension hierarchy and confirm time drill-down works

**Repeat the pattern for the most important analytical dimension:**
1. Create or open the `Dim_Date` dimension.
2. Confirm the key is based on the date key column and that names are readable to end users.
3. Keep the attributes that support time analysis, especially Year, Quarter, Month, and Day.
4. Build the user hierarchy `Year > Quarter > Month > Day`.
5. Process the dimension.
6. Browse the dimension and expand 2023 and 2024 to confirm the structure is natural and complete.

**Why this step matters:** Time is usually the first thing users slice by. If the date dimension is weak, almost every cube query becomes harder to explain.

**Expected result:** A learner can drill from year to quarter to month to day and explain why hierarchies make cube navigation easier than scanning flat table data.

**If something goes wrong:**
- If months sort alphabetically instead of chronologically, review month attributes and ordering.
- If the hierarchy fails to browse, make sure the dimension processed successfully.
- If levels are missing, go back and confirm the attributes were added before the hierarchy was built.

> 📸 **Screenshot Checkpoint 4 — Date dimension Browser tab:**
> After processing, the Browser tab shows the date hierarchy:
> ```
> ▼ 2023
>     ▼ Q1 2023
>         January 2023
>         February 2023
>         March 2023
>     ▼ Q2 2023
>         April 2023
>         May 2023
>         June 2023
>     ...
> ▼ 2024
>     ▼ Q1 2024
>         January 2024
>         ...
> ```
> Months should sort numerically (January, February, March...) NOT alphabetically (April, August, December...). If they sort alphabetically, the `MonthNumberOfYear` attribute needs to be set as the sort key.

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

By the end of this lab, you should be able to demonstrate the core workflow for **Multidimensional Models and Dimensions** in the Assmang training environment. You should be able to:

- Understand star-schema thinking and how dimensions support analysis.
- Design dimensions from the Assmang dimension tables.
- Build hierarchies that support drill-down navigation.
- Recognise common dimension design issues such as poor keys or weak hierarchies.

---

## 💡 Tips for Success

- **Read each step fully** before executing it.
- **Save your project** after each major step.
- **Ask questions** if something doesn't look right — it's better to clarify early.
- **Take notes** on what you observe — this helps with the assessment later.

## SQL Validation Queries (Run in SSMS)

Use these checks to confirm your dimension data is hierarchy-ready:

> ✅ **COPY AND PASTE each SQL block into a new SSMS query window. Set database to `AssmangMining` first.**

**Check 1 — Mine types and provinces (verify the hierarchy data exists):**

```sql
USE AssmangMining;
GO

SELECT
    MineType,
    Province,
    COUNT(*) AS MineCount
FROM dbo.Dim_Mine
GROUP BY MineType, Province
ORDER BY MineType, Province;
```

> 📸 **Expected result:** You should see rows showing:
> ```
> MineType     Province             MineCount
> Chrome       Limpopo              2
> Iron Ore     Northern Cape        2
> Manganese    Northern Cape        1
> ```
> If MineType or Province columns are NULL for any rows, the hierarchy will not work correctly in SSAS.

**Check 2 — Date dimension quarters (verify time hierarchy data):**

```sql
SELECT
    [Year],
    [Quarter],
    COUNT(*) AS DaysInQuarter
FROM dbo.Dim_Date
GROUP BY [Year], [Quarter]
ORDER BY [Year], [Quarter];
```

> 📸 **Expected result:** Each Quarter shows ~90 days (DaysInQuarter ≈ 90). If a quarter is missing, the time hierarchy will have gaps.

**Check 3 — Null check on Dim_Mine attributes (data quality):**

```sql
SELECT
    SUM(CASE WHEN MineName  IS NULL THEN 1 ELSE 0 END) AS NullMineName,
    SUM(CASE WHEN MineType  IS NULL THEN 1 ELSE 0 END) AS NullMineType,
    SUM(CASE WHEN Province  IS NULL THEN 1 ELSE 0 END) AS NullProvince
FROM dbo.Dim_Mine;
```

> 📸 **Expected result:** All three columns should show 0. Any value > 0 means that dimension attribute has NULLs — SSAS will either fail to process or create an Unknown member for those rows.

---

*Assmang Pty Ltd — SSAS Fundamentals | Day 01 Practical Lab*

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
