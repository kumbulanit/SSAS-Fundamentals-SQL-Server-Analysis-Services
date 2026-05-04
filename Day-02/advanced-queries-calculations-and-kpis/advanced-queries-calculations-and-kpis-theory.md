# Advanced Queries, Calculations, and KPIs
## Day 02 | Assmang Pty Ltd — SSAS Fundamentals Training

---

## 🎯 Learning Objectives

By the end of this topic, participants will be able to:

1. Create calculated measures and members for business-friendly analytics.
2. Understand named sets and reusable MDX logic.
3. Design practical KPIs for production, cost, and safety monitoring.
4. Use time-based calculations to support trend analysis.

---

## 📋 Topic Overview

**Dataset:** `v3_assmang_mining_complete.sql`  
**Difficulty:** Beginner (no prior SSAS experience required)  
**Estimated reading time:** 20-30 minutes

### What is this topic about?

This topic teaches you about **Advanced Queries, Calculations, and KPIs**. If you have never worked with SQL Server Analysis Services before, don't worry — we will explain everything from scratch using plain language and real examples from Assmang's mining operations.

### Why does this matter to you?

As someone working at or with Assmang, you deal with data every day — production figures, costs, safety records, employee information. Right now, getting answers from that data probably involves:

- Asking someone in IT to write a report
- Waiting for Excel spreadsheets to be updated
- Running the same SQL queries over and over
- Not being sure if the numbers are up to date

SSAS solves these problems by creating a **pre-built analytical model** (called a "cube") that lets anyone with Excel or Power BI get instant answers without writing code.

### The Assmang training context

All examples in this course use data from Assmang's actual operations:

| Mine | What it produces | Where it is |
|------|-----------------|-------------|
| Beeshoek Mine | Iron Ore | Postmasburg, Northern Cape |
| Khumani Mine | Iron Ore | Kathu, Northern Cape |
| Black Rock Mine | Manganese | Hotazel, Northern Cape |
| Dwarsrivier Chrome Mine | Chrome | Burgersfort, Limpopo |
| Machadodorp Works | Chrome (processing) | Machadodorp, Mpumalanga |

---

## 🧠 Real-World Analogy (Plain English)

**Think of this topic like adding a dashboard with warning lights to your car.**

Basic measures tell you speed and fuel level. But KPIs are like adding warning lights — green means everything is fine, amber means pay attention, red means there is a problem. A KPI takes a measure (like production tonnes), compares it to a target, and shows a colour-coded status so executives can instantly see which mines are on track and which need attention.

> **Key insight:** SSAS takes complex data and makes it simple to explore. You don't need to be a programmer to use the results — you just need to know what question you want to answer.

---

## 1. Calculated measures

### 💬 In plain English

Let's break down **calculated measures** in the simplest possible terms:

**→** Calculated measures derive new business insight without changing the source fact table.

**→** Examples include cost per tonne, revenue variance, and tonnes per employee.

**→** These measures should be clearly named and documented for users.

### 📚 Detailed explanation

This concept is important because it directly affects how well the cube works for business users. Here is a deeper look:


**Point 1: Calculated measures derive new business insight without changing the source fact table.**

What this means in practice: When you apply this at Assmang, it means that calculated measures derive new business insight without changing the source fact table. This is not just a technical exercise — it directly helps managers, engineers, and executives get better information faster.

**Point 2: Examples include cost per tonne, revenue variance, and tonnes per employee.**

What this means in practice: When you apply this at Assmang, it means that examples include cost per tonne, revenue variance, and tonnes per employee. This is not just a technical exercise — it directly helps managers, engineers, and executives get better information faster.

**Point 3: These measures should be clearly named and documented for users.**

What this means in practice: When you apply this at Assmang, it means that these measures should be clearly named and documented for users. This is not just a technical exercise — it directly helps managers, engineers, and executives get better information faster.


### 🏭 Assmang scenario

**Situation:** A production manager at Khumani Mine asks: "Can I see this month's iron ore output compared to last month, broken down by shift?"

**How calculated measures helps:** Because the cube already has the right structure (dimensions for time and mine, measures for production), this question can be answered in seconds using Excel or Power BI — no SQL coding needed, no waiting for IT.


### ❓ Frequently Asked Questions

**Q: Do I need to be a programmer to understand calculated measures?**  
A: No. This concept is about business logic and design thinking. The tools (SSDT) provide visual interfaces for most of the work.

**Q: What happens if we get calculated measures wrong?**  
A: The cube will still work technically, but users may get confusing results, slow performance, or missing data. That's why we follow best practices from the start.

**Q: How long does it take to set up calculated measures for a real project?**  
A: For a project the size of Assmang's training cube, this typically takes a few hours of design work plus a few hours of implementation and testing.

---

## 2. Named sets and reusable logic

### 💬 In plain English

Let's break down **named sets and reusable logic** in the simplest possible terms:

**→** Named sets define reusable groups of members, such as top-performing mines or active operations.

**→** They simplify repeated report logic and improve consistency.

### 📚 Detailed explanation

This concept is important because it directly affects how well the cube works for business users. Here is a deeper look:


**Point 1: Named sets define reusable groups of members, such as top-performing mines or active operations.**

What this means in practice: When you apply this at Assmang, it means that named sets define reusable groups of members, such as top-performing mines or active operations. This is not just a technical exercise — it directly helps managers, engineers, and executives get better information faster.

**Point 2: They simplify repeated report logic and improve consistency.**

What this means in practice: When you apply this at Assmang, it means that they simplify repeated report logic and improve consistency. This is not just a technical exercise — it directly helps managers, engineers, and executives get better information faster.


### 🏭 Assmang scenario

**Situation:** A production manager at Khumani Mine asks: "Can I see this month's iron ore output compared to last month, broken down by shift?"

**How named sets and reusable logic helps:** Because the cube already has the right structure (dimensions for time and mine, measures for production), this question can be answered in seconds using Excel or Power BI — no SQL coding needed, no waiting for IT.


### ❓ Frequently Asked Questions

**Q: Do I need to be a programmer to understand named sets and reusable logic?**  
A: No. This concept is about business logic and design thinking. The tools (SSDT) provide visual interfaces for most of the work.

**Q: What happens if we get named sets and reusable logic wrong?**  
A: The cube will still work technically, but users may get confusing results, slow performance, or missing data. That's why we follow best practices from the start.

**Q: How long does it take to set up named sets and reusable logic for a real project?**  
A: For a project the size of Assmang's training cube, this typically takes a few hours of design work plus a few hours of implementation and testing.

---

## 3. KPIs in SSAS

### 💬 In plain English

Let's break down **kpis in ssas** in the simplest possible terms:

**→** A KPI combines value, goal, status, and often trend.

**→** At Assmang, KPIs can be created for safety score, production target attainment, or cost control.

**→** KPIs help executives consume analytics visually and consistently.

### 📚 Detailed explanation

This concept is important because it directly affects how well the cube works for business users. Here is a deeper look:


**Point 1: A KPI combines value, goal, status, and often trend.**

What this means in practice: When you apply this at Assmang, it means that a kpi combines value, goal, status, and often trend. This is not just a technical exercise — it directly helps managers, engineers, and executives get better information faster.

**Point 2: At Assmang, KPIs can be created for safety score, production target attainment, or cost control.**

What this means in practice: When you apply this at Assmang, it means that at assmang, kpis can be created for safety score, production target attainment, or cost control. This is not just a technical exercise — it directly helps managers, engineers, and executives get better information faster.

**Point 3: KPIs help executives consume analytics visually and consistently.**

What this means in practice: When you apply this at Assmang, it means that kpis help executives consume analytics visually and consistently. This is not just a technical exercise — it directly helps managers, engineers, and executives get better information faster.


### 🏭 Assmang scenario

**Situation:** A production manager at Khumani Mine asks: "Can I see this month's iron ore output compared to last month, broken down by shift?"

**How kpis in ssas helps:** Because the cube already has the right structure (dimensions for time and mine, measures for production), this question can be answered in seconds using Excel or Power BI — no SQL coding needed, no waiting for IT.


### ❓ Frequently Asked Questions

**Q: Do I need to be a programmer to understand kpis in ssas?**  
A: No. This concept is about business logic and design thinking. The tools (SSDT) provide visual interfaces for most of the work.

**Q: What happens if we get kpis in ssas wrong?**  
A: The cube will still work technically, but users may get confusing results, slow performance, or missing data. That's why we follow best practices from the start.

**Q: How long does it take to set up kpis in ssas for a real project?**  
A: For a project the size of Assmang's training cube, this typically takes a few hours of design work plus a few hours of implementation and testing.

---

## 4. Time-based logic

### 💬 In plain English

Let's break down **time-based logic** in the simplest possible terms:

**→** MDX calculations often compare current month to previous month, current year to previous year, or actual to target.

**→** This is where clean date hierarchies become especially valuable.

### 📚 Detailed explanation

This concept is important because it directly affects how well the cube works for business users. Here is a deeper look:


**Point 1: MDX calculations often compare current month to previous month, current year to previous year, or actual to target.**

What this means in practice: When you apply this at Assmang, it means that mdx calculations often compare current month to previous month, current year to previous year, or actual to target. This is not just a technical exercise — it directly helps managers, engineers, and executives get better information faster.

**Point 2: This is where clean date hierarchies become especially valuable.**

What this means in practice: When you apply this at Assmang, it means that this is where clean date hierarchies become especially valuable. This is not just a technical exercise — it directly helps managers, engineers, and executives get better information faster.


### 🏭 Assmang scenario

**Situation:** A production manager at Khumani Mine asks: "Can I see this month's iron ore output compared to last month, broken down by shift?"

**How time-based logic helps:** Because the cube already has the right structure (dimensions for time and mine, measures for production), this question can be answered in seconds using Excel or Power BI — no SQL coding needed, no waiting for IT.


### ❓ Frequently Asked Questions

**Q: Do I need to be a programmer to understand time-based logic?**  
A: No. This concept is about business logic and design thinking. The tools (SSDT) provide visual interfaces for most of the work.

**Q: What happens if we get time-based logic wrong?**  
A: The cube will still work technically, but users may get confusing results, slow performance, or missing data. That's why we follow best practices from the start.

**Q: How long does it take to set up time-based logic for a real project?**  
A: For a project the size of Assmang's training cube, this typically takes a few hours of design work plus a few hours of implementation and testing.

---

## 📊 Architecture / Concept Diagram

The following diagram shows how this topic fits into the bigger picture:

```text
Base Measure -> Calculation Layer -> KPI Status -> Dashboard Consumer
RevenueZAR -> Cost per Tonne -> Green/Amber/Red -> Power BI / Excel
```

### How to read this diagram

- **Left side:** Where your raw data lives (SQL Server database tables containing production, cost, safety, and employee data).
- **Middle:** Where SSAS transforms that raw data into an analytical structure (the cube with its dimensions, hierarchies, and measures).
- **Right side:** Where business users access the results (Excel pivot tables, Power BI dashboards, or MDX query results in SSMS).

### Why this matters

Without SSAS (the middle layer), every time a manager wants an answer, someone has to write SQL code against the raw database. With SSAS, the analytical structure is pre-built, so users can explore data independently using familiar tools like Excel.

---

## 📖 Key Terminology Reference

Here are the most important terms for this topic. Don't worry about memorising them all — you will learn them naturally through practice:


| Term | Plain English Definition | Example at Assmang |
|------|------------------------|-------------------|
| **Cube** | A pre-built analytical structure that lets users explore data from many angles | The "Assmang Mining Analytics" cube containing all production and cost data |
| **Dimension** | A category you use to slice data (like filters in Excel) | Mine, Date, Department, Employee — these are the "by what" categories |
| **Hierarchy** | A drill-down path from general to specific | Year → Quarter → Month → Day (time hierarchy) |
| **Member** | One specific value within a dimension | "Beeshoek Mine" is a member of the Mine dimension |
| **Measure** | A number you want to analyse | Tonnes Produced, Revenue in ZAR, Cost Per Tonne |
| **Measure Group** | A collection of related measures from one business area | Production Measures (tonnes + grade + revenue) |
| **Fact Table** | The database table that stores the raw numbers | FactProduction, FactOperatingCosts |
| **Processing** | Loading data into the cube and building pre-calculated summaries | Running a nightly job that refreshes yesterday's production data |
| **Aggregation** | A pre-calculated total or average stored for speed | Total tonnes per mine per month (calculated once, queried many times) |
| **MDX** | The query language used to ask questions of a cube | Similar to SQL, but designed for multidimensional analysis |
| **MOLAP** | Storage mode where data is stored inside the cube for maximum speed | Default choice for Assmang — gives sub-second query times |
| **ROLAP** | Storage mode where data stays in SQL Server (slower but always fresh) | Used when real-time data is more important than speed |
| **KPI** | A traffic-light indicator showing whether a target is being met | Production KPI: Green if >= 90% of target, Red if < 70% |
| **SSDT** | SQL Server Data Tools — the IDE where you design and build cubes | Visual Studio with the SSAS project templates |
| **SSMS** | SQL Server Management Studio — for administration and testing | Where you deploy cubes and run MDX queries |
| **Data Source View (DSV)** | A logical view of which database tables the cube uses | Selecting Dim_Mine, Dim_Date, FactProduction for inclusion |
| **Deployment** | Pushing your cube design from your computer to the SSAS server | Like publishing a website — makes it available to users |

---

## ✅ Best Practices for Beginners

Follow these rules from Day 1 and your SSAS projects will be much more successful:


### 1. Always start with a business question
Before building anything technical, write down the question you're trying to answer. For example: "The CEO wants to see monthly revenue by mine for the last 2 years." This drives every design decision.

### 2. Use clear, business-friendly names
Don't name a dimension `Dim_001` or a measure `M_Rev`. Instead use `Mine` and `Revenue ZAR`. The people using your cube are not programmers — they need names that make instant sense.

### 3. Keep it simple at first
Start with 3-4 dimensions and 5-6 measures. You can always add more later. A simple cube that works is infinitely better than a complex cube that confuses everyone.

### 4. Test with a real user
After building your cube, sit down with a business user (not a developer) and ask them to find an answer. Watch where they get confused. Fix those areas.

### 5. Document everything
Write down what each measure means, what each KPI threshold is, and when data is refreshed. Six months from now, you (or your replacement) will thank yourself.

### 6. Process and validate every time
After any change to the cube, always process it AND check the results. An unprocessed cube looks fine in the designer but returns no data to users.

### 7. Plan for growth
Assmang's data will grow. Design your cube so that adding a new year of data or a new mine doesn't require rebuilding everything from scratch.

---

## ⚠️ Common Mistakes (and How to Avoid Them)

Every beginner makes some of these mistakes. Knowing about them in advance will save you hours of frustration:


| # | Mistake | What goes wrong | How to prevent it |
|---|---------|----------------|-------------------|
| 1 | Building without a business question | You create objects nobody uses, wasting time and confusing users | Always start with: "What question am I answering?" |
| 2 | Using technical names | Users see `Dim_Mine.MineID` instead of just "Mine" | Set display names in the dimension designer |
| 3 | Forgetting to process | Cube deploys successfully but shows zero data | Always process after deployment and check results |
| 4 | Summing percentages | Grade shows 340% because it summed 68% + 65% + 72% + 67% + 68% | Set aggregation to AVERAGE for ratios |
| 5 | No hierarchies | Users must scroll through 730 individual dates instead of drilling Year > Month | Create hierarchies for every dimension where drill-down makes sense |
| 6 | Not testing with business users | Cube works technically but nobody can use it | Demo to a non-technical user before promoting to production |
| 7 | No documentation | Nobody knows what the KPI thresholds are or when data refreshes | Keep a living document with business rules and schedules |
| 8 | Ignoring source data quality | Cube shows wrong totals because source data has duplicates or NULLs | Validate source data before cube processing |

---

## ❓ Beginner FAQ

### "Do I need to know how to program?"
No. SSAS development uses mostly visual tools (drag and drop in SSDT). You will learn some MDX query syntax in Day 2, but it's much simpler than full programming.

### "How is this different from a normal Excel report?"
An Excel report shows you one fixed view of data. An SSAS cube lets you explore data from ANY angle — by mine, by month, by department, by commodity type — all without rebuilding the report. It's like the difference between a printed map and Google Maps.

### "How long does it take to learn SSAS?"
The basics (this 2-day course) will get you building and querying cubes. Becoming an expert takes months of practice, but you can be productive within days.

### "What if I make a mistake?"
SSAS is very forgiving during development. You can change dimensions, measures, and hierarchies as many times as you want before deploying to production. The dataset can be reloaded at any time.

### "Who uses the cube after we build it?"
Anyone with Excel or Power BI can connect to the cube and explore data. They don't need SSAS knowledge — they just use familiar tools (pivot tables, charts) that connect to the cube behind the scenes.

---

## 📝 Topic Summary

In this topic you learned about **Advanced Queries, Calculations, and KPIs**.

### Key takeaways:

- ✅ Create calculated measures and members for business-friendly analytics.
- ✅ Understand named sets and reusable MDX logic.
- ✅ Design practical KPIs for production, cost, and safety monitoring.
- ✅ Use time-based calculations to support trend analysis.

### What to do next:

1. Complete the **practical lab** (guided, step-by-step) using dataset `v3_assmang_mining_complete.sql`
2. Attempt the **later hands-on exercises** (independent practice)
3. Complete the **assessment** to test your understanding
4. Move on to the next topic when you feel confident

### How to know you understand this topic:

- You can explain the key concepts to a colleague in plain English
- You can identify where this topic fits in the overall SSAS workflow
- You can connect the concepts to a real Assmang business question
- You completed the practical lab successfully

---

*Assmang Pty Ltd — SSAS Fundamentals Training | Day 02*  
*Course: SSAS100 | Level: Beginner | Topic: Advanced Queries, Calculations, and KPIs*
