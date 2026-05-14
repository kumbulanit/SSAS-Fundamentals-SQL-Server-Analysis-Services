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

> 📸 **Screenshot Checkpoint 1 — Object Explorer after loading v1 dataset:**
> The Object Explorer tree shows:
> ```
> ▼ localhost (SQL Server ...)
>   ▼ Databases
>       AssmangMining         ← New database created by the script
>           ▼ Tables
>               dbo.Dim_Date
>               dbo.Dim_Department
>               dbo.Dim_Employee
>               dbo.Dim_Mine
> ```
> No `FactProduction` table yet — that comes in the v2 dataset in the next topic.

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

> 📸 **Screenshot Checkpoint 2 — New SSAS project in Solution Explorer:**
> After the project opens, Solution Explorer (right side panel) shows the project name with these folders:
> ```
> ▼ AssmangMiningCube (Project)
>     Data Sources          ← Where you set up the SQL connection
>     Data Source Views     ← Where you map the tables
>     Cubes                 ← Where the cube lives
>     Dimensions            ← Where dimensions are built
>     Mining Structures     ← (Ignore — not used in this course)
>     Roles                 ← (Security — covered later)
> ```
> If you see a "Tabular" project structure instead (with "Tables" instead of "Cubes"), you selected the wrong project type — delete it and create a new multidimensional project.

---

### Step 3: Create a data source that connects the SSAS project to `AssmangMining`

**Follow this exact path:**
1. In Solution Explorer, right-click **Data Sources** and choose **New Data Source**.
2. Click **New** to create a new connection. In the connection dialog:
   - **Provider:** Microsoft OLE DB Provider for SQL Server (or Native Client)
   - **Server name:** type your SQL Server instance (e.g., `localhost` or `.\SQLEXPRESS`)
   - **Database:** select `AssmangMining` from the dropdown
3. Click **Test Connection** — wait for "Test connection succeeded" before continuing.
4. Click **OK** to close the connection dialog, then **Next**.
5. On the **Impersonation Information** page, choose one of these options:

| Option | When to use | What happens |
|--------|-------------|--------------|
| **Use the service account** | ✅ Recommended for training | SSAS uses its own Windows service account to read SQL data |
| **Use a specific Windows account** | If service account has no SQL access | Enter a Windows account that can read `AssmangMining` |
| **Use the credentials of the current user** | ❌ Avoid for SSAS | Only works when you are the one processing — breaks overnight jobs |

> ⚠️ **If you choose "Use the service account" and processing later fails** with an access-denied error, it means the SSAS service account does not have read access to SQL Server. Ask your trainer to grant `db_datareader` on `AssmangMining` to the SSAS service account.

6. Finish the wizard. The data source appears in the Data Sources folder.

**What to check carefully:**
- The server name must point to the **SQL Database Engine**, not the Analysis Services instance. They are usually on the same machine but use different service names.
- The database must be `AssmangMining` — not `master` or any other database.

**Expected result:** The project now contains a working relational connection that SSAS can use when the cube is processed.

**If something goes wrong:**
- If Test Connection fails, verify server name, authentication mode, and that the SQL service is running.
- If processing later fails with read-permission errors, revisit the impersonation settings in the data source.
- If the wrong database was selected, edit the data source before building more objects on top of it.

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

**Key column settings you will use when creating dimensions from this DSV:**

Each dimension table has a primary key column that identifies rows (`KeyColumns`) and a friendly name column (`NameColumn`). Set these exactly as shown:

| Table | KeyColumns (set this as the key attribute) | NameColumn (what appears in reports) |
|-------|---------------------------------------------|---------------------------------------|
| `Dim_Mine` | `MineID` | `MineName` |
| `Dim_Department` | `DepartmentID` | `DepartmentName` |
| `Dim_Employee` | `EmployeeID` | *use a named calculation: `FirstName + ' ' + LastName`* |
| `Dim_Date` | `DateID` | `FullDate` |

> ℹ️ **For Dim_Employee's NameColumn:** The DSV lets you add a **Named Calculation** — right-click the Dim_Employee table in the DSV canvas → **New Named Calculation** → expression: `FirstName + ' ' + LastName` → name it `FullName`. Then set `FullName` as the NameColumn in the dimension designer.

**What you should verify visually:**
- All four required tables are present in the DSV canvas.
- Relationship lines connect Dim_Employee.MineID → Dim_Mine.MineID and Dim_Employee.DepartmentID → Dim_Department.DepartmentID.
- Dim_Date stands alone — it has no FK to the other dimension tables (that's expected at this stage).

**Expected result:** You have a clean logical model layer that SSAS designers can use for dimensions and cubes.

**If something goes wrong:**
- If a table is missing, reopen the DSV and add it rather than creating a second DSV.
- If a relationship line is missing where you expected one, inspect the SQL table keys first.
- If the DSV designer shows stale metadata, refresh it before continuing.

> 📸 **Screenshot Checkpoint 3 — Data Source View with 4 dimension tables:**
> The DSV canvas shows 4 table boxes connected by lines:
> ```
> [Dim_Employee]
>     MineID ─────── [Dim_Mine]
>                        MineID
>     DepartmentID ── [Dim_Department]
>                        DepartmentID
>
> [Dim_Date]
>     (standalone — no direct link to other dims yet)
> ```
> Each box shows the column names of the table. Lines = foreign key relationships defined in SQL.

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

> 📸 **Screenshot Checkpoint 4 — Output window after deployment + SSMS showing the deployed database:**
> **In Visual Studio Output window:**
> ```
> ------ Build started ------
> Build succeeded.
> ------ Deploy started ------
> Deploying database...
> Deployment completed successfully.
> ```
> **In SSMS Object Explorer (Analysis Services connection):**
> ```
> ▼ SSAS Server (Analysis Services)
>   ▼ Databases
>       AssmangMiningAnalytics    ← Your deployed SSAS database appears here
>           Cubes                  (empty at this stage — cube is created later)
>           Dimensions             (empty at this stage)
> ```

---

## ✅ Validation Checklist

Before marking this lab as complete, confirm:

- [ ] `AssmangMining` database has 4 dimension tables — `Dim_Mine` (5 rows), `Dim_Department` (8 rows), `Dim_Employee` (120+ rows), `Dim_Date` (730+ rows)
- [ ] SSAS project opens in Visual Studio with Solution Explorer showing: Data Sources, Data Source Views, Cubes, Dimensions folders
- [ ] Data source **Test Connection** returns "Test connection succeeded"
- [ ] DSV diagram shows all 4 tables with relationship lines between Dim_Employee ↔ Dim_Mine and Dim_Employee ↔ Dim_Department
- [ ] Deployment succeeds and `AssmangMiningAnalytics` appears in SSMS under the Analysis Services connection → Databases
- [ ] You can explain the difference between the SQL Database Engine connection and the Analysis Services connection in SSMS

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

> ✅ **COPY AND PASTE into a new SSMS query window. Set database to `AssmangMining` first.**

**Check 1 — Row counts for all 4 dimension tables:**

```sql
USE AssmangMining;
GO

SELECT
    (SELECT COUNT(*) FROM dbo.Dim_Mine)       AS MineCount,
    (SELECT COUNT(*) FROM dbo.Dim_Department) AS DepartmentCount,
    (SELECT COUNT(*) FROM dbo.Dim_Employee)   AS EmployeeCount,
    (SELECT COUNT(*) FROM dbo.Dim_Date)       AS DateCount;
```

> 📸 **Expected result:** A single row showing counts like: MineCount=5, DepartmentCount=8, EmployeeCount=120+, DateCount=730+. If any value is 0, the dataset did not load correctly.

**Check 2 — Top 10 employees with their mine and department:**

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

**Check 3 — Date range covered by the dataset:**

```sql
SELECT
    MIN(FullDate) AS StartDate,
    MAX(FullDate) AS EndDate,
    COUNT(*)      AS NumberOfDates
FROM dbo.Dim_Date;
```

> 📸 **Expected result:** StartDate = 2023-01-01, EndDate = 2024-12-31 (or similar). NumberOfDates should be ~730 (two full years of daily dates). If StartDate and EndDate are the same, the date dimension was not populated correctly.

---

*Assmang Pty Ltd — SSAS Fundamentals | Day 01 Practical Lab*

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
