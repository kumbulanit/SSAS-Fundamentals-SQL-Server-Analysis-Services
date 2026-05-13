# Measures, Measure Groups, and Aggregations
## Day 01 | Assmang Pty Ltd — SSAS Fundamentals Training

---

## 🎯 Learning Objectives

By the end of this topic, participants will be able to:

1. Understand the relationship between fact tables, measure groups, and cube measures.
2. Choose correct aggregation behavior for common mining metrics.
3. Recognise additive, semi-additive, and non-additive business values.
4. Understand the purpose of aggregations in performance optimisation.

---

## 📋 Topic Overview

**Dataset:** `v2_assmang_mining_extended.sql`  
**Difficulty:** Beginner (no prior SSAS experience required)  
**Estimated reading time:** 20-30 minutes

### What is this topic about?

This topic teaches you about **Measures, Measure Groups, and Aggregations**. If you have never worked with SQL Server Analysis Services before, don't worry — we will explain everything from scratch using plain language and real examples from Assmang's mining operations.

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

**Think of this topic like the numbers on a sports scoreboard.**

Think of measures like the numbers on a sports scoreboard — points scored, time remaining, fouls committed. These are the actual VALUES you care about. The scoreboard itself organises them by team (one dimension) and by quarter (another dimension). In SSAS, measures are the numbers (tonnes, revenue, cost) and measure groups are the scoreboards that organise related numbers together.

> **Key insight:** SSAS takes complex data and makes it simple to explore. You don't need to be a programmer to use the results — you just need to know what question you want to answer.

---

## 1. Fact tables and measure groups

### 💬 In plain English

Let's break down **fact tables and measure groups** in the simplest possible terms:

**→** A fact table stores measurable business events at a defined grain.

**→** In SSAS, fact tables surface as measure groups.

**→** `FactProduction` becomes a production measure group; `FactOperatingCosts` becomes a cost measure group.

### 📚 Detailed explanation

This concept is important because it directly affects how well the cube works for business users. Here is a deeper look:


**Point 1: A fact table stores measurable business events at a defined grain.**

What this means in practice: When you apply this at Assmang, it means that a fact table stores measurable business events at a defined grain. This is not just a technical exercise — it directly helps managers, engineers, and executives get better information faster.

**Point 2: In SSAS, fact tables surface as measure groups.**

What this means in practice: When you apply this at Assmang, it means that in ssas, fact tables surface as measure groups. This is not just a technical exercise — it directly helps managers, engineers, and executives get better information faster.

**Point 3: `FactProduction` becomes a production measure group; `FactOperatingCosts` becomes a cost measure group.**

What this means in practice: When you apply this at Assmang, it means that `factproduction` becomes a production measure group; `factoperatingcosts` becomes a cost measure group. This is not just a technical exercise — it directly helps managers, engineers, and executives get better information faster.


### 🏭 Assmang scenario

**Situation:** A production manager at Khumani Mine asks: "Can I see this month's iron ore output compared to last month, broken down by shift?"

**How fact tables and measure groups helps:** Because the cube already has the right structure (dimensions for time and mine, measures for production), this question can be answered in seconds using Excel or Power BI — no SQL coding needed, no waiting for IT.


### ❓ Frequently Asked Questions

**Q: Do I need to be a programmer to understand fact tables and measure groups?**  
A: No. This concept is about business logic and design thinking. The tools (SSDT) provide visual interfaces for most of the work.

**Q: What happens if we get fact tables and measure groups wrong?**  
A: The cube will still work technically, but users may get confusing results, slow performance, or missing data. That's why we follow best practices from the start.

**Q: How long does it take to set up fact tables and measure groups for a real project?**  
A: For a project the size of Assmang's training cube, this typically takes a few hours of design work plus a few hours of implementation and testing.

---

## 2. Choosing measures

### 💬 In plain English

Let's break down **choosing measures** in the simplest possible terms:

**→** Production metrics include tonnes produced, grade, revenue, and cost per tonne.

**→** Cost metrics include labour, equipment, maintenance, safety, utilities, and other costs.

**→** Measures should reflect the grain of the underlying fact and have meaningful aggregation rules.

### 📚 Detailed explanation

This concept is important because it directly affects how well the cube works for business users. Here is a deeper look:


**Point 1: Production metrics include tonnes produced, grade, revenue, and cost per tonne.**

What this means in practice: When you apply this at Assmang, it means that production metrics include tonnes produced, grade, revenue, and cost per tonne. This is not just a technical exercise — it directly helps managers, engineers, and executives get better information faster.

**Point 2: Cost metrics include labour, equipment, maintenance, safety, utilities, and other costs.**

What this means in practice: When you apply this at Assmang, it means that cost metrics include labour, equipment, maintenance, safety, utilities, and other costs. This is not just a technical exercise — it directly helps managers, engineers, and executives get better information faster.

**Point 3: Measures should reflect the grain of the underlying fact and have meaningful aggregation rules.**

What this means in practice: When you apply this at Assmang, it means that measures should reflect the grain of the underlying fact and have meaningful aggregation rules. This is not just a technical exercise — it directly helps managers, engineers, and executives get better information faster.


### 🏭 Assmang scenario

**Situation:** A production manager at Khumani Mine asks: "Can I see this month's iron ore output compared to last month, broken down by shift?"

**How choosing measures helps:** Because the cube already has the right structure (dimensions for time and mine, measures for production), this question can be answered in seconds using Excel or Power BI — no SQL coding needed, no waiting for IT.


### ❓ Frequently Asked Questions

**Q: Do I need to be a programmer to understand choosing measures?**  
A: No. This concept is about business logic and design thinking. The tools (SSDT) provide visual interfaces for most of the work.

**Q: What happens if we get choosing measures wrong?**  
A: The cube will still work technically, but users may get confusing results, slow performance, or missing data. That's why we follow best practices from the start.

**Q: How long does it take to set up choosing measures for a real project?**  
A: For a project the size of Assmang's training cube, this typically takes a few hours of design work plus a few hours of implementation and testing.

---

## 3. Aggregation behaviour

### 💬 In plain English

Let's break down **aggregation behaviour** in the simplest possible terms:

**→** Additive measures such as revenue and labour cost usually sum well across most dimensions.

**→** Average-style measures such as grade or uptime should not be blindly summed.

**→** Design choices here directly affect business trust in the cube.

### 📚 Detailed explanation

This concept is important because it directly affects how well the cube works for business users. Here is a deeper look:


**Point 1: Additive measures such as revenue and labour cost usually sum well across most dimensions.**

What this means in practice: When you apply this at Assmang, it means that additive measures such as revenue and labour cost usually sum well across most dimensions. This is not just a technical exercise — it directly helps managers, engineers, and executives get better information faster.

**Point 2: Average-style measures such as grade or uptime should not be blindly summed.**

What this means in practice: When you apply this at Assmang, it means that average-style measures such as grade or uptime should not be blindly summed. This is not just a technical exercise — it directly helps managers, engineers, and executives get better information faster.

**Point 3: Design choices here directly affect business trust in the cube.**

What this means in practice: When you apply this at Assmang, it means that design choices here directly affect business trust in the cube. This is not just a technical exercise — it directly helps managers, engineers, and executives get better information faster.


### 🏭 Assmang scenario

**Situation:** A production manager at Khumani Mine asks: "Can I see this month's iron ore output compared to last month, broken down by shift?"

**How aggregation behaviour helps:** Because the cube already has the right structure (dimensions for time and mine, measures for production), this question can be answered in seconds using Excel or Power BI — no SQL coding needed, no waiting for IT.


### ❓ Frequently Asked Questions

**Q: Do I need to be a programmer to understand aggregation behaviour?**  
A: No. This concept is about business logic and design thinking. The tools (SSDT) provide visual interfaces for most of the work.

**Q: What happens if we get aggregation behaviour wrong?**  
A: The cube will still work technically, but users may get confusing results, slow performance, or missing data. That's why we follow best practices from the start.

**Q: How long does it take to set up aggregation behaviour for a real project?**  
A: For a project the size of Assmang's training cube, this typically takes a few hours of design work plus a few hours of implementation and testing.

---

## 4. Why aggregations matter

### 💬 In plain English

Let's break down **why aggregations matter** in the simplest possible terms:

**→** SSAS pre-computes useful summaries so queries do not always scan the full fact table.

**→** This makes repeated management queries much faster.

**→** Aggregation design is one of the reasons cube workloads feel responsive.

### 📚 Detailed explanation

This concept is important because it directly affects how well the cube works for business users. Here is a deeper look:


**Point 1: SSAS pre-computes useful summaries so queries do not always scan the full fact table.**

What this means in practice: When you apply this at Assmang, it means that ssas pre-computes useful summaries so queries do not always scan the full fact table. This is not just a technical exercise — it directly helps managers, engineers, and executives get better information faster.

**Point 2: This makes repeated management queries much faster.**

What this means in practice: When you apply this at Assmang, it means that this makes repeated management queries much faster. This is not just a technical exercise — it directly helps managers, engineers, and executives get better information faster.

**Point 3: Aggregation design is one of the reasons cube workloads feel responsive.**

What this means in practice: When you apply this at Assmang, it means that aggregation design is one of the reasons cube workloads feel responsive. This is not just a technical exercise — it directly helps managers, engineers, and executives get better information faster.


### 🏭 Assmang scenario

**Situation:** A production manager at Khumani Mine asks: "Can I see this month's iron ore output compared to last month, broken down by shift?"

**How why aggregations matter helps:** Because the cube already has the right structure (dimensions for time and mine, measures for production), this question can be answered in seconds using Excel or Power BI — no SQL coding needed, no waiting for IT.


### ❓ Frequently Asked Questions

**Q: Do I need to be a programmer to understand why aggregations matter?**  
A: No. This concept is about business logic and design thinking. The tools (SSDT) provide visual interfaces for most of the work.

**Q: What happens if we get why aggregations matter wrong?**  
A: The cube will still work technically, but users may get confusing results, slow performance, or missing data. That's why we follow best practices from the start.

**Q: How long does it take to set up why aggregations matter for a real project?**  
A: For a project the size of Assmang's training cube, this typically takes a few hours of design work plus a few hours of implementation and testing.

---

## 📊 Architecture / Concept Diagram

The following diagram shows how this topic fits into the bigger picture:

```mermaid
flowchart LR
    A[FactProduction] --> B[Measure Group: Production]
    A --> C[TonnesProduced SUM]
    A --> D[RevenueZAR SUM]
    A --> E[Grade AVERAGE]
    F[FactOperatingCosts] --> G[Measure Group: Operating Costs]
    B --> H[Processed Cube]
    G --> H
    H --> I[Fast Analysis in Excel, Power BI, and SSMS]
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


## 🧭 Additional Diagrams

### Diagram 1: Measure Group Composition

```mermaid
graph LR
    A[FactProduction] --> B[Production Measure Group]
    C[FactOperatingCosts] --> D[Cost Measure Group]
    B --> E[Cube Measures]
    D --> E
```

### Diagram 2: Aggregation Behavior

```mermaid
flowchart TD
    A[Raw Rows] --> B{Measure Type}
    B -->|Additive| C[SUM]
    B -->|Semi-additive| D[LastNonEmpty/Custom]
    B -->|Non-additive| E[AVG or Formula]
```

### Diagram 3: Query Performance Effect

```mermaid
flowchart LR
    A[User Query] --> B[Check Aggregation Cache]
    B -->|Hit| C[Fast Result]
    B -->|Miss| D[Scan Detail Data]
    D --> E[Slower Result]
```

## 📌 Topic-Specific Summary

This topic is about numerical correctness and speed. If a measure is modeled badly, reports can look polished but still be wrong. If aggregations are weak, reports can be correct but painfully slow.

This is the chapter where learners move from "data is visible" to "data is trustworthy and scalable".

## Deep Dive in Layman Terms

A measure is the number you care about. A measure group is the business context for that number. Aggregations are pre-calculated shortcuts that prevent the system from adding thousands of rows every time someone opens a dashboard.

Simple rule for beginners:

- Totals like tonnes and revenue usually SUM.
- Ratios like grade usually AVG or formula.
- Opening/closing style balances often need special logic, not SUM.

### Assmang-style example

If grade percentage is summed across shifts, you can get impossible values above 100 percent. That is not a user mistake. It is a modeling mistake. Correct aggregation design prevents this.

### Clarity diagram: Correctness before speed

```mermaid
flowchart LR
    A[Define Measure Meaning] --> B[Choose Correct Aggregation Rule]
    B --> C[Validate Business Math]
    C --> D[Add Aggregation Optimizations]
    D --> E[Fast and Reliable Reports]
```
