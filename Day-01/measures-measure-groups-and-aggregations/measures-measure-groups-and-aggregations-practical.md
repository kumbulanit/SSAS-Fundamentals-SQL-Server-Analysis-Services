# Practical Lab — Measures, Measure Groups, and Aggregations
## Day 01 | Assmang Pty Ltd — SSAS Fundamentals

---

## 🎯 What You Will Build Today

By the end of this lab you will have:
- Loaded the v2 dataset with production AND cost tables
- A working cube with **two measure groups** (Production + Operating Costs)
- Correct aggregation functions set on each measure
- Browser output showing tonnes, revenue, and cost per mine

**Time needed:** 60–90 minutes  
**Tools:** SSMS + Visual Studio (SSDT)

---

## ✅ Before You Start — Checklist

Make sure ALL of these are true before Step 1:

- [ ] SQL Server instance is running (check Windows Services → SQL Server)
- [ ] Analysis Services is running (check Windows Services → SQL Server Analysis Services)
- [ ] Visual Studio is installed with SQL Server Data Tools (SSDT)
- [ ] SSMS is installed
- [ ] You have the file `datasets/v2_assmang_mining_extended.sql` from this training folder

---

## 📝 Lab Steps

---

### Step 1: Load the v2 dataset into SQL Server

**What you are doing:** Loading the training data (production + cost tables) so the cube has something to read.

1. Open **SSMS**
2. In the toolbar, click **New Query**
3. In the top-left dropdown (where it shows a database name), make sure it says **`master`** — this ensures the script creates the database correctly
4. Go to **File → Open → File**
5. Navigate to your training folder: `datasets/v2_assmang_mining_extended.sql`
6. Click **Open** — the SQL script will appear in the query window
7. Press **F5** to execute the script
8. Watch the **Messages** tab at the bottom — wait until you see:
   ```
   Commands completed successfully.
   ```
9. If you see any red error text, stop and read the error before continuing

**Verify it worked:**
1. In Object Explorer (left panel), expand **Databases**
2. Right-click **Databases** and click **Refresh**
3. You should now see a database called **`AssmangMining`**

> 📸 **Screenshot Checkpoint 1 — Object Explorer after loading the dataset:**
> ```
> ▼ localhost (SQL Server ...)
>   ▼ Databases
>       AssmangMining        ← This must appear
>           ▼ Tables
>               dbo.Dim_Date
>               dbo.Dim_Department
>               dbo.Dim_Mine
>               dbo.FactOperatingCosts
>               dbo.FactProduction
> ```
> If `AssmangMining` does not appear: scroll up in the Messages tab and look for red error text.
4. Expand it → **Tables** → you should see at least these tables:
   - `dbo.Dim_Mine`
   - `dbo.Dim_Date`
   - `dbo.Dim_Department`
   - `dbo.FactProduction`
   - `dbo.FactOperatingCosts`

> **If AssmangMining does not appear:** Scroll up in the Messages tab and look for red error text. The most common fix is to ensure you are connected to the correct SQL instance.

---

### Step 2: Run the SQL validation queries to confirm your data

**What you are doing:** Checking the data loaded correctly before building the cube. Never build on data you haven't verified.

1. In SSMS, click **New Query**
2. In the database dropdown at the top, select **`AssmangMining`**
3. Copy and paste this query:

> ✅ **COPY THIS ENTIRE SQL BLOCK:**

```sql
SELECT
    m.MineName,
    SUM(fp.TonnesProduced) AS TotalTonnes,
    SUM(fp.RevenueZAR)     AS TotalRevenueZAR,
    AVG(fp.Grade)          AS AvgGrade
FROM dbo.FactProduction fp
JOIN dbo.Dim_Mine m ON fp.MineID = m.MineID
GROUP BY m.MineName
ORDER BY TotalTonnes DESC;
```

4. Press **F5** to run
5. You should see rows for each mine (Khumani, Beeshoek, Black Rock, Dwarsrivier) with non-zero values

**Then run this second check for costs:**

> ✅ **COPY THIS ENTIRE SQL BLOCK:**

```sql
SELECT
    m.MineName,
    SUM(oc.LaborCostZAR + oc.MaintenanceCostZAR + oc.EquipmentCostZAR) AS TotalCost
FROM dbo.FactOperatingCosts oc
JOIN dbo.Dim_Mine m ON oc.MineID = m.MineID
GROUP BY m.MineName
ORDER BY TotalCost DESC;
```

6. Press **F5** — you should see cost data per mine

**Write down these numbers** — you will compare them against the cube results later.

> 📸 **Screenshot Checkpoint 2 — SQL validation result:**
> Results grid shows one row per mine with non-zero values:
> ```
> MineName           TotalTonnes    TotalRevenueZAR    AvgGrade
> Khumani Mine       45,200         28,500,000         62.4
> Beeshoek Mine      32,500         18,200,000         58.1
> Black Rock Mine    28,100         12,600,000         35.2
> Dwarsrivier Mine   15,600         9,500,000          41.8
> ```
> If the grid is empty — the dataset did not load. Repeat Step 1.

> **If either query returns 0 rows or errors:** The dataset did not load correctly. Repeat Step 1.

---

### Step 3: Open Visual Studio and open the SSAS project

**What you are doing:** Opening the cube project where you will design the measure groups.

1. Open **Visual Studio**
2. Click **File → Open → Project/Solution**
3. Navigate to your training folder and find the file ending in `.sln` (solution file)
4. Click **Open**
5. Wait for Visual Studio to load the project (watch the status bar at the bottom)
6. In **Solution Explorer** (right side panel), you should see your SSAS project with folders:
   - Data Sources
   - Data Source Views
   - Cubes
   - Dimensions

> **If Solution Explorer is not visible:** Click **View → Solution Explorer**

---

### Step 4: Check the Data Source connection

**What you are doing:** Making sure the cube project can reach your SQL Server database.

1. In Solution Explorer, expand **Data Sources**
2. Double-click the data source (it will have a `.ds` extension)
3. In the Data Source Designer that opens, look at the connection string — it should point to your SQL Server instance and `AssmangMining`
4. Click **Test Connection**
5. You should see a green tick and: **"Test connection succeeded"**
6. Click **OK**, then close the Data Source Designer

> 📸 **Screenshot Checkpoint 3 — Test Connection dialog:**
> A small popup dialog appears saying: "Test connection succeeded." with a green checkmark icon and an OK button.
> If you see "Login failed" or "The server was not found", the Server Name in the connection string is wrong — click Edit to fix it.

> **If Test Connection fails:** The server name or database name is wrong. Click **Edit** in the connection string and update the server name to match your SQL Server instance (e.g., `localhost` or `.\SQLEXPRESS`).

---

### Step 5: Add the two fact tables to the Data Source View

**What you are doing:** Telling the cube which tables it is allowed to use. Right now it may only have the dimension tables. You need to add `FactProduction` and `FactOperatingCosts`.

1. In Solution Explorer, expand **Data Source Views**
2. Double-click the `.dsv` file to open the Data Source View designer
3. You will see a diagram with boxes (tables) connected by lines (relationships)
4. Right-click in an empty area of the diagram
5. Click **Add/Remove Tables**
6. In the left panel (Available objects), scroll down and find:
   - `FactProduction`
   - `FactOperatingCosts`
7. Click `FactProduction` to highlight it, then click **>** to move it to the right panel (Included objects)
8. Click `FactOperatingCosts` to highlight it, then click **>** to move it to the right panel
9. Click **OK**
10. The two fact tables now appear in the diagram. You should see lines connecting them to the dimension tables.
11. Press **Ctrl+S** to save

> 📸 **Screenshot Checkpoint 4 — DSV diagram after adding fact tables:**
> The design canvas now shows 5+ table boxes connected by lines:
> ```
> [Dim_Mine] ──────────── [FactProduction]
>     │                          │
>     └─────────── [FactOperatingCosts]
>
> [Dim_Date] ──────────── [FactProduction]
>     │                          │
>     └─────────── [FactOperatingCosts]
>
> [Dim_Department]
> ```
> If there are no lines between FactProduction and Dim_Mine, the foreign key relationship does not exist in SQL. Check the SQL script was loaded correctly.

**Verify it looks right:** The diagram should now show dimension tables (Mine, Date, Department) connected to fact tables (FactProduction, FactOperatingCosts). If lines are missing between fact and dimension tables, you need to verify the SQL foreign keys exist.

---

### Step 6: Open the Cube Designer and inspect the measure groups

**What you are doing:** Checking that the cube has both measure groups available — or creating them if they don't exist yet.

1. In Solution Explorer, expand **Cubes**
2. Double-click the cube file (`.cube` extension) to open the Cube Designer
3. You will see multiple tabs at the top: **Cube Structure**, **Dimension Usage**, **Calculations**, **KPIs**, **Browser**
4. Click the **Cube Structure** tab
5. Look at the left panel — you should see a section called **Measures**
6. Expand **Measures** — you should see two groups:
   - **Production** (or FactProduction) with measures like TonnesProduced, RevenueZAR, Grade
   - **Operating Costs** (or FactOperatingCosts) with measures like LaborCostZAR, MaintenanceCostZAR

> **If only one measure group exists or neither exists:** Right-click inside the Measures panel and choose **New Measure Group**, then select the missing fact table.

> 📸 **Screenshot Checkpoint 5 — Cube Structure tab showing two measure groups:**
> On the **Cube Structure** tab, look at the left panel labelled "Measures":
> ```
> ▼ Measures
>   ▼ Production
>       TonnesProduced
>       RevenueZAR
>       Grade
>   ▼ Operating Costs
>       LaborCostZAR
>       MaintenanceCostZAR
>       EquipmentCostZAR
>       SafetyCostZAR
>       UtilitiesCostZAR
>       OtherCostZAR
> ```
> If you only see one group (or none), add the missing fact table as a new measure group.

---

### Step 7: Set the correct aggregation function for each measure

**What you are doing:** This is the most important step. You are telling SSAS how to combine detail rows into summaries. Wrong settings here = wrong numbers in reports.

**For each measure below, right-click it in the Measures panel → Properties:**

| Measure | Set AggregationFunction to | Why |
|---------|---------------------------|-----|
| TonnesProduced | **Sum** | You can add tonnes across all dimensions |
| RevenueZAR | **Sum** | You can add revenue across all dimensions |
| Grade | **None** (handle as calculated) | Cannot sum percentages |
| LaborCostZAR | **Sum** | You can add costs across all dimensions |
| MaintenanceCostZAR | **Sum** | You can add costs across all dimensions |
| EquipmentCostZAR | **Sum** | You can add costs across all dimensions |

**Step-by-step for each measure:**
1. In the Measures panel, click the measure name once to select it
2. Look at the **Properties** panel (bottom-right or press F4 to open it)
3. Find the property called **AggregationFunction**
4. Click the dropdown and select the correct function from the table above
5. Repeat for all measures

> 📸 **Screenshot Checkpoint 6 — Properties panel for a measure:**
> When a measure is selected, the **Properties** panel (bottom-right of Visual Studio, or press F4) shows:
> ```
> Properties
> TonnesProduced Measure
> ─────────────────────────────
> AggregationFunction    Sum     ← Change this dropdown
> DataType               Integer
> FormatString
> Name                   TonnesProduced
> ```
> Click the AggregationFunction dropdown and select the correct value from the table above.

**Also clean up measure names so they look good in reports:**
1. Right-click a measure → **Rename**
2. Change `TonnesProduced` to `Tonnes Produced`
3. Change `RevenueZAR` to `Revenue (ZAR)`
4. Change `LaborCostZAR` to `Labor Cost (ZAR)`
5. Press **Ctrl+S** to save after renaming

---

### Step 8: Add a calculated measure for Cost Per Tonne

**What you are doing:** CostPerTonne cannot simply be summed — it must be calculated using a formula. You will add it as a calculated measure.

1. In the Cube Designer, click the **Calculations** tab
2. Click the **New Calculated Member** button (looks like a formula icon in the toolbar, or right-click the Calculations panel → New Calculated Member)
3. In the **Name** field, type: `Cost Per Tonne ZAR`

4. Click inside the **Expression** box

5. Copy and paste this formula:

> ✅ **COPY THIS FORMULA EXACTLY — paste it into the Expression box:**

```
[Measures].[Labor Cost (ZAR)] / [Measures].[Tonnes Produced]
```

> ⚠️ **The square brackets `[ ]` are required.** If you renamed the measures in Step 7 with different spelling (e.g., "Labour" with a 'u'), the formula must use the renamed version exactly.

6. Click anywhere outside the expression box to confirm it
7. Press **Ctrl+S** to save

> 📸 **Screenshot Checkpoint 7 — Calculations tab:**
> After adding the formula, the **Calculations** tab shows:
> - Left panel (Script Organizer): lists `[Cost Per Tonne ZAR]` as a member
> - Right panel: shows the expression you typed
> - The formula should NOT show any red underlines (red = syntax error)

> **Why this formula:** Instead of pre-calculating cost per tonne in the database (which gives wrong answers when aggregated), SSAS computes it dynamically at whatever level the user is viewing — per shift, per mine, per quarter — always correctly.

---

### Step 9: Build and Deploy the cube

**What you are doing:** Sending your cube design to the SSAS server so it can be processed and queried.

**Build first:**
1. Click **Build → Build Solution** in the top menu
2. Watch the **Output** window at the bottom (if not visible: View → Output)
3. Wait for: **"Build succeeded"** with 0 errors
4. If you see errors, click each one in the Error List and fix before continuing

**Then deploy:**
1. In Solution Explorer, right-click the SSAS project name
2. Click **Deploy**
3. Watch the Output window — you will see messages like:
   ```
   Deploying database...
   Deploying dimensions...
   Deploying cubes...
   Deployment completed successfully.
   ```
4. Wait for **"Deployment completed successfully"** — this can take 30–60 seconds

> 📸 **Screenshot Checkpoint 8 — Output window after deployment:**
> The Output panel at the bottom of Visual Studio shows a scrollable log. The last line should read:
> `Deployment completed successfully.`
> If the last line says `Deployment FAILED`, scroll up in the log to find the error line — it usually identifies a server name or permission issue.

> **If deployment fails with "cannot connect to server":** Check that Analysis Services is running (Windows Services → SQL Server Analysis Services → Start).

---

### Step 10: Process the cube and validate results in the Browser

**What you are doing:** Processing loads the actual data into the cube. Without processing, deployment creates the structure but the cube is empty.

**Process the cube:**
1. After successful deployment, a dialog may automatically ask if you want to process — click **Yes**
2. If no dialog appears: In SSMS, connect to Analysis Services → expand Databases → right-click **Assmang Mining Analytics** → **Process**
3. In the Process dialog, click **Run**
4. Watch the progress — wait for all items to show **Success**
5. Click **Close**

> 📸 **Screenshot Checkpoint 9 — Processing results:**
> The Process dialog shows a table. After all items complete, every row should show **Success** in the Status column:
> ```
> Object                              Type            Status
> Assmang Mining Analytics            Database        Success
>   Production Measure Group          Measure Group   Success
>   Operating Costs Measure Group     Measure Group   Success
>   Mine Dimension                    Dimension       Success
>   Date Dimension                    Dimension       Success
> ```
> If any row shows **Error** — click the row to see the error detail below the table.

**Validate in the Browser:**
1. Back in Visual Studio, in the Cube Designer, click the **Browser** tab
2. Click **Reconnect** if prompted
3. In the **Measures** panel on the left, drag **Tonnes Produced** into the centre data area
4. In the **Dimensions** panel, drag **Mine → Mine Name** to the rows area
5. You should now see a table: each mine in a row with its total tonnes

> 📸 **Screenshot Checkpoint 10 — Browser tab with mine production data:**
> The Browser tab shows:
> - Left panel: metadata tree listing Measures (Tonnes Produced, Revenue ZAR, etc.) and Dimensions (Mine, Date, etc.)
> - Centre: a grid showing the query result
> ```
> Mine Name          Tonnes Produced
> Beeshoek Mine      32,500
> Black Rock Mine    28,100
> Dwarsrivier Mine   15,600
> Khumani Mine       45,200
> Grand Total        121,400
> ```
> Compare Khumani Mine's number to your SQL query result from Step 2. They should match.

**Compare to your SQL baseline from Step 2:**
- Find Khumani Mine's TotalTonnes from your Step 2 SQL result
- Compare to what the Browser shows for Khumani
- They should match (or be very close — any difference = a data issue worth investigating)

6. Now drag **Revenue (ZAR)** next to Tonnes Produced in the data area
7. Drag **Labor Cost (ZAR)** next to Revenue
8. You should see a 3-column table: tonnes, revenue, and labor cost per mine

---

## ✅ Validation Checklist

Before you finish this lab, confirm every item:

- [ ] v2 dataset loaded — `AssmangMining` database exists with all tables
- [ ] SQL validation queries returned non-zero results for all mines
- [ ] Both fact tables appear in the Data Source View diagram
- [ ] Cube has two measure groups: Production and Operating Costs
- [ ] TonnesProduced and RevenueZAR have AggregationFunction = Sum
- [ ] Grade is NOT set to Sum
- [ ] Cost Per Tonne calculated measure exists with correct formula
- [ ] Build succeeded (0 errors)
- [ ] Deployment succeeded
- [ ] Processing succeeded (no failures in the process log)
- [ ] Browser shows per-mine results that match your SQL baseline

---

## 🎓 Expected Outcome

You can now:
- Explain the difference between a fact table (SQL) and a measure group (SSAS)
- Set correct aggregation on each measure
- Build a calculated measure using MDX formula
- Browse cube results and cross-check against SQL

---
```sql
USE AssmangMining;
GO

SELECT
	COUNT(*) AS FactProductionRows,
	COUNT(DISTINCT MineID) AS MineCount,
	MIN(DateID) AS MinDateID,
	MAX(DateID) AS MaxDateID
FROM dbo.FactProduction;
```

```sql
SELECT
	m.MineName,
	SUM(fp.TonnesProduced) AS TotalTonnes,
	SUM(fp.RevenueZAR) AS TotalRevenueZAR,
	AVG(fp.Grade) AS AvgGrade
FROM dbo.FactProduction fp
JOIN dbo.Dim_Mine m ON fp.MineID = m.MineID
GROUP BY m.MineName
ORDER BY TotalTonnes DESC;
```

```sql
SELECT
	m.MineName,
	d.DepartmentName,
	SUM(oc.LaborCostZAR + oc.EquipmentCostZAR + oc.MaintenanceCostZAR + oc.SafetyCostZAR + oc.UtilitiesCostZAR + oc.OtherCostZAR) AS TotalOperatingCost
FROM dbo.FactOperatingCosts oc
JOIN dbo.Dim_Mine m ON oc.MineID = m.MineID
JOIN dbo.Dim_Department d ON oc.DepartmentID = d.DepartmentID
GROUP BY m.MineName, d.DepartmentName
ORDER BY m.MineName, d.DepartmentName;
```

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
