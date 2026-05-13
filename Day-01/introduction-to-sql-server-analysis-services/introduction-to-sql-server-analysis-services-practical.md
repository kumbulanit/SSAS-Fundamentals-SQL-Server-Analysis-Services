# Practical Lab — Introduction to SQL Server Analysis Services
## Day 01 | Assmang Pty Ltd — SSAS Fundamentals

---

## 🎯 Lab Goal

Apply the theory from **Introduction to SQL Server Analysis Services** by completing a guided, step-by-step exercise in SQL Server Data Tools (SSDT) and SQL Server Management Studio (SSMS).

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

### Step 1: Load `datasets/v1_assmang_mining_base.sql` and verify the starter warehouse

**Do this in SSMS (Database Engine):**
1. Open SSMS and connect to the SQL Server instance that hosts `AssmangMining`.
2. Click **File > Open > File** and open `datasets/v1_assmang_mining_base.sql`.
3. Press **Execute** and wait for the completion message in the Messages pane.
4. Immediately run the SQL validation queries in this lab to confirm the four base tables exist and contain data.
5. Check that you see counts for `Dim_Mine`, `Dim_Department`, `Dim_Employee`, and `Dim_Date` before you move on.

**What you should pay attention to:**
- `Dim_Mine` should contain the Assmang mine list.
- `Dim_Date` should cover 2023 and 2024.
- No validation query should return empty output or object-not-found errors.

**Expected result:** The relational database is ready and you can explain that SSAS will read from this SQL source rather than storing table definitions inside Visual Studio.

**If something goes wrong:**
- If the script fails at the `USE` statement, make sure SQL Server is running and you connected to the correct instance.
- If tables already exist but contain unexpected values, rerun the script from the top so the database is rebuilt cleanly.
- If you get permission errors, use a login that can create databases and read data.

---

### Step 2: Create a new Analysis Services Multidimensional project in Visual Studio

**Do this in Visual Studio with SSDT installed:**
1. Open Visual Studio.
2. Select **Create a new project**.
3. Search for **Analysis Services Multidimensional and Data Mining Project**.
4. Choose the multidimensional project template, not a tabular project template.
5. Set the project name to `AssmangMiningCube` and save it in your training workspace.
6. After the project opens, look in Solution Explorer and confirm you can see the SSAS folders such as Data Sources, Data Source Views, Cubes, and Dimensions.

**Why this step matters:** This is where the model metadata lives. The project does not store the mining data itself; it stores the design of how SSAS should interpret and serve that data.

**Expected result:** A clean SSAS project shell opens without build errors and the Solution Explorer structure matches a multidimensional project.

**If something goes wrong:**
- If the project template is missing, SSDT support for Analysis Services is not installed.
- If Visual Studio opens a different BI template, close it and choose the multidimensional template explicitly.
- If the solution opens with warning icons immediately, check whether extensions or project targeting are incomplete.

---

### Step 3: Create a data source that connects the SSAS project to `AssmangMining`

**Follow this exact path:**
1. In Solution Explorer, right-click **Data Sources** and choose **New Data Source**.
2. In the wizard, create a new connection to the SQL Server Database Engine instance.
3. Select the `AssmangMining` database.
4. Click **Test Connection** and do not continue until it succeeds.
5. On the impersonation page, choose an option that can read the relational source during processing.
6. Finish the wizard and rename the data source clearly if needed.

**What to check carefully:**
- The server name must point to the SQL Database Engine, not the Analysis Services instance.
- The database must be `AssmangMining`.
- The impersonation choice must allow read access during processing; otherwise deployment may work but processing will fail.

**Expected result:** The project now contains a working relational connection that SSAS can use when the cube is processed.

**If something goes wrong:**
- If Test Connection fails, verify server name, authentication mode, and that the SQL service is running.
- If processing later fails with read-permission errors, revisit the impersonation settings in the data source.
- If the wrong database was selected, edit the data source immediately before building more objects on top of it.

---

### Step 4: Build a Data Source View with the four training dimensions

**Do this inside the DSV wizard:**
1. Right-click **Data Source Views** and choose **New Data Source View**.
2. Select the data source you created in Step 3.
3. Add `Dim_Mine`, `Dim_Department`, `Dim_Employee`, and `Dim_Date` to the DSV.
4. Finish the wizard and open the DSV diagram.
5. Confirm the table relationships appear correctly, especially `Dim_Employee` linking to department and mine.
6. Rearrange the tables so the diagram is readable rather than cluttered.
7. Save the DSV before closing it.

**What you should verify visually:**
- All four required tables are present.
- Key columns look sensible and no table is isolated by mistake.
- The DSV is readable enough that another learner could follow it.

**Expected result:** You have a clean logical model layer that SSAS designers can use for dimensions and cubes.

**If something goes wrong:**
- If a table is missing, reopen the DSV and add it rather than creating a second DSV.
- If a relationship line is missing where you expected one, inspect the SQL table keys first.
- If the DSV designer shows stale metadata, refresh it before continuing.

---

### Step 5: Deploy the project shell and confirm the SSAS server accepts it

**Use deployment as your first environment check:**
1. Right-click the project and choose **Properties**.
2. Open the **Deployment** page and enter the correct SSAS server name.
3. Confirm the target database name is sensible for the training environment.
4. Save the properties.
5. Choose **Build > Build Solution** and fix any build errors first.
6. Right-click the project and choose **Deploy**.
7. Watch the Output window carefully. Deployment should build the project, validate the destination server, and create the SSAS database objects.
8. Open SSMS, connect to **Analysis Services**, and confirm the deployed database now appears under **Databases**.

**What to remember from Microsoft guidance:** A project must be deployed before you can process or browse it. Deployment and processing are related, but they are not the same operation.

**Expected result:** The project shell deploys successfully and a new SSAS database appears even though you have not yet built a full cube.

**If something goes wrong:**
- If deployment fails immediately, double-check the deployment server name in project properties.
- If you get server-role or permission errors, you likely do not have rights on the SSAS instance.
- If deployment succeeds but nothing appears in SSMS, refresh the SSAS Object Explorer tree and reconnect if necessary.

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

By the end of this lab, you should be able to demonstrate the core workflow for **Introduction to SQL Server Analysis Services** in the Assmang training environment. You should be able to:

- Explain what SSAS is and where it fits in the Microsoft BI stack.
- Differentiate multidimensional and tabular models at a beginner level.
- Understand SSAS terminology such as cube, dimension, hierarchy, measure, and processing.
- Connect the SSAS learning journey to Assmang production analytics use cases.

---

## 💡 Tips for Success

- **Read each step fully** before executing it.
- **Save your project** after each major step.
- **Ask questions** if something doesn't look right — it's better to clarify early.
- **Take notes** on what you observe — this helps with the assessment later.

## SQL Validation Queries (Run in SSMS)

Run these checks after loading `v1_assmang_mining_base.sql`:

```sql
USE AssmangMining;
GO

SELECT
	(SELECT COUNT(*) FROM dbo.Dim_Mine) AS MineCount,
	(SELECT COUNT(*) FROM dbo.Dim_Department) AS DepartmentCount,
	(SELECT COUNT(*) FROM dbo.Dim_Employee) AS EmployeeCount,
	(SELECT COUNT(*) FROM dbo.Dim_Date) AS DateCount;
```

```sql
SELECT TOP (10)
	e.EmployeeCode,
	e.FirstName + ' ' + e.LastName AS EmployeeName,
	m.MineName,
	d.DepartmentName
FROM dbo.Dim_Employee e
LEFT JOIN dbo.Dim_Mine m ON e.MineID = m.MineID
LEFT JOIN dbo.Dim_Department d ON e.DepartmentID = d.DepartmentID
ORDER BY e.EmployeeID;
```

```sql
SELECT
	MIN(FullDate) AS StartDate,
	MAX(FullDate) AS EndDate,
	COUNT(*) AS NumberOfDates
FROM dbo.Dim_Date;
```

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
