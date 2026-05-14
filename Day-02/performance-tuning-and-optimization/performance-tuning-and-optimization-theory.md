# Performance Tuning and Optimization
## Day 02 | Assmang Pty Ltd — SSAS Fundamentals Training

---

## 🎯 Learning Objectives

By the end of this topic, participants will be able to:

1. Understand how storage mode and aggregation design affect performance.
2. Recognise common causes of slow cube queries.
3. Understand partitioning and caching at a beginner level.
4. Apply practical optimisation decisions in an Assmang reporting context.

---

## 📋 Topic Overview

**Dataset:** `v3_assmang_mining_complete.sql`  
**Difficulty:** Beginner (no prior SSAS experience required)  
**Estimated reading time:** 20-30 minutes

### What this topic covers

A correctly built cube that is configured poorly will frustrate users — slow queries, long processing windows, data that is hours out of date when the shift starts. This topic gives you three levers to control cube performance:

1. **Storage mode** — where SSAS physically stores data (in its own compressed files, in SQL, or a mix)
2. **Aggregations** — pre-calculated summaries that make common queries return in milliseconds instead of seconds
3. **Partitions** — splitting a large measure group into smaller chunks so processing and queries only touch the data they need

### The Assmang performance constraint that drives every decision

Assmang's daily timeline is non-negotiable:

| Time | Event | What it requires |
|------|-------|------------------|
| 06:00 | Nightly processing window opens | Processing must complete in under 45 minutes |
| 07:00 | Shift supervisors open dashboards | Queries must return in under 2 seconds |
| 08:00 | Executive morning briefing | Complex multi-mine comparisons must still be fast |
| All day | Ad-hoc analyst queries | No slowdowns under normal query load |

Every performance decision in this topic is measured against that timeline. A choice that speeds up queries but extends processing past 06:45 is not acceptable for Assmang.

### The three-way trade-off

| Choice | Query speed | Processing speed | Storage |
|--------|------------|-----------------|--------|
| More aggregations | Faster | Slower | More |
| Fewer partitions | Faster for full scans | Slower for targeted refresh | Less |
| MOLAP storage | Fastest | Slowest | Most |

---

## 🧠 Real-World Analogy (Plain English)

**Think of this topic like choosing between a motorbike and a truck for delivery.**

Performance tuning is about choosing the right tool for the job. A motorbike (MOLAP) is fastest for small, frequent deliveries. A truck (ROLAP) carries more but is slower. A van (HOLAP) is a middle ground. You choose based on what your business actually needs — fast dashboards, real-time data, or a balance of both.

> **Key insight for this topic:** Processing speed and query speed pull in opposite directions. More aggregations = faster queries but longer processing. Fewer partitions = simpler management but slower targeted refreshes. Every performance decision is a trade-off — tune for the constraint that matters most to Assmang's 07:00 reporting window.

---

## 1. Storage modes — Choose the right one

**SSAS has three ways to store and retrieve data. Each trades speed vs. freshness:**

### MOLAP (Multidimensional OLAP) — Fastest, used by Assmang

**How it works:**
- Data is read from warehouse and completely copied INTO the cube during processing
- User queries read from the cube's own storage, NOT the warehouse
- Result: Lightning fast queries

**Performance:**
```
Query execution: <1 second
Storage size: ~500 MB for 1 year of Assmang data (all aggregates pre-calculated)
Processing time: 15-30 minutes nightly
Data freshness: Yesterday's data available at 06:30 (when processing completes)
```

**When to use:**
- Assmang situation: YES (nightly processing cycle is acceptable)
- Users need sub-second queries (dashboards refresh fast)
- 24 hours old data is fine (not real-time requirement)
- Budget allows disk storage for aggregates

**Real Assmang example:**
```
06:00 - MOLAP processes: reads all 50,000 rows of day's production data
06:15 - MOLAP finishes: all aggregates pre-calculated (Q1 total, mine totals, etc.)
06:30 - Manager asks: "Khumani Q1 tonnes?" → Answer: <1ms (already calculated)
Vs. SQL query: Would need to scan 50k rows, calculate sum, return answer = 2-3 seconds
```

**Formula for MOLAP speed advantage:**
```
MOLAP Speed Ratio = SQL_Scan_Time / MOLAP_Query_Time
                  = 2000ms / 10ms = 200x faster
```

### ROLAP (Relational OLAP) — Slowest, but real-time

**How it works:**
- Cube queries translate to SQL queries against the warehouse
- No pre-calculated aggregates stored
- Data is always fresh (as fresh as the warehouse)

**Performance:**
```
Query execution: 2-5 seconds (each query is a SQL aggregation)
Storage size: Minimal (only metadata, no aggregates)
Processing time: Seconds (just updates metadata, not data copy)
Data freshness: Real-time (queries warehouse whenever asked)
```

**When to use:**
- Real-time requirement (can't wait for nightly processing)
- Storage is expensive or limited
- Warehouse is small (<100 GB)
- Query patterns are unpredictable (can't pre-aggregate efficiently)

**Assmang would use ROLAP if:**
- Board wanted real-time production updates (every 1 hour)
- Warehouse was too large to copy daily
- Cost constraints prevented processing server from running nightly

**Real example:**
```
Dashboard asks: "Khumani Q1 tonnes?"
ROLAP workflow:
  → Translates to SQL: SELECT SUM(TonnesProduced) FROM FactProduction 
                       WHERE MineKey=2 AND QUARTER=Q1
  → Scans warehouse 50k rows
  → Returns answer: 42,150 tonnes (takes 3-5 seconds)
```

### HOLAP (Hybrid OLAP) — Middle ground

**How it works:**
- Details (lowest level data) stored in warehouse (ROLAP)
- Aggregates pre-calculated in cube (MOLAP)
- Queries at aggregate level are fast; detailed queries are slower

**Performance:**
```
Query for "Khumani Q1 tonnes":  <1 second (aggregate, pre-calculated)
Query for "Khumani day-by-day":  2-3 seconds (details, queried from warehouse)
```

**When to use:**
- Need some speed and some freshness
- Large detailed dataset (can't afford to store all in cube)
- Some queries are aggregate-level (fast) and some detail-level (slower)

---

### Assmang's choice: **MOLAP**

| Aspect | Why MOLAP is right |
|--------|-------------------|
| **Data size** | ~50k fact rows per day, manageable to pre-calculate |
| **Processing window** | Nightly at 06:00, 15-30 min processing is acceptable |
| **User expectations** | Dashboards refresh hourly, <1 sec response is critical |
| **Query patterns** | Predictable (by mine, by month, by department) — aggregates reduce work |
| **Storage** | Server has sufficient disk space for aggregates |
| **Age tolerance** | Users accept "yesterday's data" (not real-time required) |

---

## 2. Aggregation design — Pre-calculate the queries users ask

An **aggregation** is a pre-calculated total stored in the cube so queries don't have to recalculate it.

### Aggregation formula (how many to design):

```
Useful_Aggregation_Count = (Common Query Patterns) × (Coverage Factor)

Assmang_Example:
  Common Patterns = [All Measures by Mine], [All Measures by Month], [All Measures by Mine+Month]
  Coverage Factor = 80% of user queries should hit pre-aggregated data
  Target = Design ~20-30 aggregations for full coverage
```

### Real aggregation examples for Assmang:

**Aggregation 1: By Mine (for "show each mine's total")**
```
Dimension levels:
  Mine: [All Mines]  ← Group by mine
  Date: [All Time]   ← All dates (no drill-down)
  Department: [All]  ← All departments

Pre-calculated: SUM(TonnesProduced) by mine across all time
Saves: Re-scanning 50k rows for each mine query

User benefit: "Khumani Q1 tonnes?" → Pre-aggregated, <1ms response
```

**Aggregation 2: By Month (for trend analysis)**
```
Dimension levels:
  Mine: [All Mines]        ← All mines combined
  Date: [Month]            ← Monthly totals (Jan, Feb, Mar, etc.)
  Department: [All]        ← All departments

Pre-calculated: SUM(TonnesProduced) by month across all mines
Saves: Daily drill-downs no longer need to sum individual days

User benefit: "January tonnes?" → Pre-aggregated, <1ms instead of <100ms
```

**Aggregation 3: By Mine + Month (for detailed analysis)**
```
Dimension levels:
  Mine: [Mine Name]        ← Individual mines (Khumani, Beeshoek, etc.)
  Date: [Month]            ← Monthly breakdown
  Department: [All]        ← All departments

Pre-calculated: SUM(TonnesProduced) by mine by month
Saves: Highest granularity of common queries (detailed reporting)

User benefit: "January Khumani tonnes?" → Pre-aggregated, <1ms
```

### Aggregation coverage formula:

```
Aggregation_Coverage = (Queries hitting pre-calc aggregates / Total queries) × 100%

Assmang Target: 80% coverage (80% of queries use pre-aggregated data)
  → If 100 user queries: 80 run in <10ms (hit aggregates)
  → If 100 user queries: 20 run in <500ms (hit lower granularity, calculate)

Without aggregations: All 100 queries would need 100-500ms (hit warehouse)
With aggregations: 80 in <10ms + 20 in <500ms = massive improvement
```

### How to design aggregations in SSDT (step-by-step):

**Step 1:** Open Cube Designer, click **Aggregations** tab (under Partitions)

**Step 2:** Right-click → **Aggregation Design Wizard**

**Step 3:** Select measure groups (production, operating costs)

**Step 4:** Select which dimension levels to aggregate:
- ☑ Mine → Dimension Members (Khumani, Beeshoek, etc.)
- ☑ Date → Month (don't need daily — costs too much storage)
- ☑ Department → Department Members

**Step 5:** Wizard estimates:
```
Estimated aggregation count: 32
Estimated storage: ~250 MB
Estimated coverage: 85%
Processing increase: +5 minutes
```

**Step 6:** Click **OK** to create aggregations

**Step 7:** Rebuild and reprocess — aggregations now calculated nightly

**Step 8:** Performance improves immediately — dashboard queries now <1ms

---

## 3. Partitioning — Split large cubes for faster processing

**Partitioning** means dividing a fact table into smaller chunks (by date range) so processing is faster.

### Why partition (Assmang example):

Without partitioning:
```
Every night MUST reprocess ALL 365 days of data (50k rows × 365 = 18M rows)
Processing time: 30 minutes
```

With partitioning (by month):
```
Every night ONLY process the NEW month's data (50k new rows)
Reprocessing only this month: 2 minutes
Previous 11 months: Already processed, unchanged
Total processing time: 2 minutes vs. 30 minutes
```

### Partitioning formula:

```
Processing_Time_Savings = (Reprocess_All_Rows_Time - Reprocess_New_Rows_Time) / Reprocess_All_Rows_Time × 100%

Assmang_Benefit = (30 min - 2 min) / 30 min × 100% = 93% faster
```

### Partition design for Assmang:

```
Partition 1: Jan-2024 (50,000 rows) — Processed once in February, never changes
Partition 2: Feb-2024 (50,000 rows) — Processed once in March, never changes
...
Partition 12: Dec-2024 (50,000 rows) — Processed monthly as data is added
Partition 13: 2025 (growing) — Processed incrementally as new data arrives
```

**Benefit:** Processing 2025 data only takes 2 minutes, not 30 (because 2024 is already done)

---

## 4. Query optimization checklist — Make dashboards fast

**Before going live, verify these 5 items:**

**✓ 1: Aggregation coverage ≥ 80%**
- Run Aggregation Design Wizard
- Check coverage: Should be 80%+ (meaning 80% of queries use pre-calc data)
- If <80%: Add more aggregations

**✓ 2: Storage mode is MOLAP**
- Right-click measure group → Properties → Storage Settings
- Storage Mode: Should be "MOLAP"
- If ROLAP: Change to MOLAP and reprocess

**✓ 3: Processing completes in <30 minutes**
- Run nightly processing
- Monitor Duration in SSMS
- If >30 min: Add partitions to split the load

**✓ 4: Query response <1 second for dashboards**
- Open Browser tab in Cube Designer
- Drag a few measures by a few dimensions
- Observe response time
- Expected: <1 second (indicates aggregates are being used)
- If >1 second: Missing aggregations or ROLAP mode

**✓ 5: No dimension growth performance degradation**
- If Mine dimension added new member (new mine opens), does cube still respond fast?
- Should be yes (adding a member doesn't affect query speed if aggregations exist)

---

## Performance tuning real example (Assmang dashboard)

### Baseline (slow):
```
Dashboard loads → Excel asks "All mines by month for 2024"
→ MOLAP query executes
→ Checks for aggregation: Mine × Month × None (no aggregation pre-built)
→ Falls back to lower aggregation: Mine × All Time
→ Manually slices by month (calculation needed)
→ Returns in 500ms (too slow for dashboard refresh)
```

### After tuning (fast):
```
Dashboard loads → Excel asks "All mines by month for 2024"
→ MOLAP query executes
→ Checks for aggregation: Mine × Month × All Departments (FOUND!)
→ Retrieves pre-calculated aggregate
→ Returns in 5ms (perfect for dashboard)
Improvement: 100x faster
```

**Lesson:** Pre-calculated aggregations are everything. Without them, cubes are slow. With them, cubes are instant.

---

## 3. Partitioning and scalability

A partition is a physical subdivision of a measure group's data. SSAS processes partitions independently, which becomes very valuable for large datasets like Assmang's multi-year production history.

### Why partitions matter

Without partitions, processing Assmang's 3-year production history every night means re-loading ALL data: 2022, 2023, and 2024. With year-based partitions:
- Processing only the **2024 partition** takes about one-third the time
- The **2022 and 2023 partitions** stay untouched and available to users during the nightly refresh

### Practical partitioning plan for Assmang

| Partition name | Data slice | Process frequency | Typical time |
|---------------|-----------|-------------------|--------------|
| FactProduction_2022 | Date year = 2022 | Monthly (rarely changes) | ~15 min |
| FactProduction_2023 | Date year = 2023 | Weekly | ~20 min |
| FactProduction_2024 | Date year = 2024 | Nightly | ~8 min |

**Result:** Nightly processing window drops from 43+ minutes to ~8 minutes.

### How to create a partition in SSDT

1. In the cube designer, click the **Measure Groups** area and find the measure group you want to partition
2. Right-click the measure group → **Partitions**
3. Click **New Partition**
4. In the Source binding, set the **Slice** property to restrict which data this partition holds — e.g. `[Date].[Calendar Year].&[2024]`
5. Name the partition clearly: `FactProduction_2024`
6. To process only one partition: right-click it → **Process Partition** → **Process Full**

> ⚠️ **The Slice property is critical:** SSAS uses Slice to skip partitions that cannot contain the answer to a query. If Slice is missing or wrong, SSAS scans ALL partitions — your processing wins, but your query speed gains disappear entirely.

---

## 4. Caching and practical tuning steps

SSAS has a built-in memory cache that stores recent query results automatically. You do not configure the cache manually — but you can take actions that improve how effectively it works.

### The four practical tuning steps for beginners

**Step 1: Run the Aggregation Design Wizard after your first full process**

After processing the cube for the first time, go to: SSDT → Cube designer → **Aggregations** tab → **Design Aggregations**. Start with **30% storage** as the recommended setting. This covers most common query patterns without wasting excessive disk space.

**Step 2: Keep calculations simple**

Calculated measures that use `NonEmpty`, large `CrossJoin` sets, or nested IIF expressions slow down every query that involves them. Where possible, pre-aggregate in the SQL Server ETL layer rather than in MDX calculations.

**Step 3: Use a benchmark query to measure before and after**

Before and after any change, run this baseline query in SSMS to compare timing:

```sql
-- In SSMS connected to Analysis Services
SELECT
    { [Measures].[Tonnes Produced], [Measures].[Cost Per Tonne] } ON COLUMNS,
    [Mine].[Mine Name].Members ON ROWS
FROM [Assmang Mining Analytics]
WHERE ([Date].[Calendar].[Calendar Year].&[2024])
```

A well-tuned Assmang cube should return this query in under 1 second. Record the time before and after each tuning action.

**Step 4: Pre-warm the cache before peak hours (optional)**

For scheduled dashboards that run at 08:00, consider running the above benchmark query at 07:55. This pre-loads the most common aggregations into memory before users connect.

> ℹ️ **Normal behaviour:** The first query after processing is always slower (cold cache). Subsequent identical or similar queries are much faster (warm cache). This is expected — it is not a bug.

---

## 📊 Architecture / Concept Diagram

The following diagram shows how this topic fits into the bigger picture:

```mermaid
flowchart LR
    A[Incoming Query Pattern] --> B{Aggregation Match}
    B -->|Yes| C[Precalculated Aggregate Hit]
    C --> D[Fast Response]
    B -->|No| E[Detail-Level Scan]
    E --> F[Slower Response]
    D --> G[Monitoring and Tuning Feedback]
    F --> G
```

### How to read this diagram

- **Left side:** Where your raw data lives (SQL Server database tables containing production, cost, safety, and employee data).
- **Middle:** Where SSAS transforms that raw data into an analytical structure (the cube with its dimensions, hierarchies, and measures).
- **Right side:** Where business users access the results (Excel pivot tables, Power BI dashboards, or MDX query results in SSMS).

### Why this matters

Without performance tuning, a cube that works fine in development can become unacceptably slow in production. A morning executive dashboard that takes 2 minutes to load instead of 2 seconds erodes trust in the analytics platform. Users stop relying on it and revert to manual Excel files — defeating the purpose of building the cube.

---

## 🧭 Additional Diagrams

### Diagram 1: Performance Levers

```mermaid
graph LR
    A[Storage Mode] --> D[Query Performance]
    B[Aggregations] --> D
    C[Partitions] --> D
    E[Cache Strategy] --> D
```

### Diagram 2: Partitioning Strategy

```mermaid
flowchart TD
    A[FactProduction] --> B[Partition by Year]
    B --> C[2023]
    B --> D[2024]
    B --> E[2025]
```

### Diagram 3: Tuning Workflow

```mermaid
flowchart LR
    A[Capture baseline query times] --> B[Apply one optimization]
    B --> C[Reprocess affected objects]
    C --> D[Rerun benchmark queries]
    D --> E[Keep or rollback change]
```

## 📌 Topic-Specific Summary

This topic focuses on measurable optimisation. Effective tuning requires baseline evidence, isolated changes, and before/after benchmarking to avoid introducing performance regressions.

The practical mindset here is scientific: measure first, change one thing, measure again. Never tune by guessing.

## Deep Dive in Layman Terms

Performance is not one switch. It is the combined result of storage choices, aggregations, partitions, and cache behavior.

For beginners, the safe order is:

1. Identify slow queries.
2. Confirm whether slowness is from detail scans or model design.
3. Apply one optimization at a time.
4. Re-test with the same query set.

### Assmang-style example

If monthly executive dashboards are slow every Monday morning, warm-up strategy and aggregation design can reduce queue time significantly without changing report layout.

### Clarity diagram: Safe tuning loop

```mermaid
flowchart TD
    A[Capture Baseline] --> B[Apply One Change]
    B --> C[Reprocess]
    C --> D[Retest Same Workload]
    D --> E{Improved?}
    E -->|Yes| F[Keep Change]
    E -->|No| G[Rollback and Try Next]
```
