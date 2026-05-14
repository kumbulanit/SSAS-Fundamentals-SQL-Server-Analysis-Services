# Later Hands-On Exercises — Performance Tuning and Optimization
## Day 02 | Assmang Pty Ltd — SSAS Fundamentals

---

## 🎯 Purpose

These exercises are designed for independent practice after the guided lab. Each exercise is written as a procedural sequence so you can execute it step by step.

## 📋 Before You Begin

- Ensure the guided lab for Performance Tuning and Optimization is complete
- Dataset `v3_assmang_mining_complete.sql` must be loaded
- Your SSAS project should be in a working state
- Allow 30-45 minutes for these exercises

---

## How To Work Through These Exercises

Use this repeatable method for every exercise:

1. Convert the objective into one concrete business question.
2. Confirm the required cube objects exist before analyzing results.
3. Start with one small validation query or browser slice.
4. Expand gradually and capture evidence as you go.
5. Write the final recommendation using both technical evidence and business context.

## Evidence Checklist For Each Exercise

Before you mark an exercise complete, confirm you have all of these:

- The specific object inspected (measure group, partition, aggregation, or query)
- The output observed (browser grid, query result, or timing data)
- A short explanation of what the output proves
- At least one Assmang-specific business interpretation

## If You Get Stuck

Use this sequence:

1. Re-run the closest guided practical step.
2. Check cube deployment and processing freshness.
3. Validate source numbers in SQL first, then in MDX.
4. Reduce scope to one mine and one date range, then expand.

---

## Exercise 1

### Objective

Recommend the best storage mode for Assmang's near-real-time production reporting workload.

### Procedure

**Step 1: Define the workload profile**
- Write down expected user pattern: frequent dashboard queries from 07:00 onward.
- Note refresh expectation: daily 06:00 processing with minimal query latency.
- Document SLA target: less than 2 seconds for core executive queries.

**Step 2: Compare storage modes**
- Create a quick comparison table for MOLAP, ROLAP, and HOLAP.
- For each mode, capture query speed, processing time, and data freshness trade-offs.
- Mark risks for Assmang (for example, slow queries for ROLAP or stale data for MOLAP).

**Step 3: Validate against one business query**
- Use this sample query shape: TonnesProduced by Mine and Quarter for 2024.
- State expected behavior for each mode under this query.
- Identify which mode best balances speed and freshness for this use case.

**Step 4: Recommend implementation approach**
- Choose one mode as primary recommendation.
- Add one fallback option if Assmang priorities shift (speed first vs freshness first).
- Include one operational caveat (for example, processing window dependency).

**Step 5: Document decision**
- Write 1-2 paragraphs with final recommendation and rationale.
- Reference at least two concrete constraints from the Assmang environment.

### Deliverable

- **Input:** Assmang reporting SLA and refresh requirement
- **Output:** Storage mode recommendation note + comparison table
- **Evidence:** Mode comparison table and sample query impact analysis
- **Assmang Context:** Example: "HOLAP balances speed and freshness for supervisor dashboards because dimensions remain cached while large fact tables can remain relational for frequent updates."

---

## Exercise 2

### Objective

Design a year-based partition strategy for FactProduction that improves processing speed and query performance.

### Procedure

**Step 1: Establish current baseline**
- Record current full-process duration for FactProduction.
- Identify current data range (for example 2020-2024).
- Note peak query windows and which years are queried most often.

**Step 2: Define partition layout**
- Propose one partition per year (2020, 2021, 2022, 2023, 2024).
- Label current-year partition as hot data and older years as warm/cold.
- Document expected partition sizes and growth pattern.

**Step 3: Map processing strategy**
- Current year: incremental processing daily.
- Previous year: periodic processing only when corrections arrive.
- Historical years: rare reprocessing unless data correction is approved.

**Step 4: Map query performance impact**
- Explain partition elimination for year-filtered queries.
- Show why queries scoped to 2024 avoid scanning older partitions.
- Estimate expected speed improvement for common manager queries.

**Step 5: Document operational controls**
- Add a monthly partition health review step.
- Add a rollback plan if partition processing fails.
- Define one threshold for when a partition should be split further.

### Deliverable

- **Input:** FactProduction date range and processing baseline
- **Output:** Partition design plan (yearly layout + processing rules)
- **Evidence:** Partition map, estimated performance impact, and failure fallback plan
- **Assmang Context:** Example: "Daily production reports mainly query current-year data, so year partitioning reduces scan volume and keeps 06:00 processing within the operational window."

---

## Exercise 3

### Objective

Design targeted aggregations based on real Assmang reporting patterns and justify the performance trade-offs.

### Procedure

**Step 1: Capture top reporting patterns**
- List three common reporting requests:
  - Supervisor: Tonnes by Mine and Day
  - Production manager: Tonnes by Mine, Department, Month
  - CFO: Cost and production by Mine and Quarter
- Mark which queries are most latency-sensitive.

**Step 2: Propose aggregation candidates**
- For each pattern, define one aggregation grain.
- Example: Mine + Quarter for executive summaries.
- Keep aggregation count realistic to avoid unnecessary storage growth.

**Step 3: Estimate benefit vs cost**
- For each aggregation, estimate query speed gain and storage overhead.
- Rank candidates by impact (high, medium, low).
- Reject any aggregation with low business value and high storage cost.

**Step 4: Define deployment priority**
- Phase 1: Implement high-impact aggregations only.
- Phase 2: Add medium-impact aggregations after usage review.
- Add a review checkpoint after two weeks of query logs.

**Step 5: Document recommendation**
- Write 1-2 paragraphs with selected aggregation set.
- Include one risk and one mitigation for aggregation maintenance.

### Deliverable

- **Input:** Assmang reporting patterns and performance targets
- **Output:** Aggregation proposal (pattern-to-aggregation mapping)
- **Evidence:** Impact ranking table and phased rollout plan
- **Assmang Context:** Example: "Mine+Quarter aggregation accelerates executive trend queries and supports daily standup decisions without overloading storage."

---

## ✅ Success Criteria

Your exercises are considered successful when:

- Your answer reflects business purpose, not only technical concepts.
- You can justify why the design fits Assmang reporting usage.
- You provide evidence that links configuration choices to expected outcomes.
- Your documentation is clear enough for another BI developer to execute.

---

## 💡 Stretch Challenge (Optional)

Extend one exercise by combining partitioning and aggregation strategy into one release plan with timing, ownership, and validation checks.

---

*Assmang Pty Ltd — SSAS Fundamentals | Day 02 Independent Practice*
