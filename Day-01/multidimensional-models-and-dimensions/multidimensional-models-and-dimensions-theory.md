# Multidimensional Models and Dimensions
## Day 01 | Assmang Pty Ltd — SSAS Fundamentals Training

---

## 🎯 Learning Objectives

By the end of this topic, participants will be able to:

1. Understand star-schema thinking and how dimensions support analysis.
2. Design dimensions from the Assmang dimension tables.
3. Build hierarchies that support drill-down navigation.
4. Recognise common dimension design issues such as poor keys or weak hierarchies.

---

## 📋 Topic Overview

**Dataset:** `v1_assmang_mining_base.sql`  
**Difficulty:** Beginner (no prior SSAS experience required)  
**Estimated reading time:** 20-30 minutes

### What is this topic about?

This topic teaches you about **Multidimensional Models and Dimensions**. If you have never worked with SQL Server Analysis Services before, don't worry — we will explain everything from scratch using plain language and real examples from Assmang's mining operations.

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

**Think of this topic like the labels on filing cabinet drawers.**

Think of dimensions like the labels on a filing cabinet. One drawer is labelled 'By Mine', another 'By Month', another 'By Department'. When you want to find production data for Beeshoek in March, you open the 'Mine' drawer, find 'Beeshoek', then look in the 'Month' section for 'March'. Dimensions are those category labels that help you navigate to exactly the data you need.

> **Key insight:** SSAS takes complex data and makes it simple to explore. You don't need to be a programmer to use the results — you just need to know what question you want to answer.

---

## 1. Dimensional thinking

### 💬 In plain English

Let's break down **dimensional thinking** in the simplest possible terms:

**→** A multidimensional model separates descriptive business context from measurable facts.

**→** Dimension tables answer 'by what' questions: by mine, by month, by department, by employee.

**→** A clean dimension model improves user navigation and aggregation behaviour.

### 📚 Detailed explanation

This concept is important because it directly affects how well the cube works for business users. Here is a deeper look:


**Point 1: A multidimensional model separates descriptive business context from measurable facts.**

What this means in practice: When you apply this at Assmang, it means that a multidimensional model separates descriptive business context from measurable facts. This is not just a technical exercise — it directly helps managers, engineers, and executives get better information faster.

**Point 2: Dimension tables answer 'by what' questions: by mine, by month, by department, by employee.**

What this means in practice: When you apply this at Assmang, it means that dimension tables answer 'by what' questions: by mine, by month, by department, by employee. This is not just a technical exercise — it directly helps managers, engineers, and executives get better information faster.

**Point 3: A clean dimension model improves user navigation and aggregation behaviour.**

What this means in practice: When you apply this at Assmang, it means that a clean dimension model improves user navigation and aggregation behaviour. This is not just a technical exercise — it directly helps managers, engineers, and executives get better information faster.


### 🏭 Assmang scenario

**Situation:** A production manager at Khumani Mine asks: "Can I see this month's iron ore output compared to last month, broken down by shift?"

**How dimensional thinking helps:** Because the cube already has the right structure (dimensions for time and mine, measures for production), this question can be answered in seconds using Excel or Power BI — no SQL coding needed, no waiting for IT.


### ❓ Frequently Asked Questions

**Q: Do I need to be a programmer to understand dimensional thinking?**  
A: No. This concept is about business logic and design thinking. The tools (SSDT) provide visual interfaces for most of the work.

**Q: What happens if we get dimensional thinking wrong?**  
A: The cube will still work technically, but users may get confusing results, slow performance, or missing data. That's why we follow best practices from the start.

**Q: How long does it take to set up dimensional thinking for a real project?**  
A: For a project the size of Assmang's training cube, this typically takes a few hours of design work plus a few hours of implementation and testing.

---

## 2. Assmang dimensions

### 💬 In plain English

Let's break down **assmang dimensions** in the simplest possible terms:

**→** `Dim_Mine` supports analysis by mine, province, and commodity type.

**→** `Dim_Date` supports time intelligence through year, quarter, month, and day levels.

**→** `Dim_Department` supports cost and people analysis by function area.

**→** `Dim_Employee` supports workforce-centric reporting and role-based views.

### 📚 Detailed explanation

This concept is important because it directly affects how well the cube works for business users. Here is a deeper look:


**Point 1: `Dim_Mine` supports analysis by mine, province, and commodity type.**

What this means in practice: When you apply this at Assmang, it means that `dim_mine` supports analysis by mine, province, and commodity type. This is not just a technical exercise — it directly helps managers, engineers, and executives get better information faster.

**Point 2: `Dim_Date` supports time intelligence through year, quarter, month, and day levels.**

What this means in practice: When you apply this at Assmang, it means that `dim_date` supports time intelligence through year, quarter, month, and day levels. This is not just a technical exercise — it directly helps managers, engineers, and executives get better information faster.

**Point 3: `Dim_Department` supports cost and people analysis by function area.**

What this means in practice: When you apply this at Assmang, it means that `dim_department` supports cost and people analysis by function area. This is not just a technical exercise — it directly helps managers, engineers, and executives get better information faster.

**Point 4: `Dim_Employee` supports workforce-centric reporting and role-based views.**

What this means in practice: When you apply this at Assmang, it means that `dim_employee` supports workforce-centric reporting and role-based views. This is not just a technical exercise — it directly helps managers, engineers, and executives get better information faster.


### 🏭 Assmang scenario

**Situation:** A production manager at Khumani Mine asks: "Can I see this month's iron ore output compared to last month, broken down by shift?"

**How assmang dimensions helps:** Because the cube already has the right structure (dimensions for time and mine, measures for production), this question can be answered in seconds using Excel or Power BI — no SQL coding needed, no waiting for IT.


### ❓ Frequently Asked Questions

**Q: Do I need to be a programmer to understand assmang dimensions?**  
A: No. This concept is about business logic and design thinking. The tools (SSDT) provide visual interfaces for most of the work.

**Q: What happens if we get assmang dimensions wrong?**  
A: The cube will still work technically, but users may get confusing results, slow performance, or missing data. That's why we follow best practices from the start.

**Q: How long does it take to set up assmang dimensions for a real project?**  
A: For a project the size of Assmang's training cube, this typically takes a few hours of design work plus a few hours of implementation and testing.

---

## 3. Hierarchies and drill paths

### 💬 In plain English

Let's break down **hierarchies and drill paths** in the simplest possible terms:

**→** A hierarchy gives users a guided navigation path rather than a flat list of attributes.

**→** Examples include Time: Year > Quarter > Month > Day and Mine: Mine Type > Province > Mine Name.

**→** Good hierarchies make Excel pivot navigation and MDX browsing easier.

### 📚 Detailed explanation

This concept is important because it directly affects how well the cube works for business users. Here is a deeper look:


**Point 1: A hierarchy gives users a guided navigation path rather than a flat list of attributes.**

What this means in practice: When you apply this at Assmang, it means that a hierarchy gives users a guided navigation path rather than a flat list of attributes. This is not just a technical exercise — it directly helps managers, engineers, and executives get better information faster.

**Point 2: Examples include Time: Year > Quarter > Month > Day and Mine: Mine Type > Province > Mine Name.**

What this means in practice: When you apply this at Assmang, it means that examples include time: year > quarter > month > day and mine: mine type > province > mine name. This is not just a technical exercise — it directly helps managers, engineers, and executives get better information faster.

**Point 3: Good hierarchies make Excel pivot navigation and MDX browsing easier.**

What this means in practice: When you apply this at Assmang, it means that good hierarchies make excel pivot navigation and mdx browsing easier. This is not just a technical exercise — it directly helps managers, engineers, and executives get better information faster.


### 🏭 Assmang scenario

**Situation:** A production manager at Khumani Mine asks: "Can I see this month's iron ore output compared to last month, broken down by shift?"

**How hierarchies and drill paths helps:** Because the cube already has the right structure (dimensions for time and mine, measures for production), this question can be answered in seconds using Excel or Power BI — no SQL coding needed, no waiting for IT.


### ❓ Frequently Asked Questions

**Q: Do I need to be a programmer to understand hierarchies and drill paths?**  
A: No. This concept is about business logic and design thinking. The tools (SSDT) provide visual interfaces for most of the work.

**Q: What happens if we get hierarchies and drill paths wrong?**  
A: The cube will still work technically, but users may get confusing results, slow performance, or missing data. That's why we follow best practices from the start.

**Q: How long does it take to set up hierarchies and drill paths for a real project?**  
A: For a project the size of Assmang's training cube, this typically takes a few hours of design work plus a few hours of implementation and testing.

---

## 4. Slowly changing dimensions

### 💬 In plain English

Let's break down **slowly changing dimensions** in the simplest possible terms:

**→** Type 1 overwrites old values and is useful when history is not required.

**→** Type 2 preserves historical versions and is useful when reporting must reflect old business states.

**→** Beginners should understand the concept even if the training implementation stays simple.

### 📚 Detailed explanation

This concept is important because it directly affects how well the cube works for business users. Here is a deeper look:


**Point 1: Type 1 overwrites old values and is useful when history is not required.**

What this means in practice: When you apply this at Assmang, it means that type 1 overwrites old values and is useful when history is not required. This is not just a technical exercise — it directly helps managers, engineers, and executives get better information faster.

**Point 2: Type 2 preserves historical versions and is useful when reporting must reflect old business states.**

What this means in practice: When you apply this at Assmang, it means that type 2 preserves historical versions and is useful when reporting must reflect old business states. This is not just a technical exercise — it directly helps managers, engineers, and executives get better information faster.

**Point 3: Beginners should understand the concept even if the training implementation stays simple.**

What this means in practice: When you apply this at Assmang, it means that beginners should understand the concept even if the training implementation stays simple. This is not just a technical exercise — it directly helps managers, engineers, and executives get better information faster.


### 🏭 Assmang scenario

**Situation:** A production manager at Khumani Mine asks: "Can I see this month's iron ore output compared to last month, broken down by shift?"

**How slowly changing dimensions helps:** Because the cube already has the right structure (dimensions for time and mine, measures for production), this question can be answered in seconds using Excel or Power BI — no SQL coding needed, no waiting for IT.


### ❓ Frequently Asked Questions

**Q: Do I need to be a programmer to understand slowly changing dimensions?**  
A: No. This concept is about business logic and design thinking. The tools (SSDT) provide visual interfaces for most of the work.

**Q: What happens if we get slowly changing dimensions wrong?**  
A: The cube will still work technically, but users may get confusing results, slow performance, or missing data. That's why we follow best practices from the start.

**Q: How long does it take to set up slowly changing dimensions for a real project?**  
A: For a project the size of Assmang's training cube, this typically takes a few hours of design work plus a few hours of implementation and testing.

---

## 📊 Architecture / Concept Diagram

The following diagram shows how this topic fits into the bigger picture:

```text
                Dim_Date
                   |
Dim_Mine ---- Fact_Production ---- Dim_Department
                   |
              Dim_Employee
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

In this topic you learned about **Multidimensional Models and Dimensions**.

### Key takeaways:

- ✅ Understand star-schema thinking and how dimensions support analysis.
- ✅ Design dimensions from the Assmang dimension tables.
- ✅ Build hierarchies that support drill-down navigation.
- ✅ Recognise common dimension design issues such as poor keys or weak hierarchies.

### What to do next:

1. Complete the **practical lab** (guided, step-by-step) using dataset `v1_assmang_mining_base.sql`
2. Attempt the **later hands-on exercises** (independent practice)
3. Complete the **assessment** to test your understanding
4. Move on to the next topic when you feel confident

### How to know you understand this topic:

- You can explain the key concepts to a colleague in plain English
- You can identify where this topic fits in the overall SSAS workflow
- You can connect the concepts to a real Assmang business question
- You completed the practical lab successfully

---

*Assmang Pty Ltd — SSAS Fundamentals Training | Day 01*  
*Course: SSAS100 | Level: Beginner | Topic: Multidimensional Models and Dimensions*
