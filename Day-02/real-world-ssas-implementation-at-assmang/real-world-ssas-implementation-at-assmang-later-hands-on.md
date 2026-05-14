# Later Hands-On Exercises — Real-World SSAS Implementation at Assmang
## Day 02 | Assmang Pty Ltd — SSAS Fundamentals

---

## 🎯 Purpose

These exercises are designed for independent practice after the guided lab. Each exercise is procedural so you can execute it in ordered steps and produce verifiable evidence.

## 📋 Before You Begin

- Ensure the guided lab for Real-World SSAS Implementation at Assmang is complete
- Dataset `v3_assmang_mining_complete.sql` must be loaded
- Your SSAS project should be in a working state
- Allow 30-45 minutes for these exercises

---

## How To Work Through These Exercises

Use this method for each exercise:

1. Translate the objective into a single business question.
2. Identify which SSAS objects you must inspect.
3. Capture one baseline query or browser view before recommendations.
4. Build your answer from evidence, not assumptions.
5. Tie your final recommendation to Assmang operations.

## Evidence Checklist For Each Exercise

Before marking complete, confirm you have:

- The exact object inspected (cube page, KPI, role, process log, or query)
- The resulting output (screenshot, query output, or design artifact)
- A short explanation of why the result supports your answer
- One Assmang business impact statement

## If You Get Stuck

1. Return to the matching guided practical and repeat the nearest step.
2. Validate deployment and processing status before diagnosing logic.
3. Use SQL baseline first, then MDX confirmation.
4. Reduce scope to one mine and one time slice, then expand.

---

## Exercise 1

### Objective

Create a mini solution blueprint for an executive dashboard sourced from the Assmang cube.

### Procedure

**Step 1: Define executive decisions**
- List three daily executive decisions the dashboard must support.
- Example decisions: production variance response, budget overrun response, safety escalation.
- Map each decision to one required metric.

**Step 2: Define dashboard pages**
- Page 1 (Operations): TonnesProduced by Mine and Month, drillable to Department.
- Page 2 (Finance): OperatingCost and CostPerTonne by Mine and Quarter.
- Page 3 (Safety): ComplianceScore KPI by Mine with red/amber/green status.
- Record one business question each page answers.

**Step 3: Define source queries**
- Draft one MDX query per page.
- Ensure each query uses explicit dimensions and slicers.
- Confirm each query can be validated against SQL baseline totals.

**Step 4: Define role-based access**
- Define at least two roles:
  - Executive role: all mines visible
  - Regional role: only assigned mine or region visible
- Record one security test per role.

**Step 5: Define operational targets**
- Query response target: under 2 seconds for executive views.
- Refresh target: daily 06:00 completion.
- Add one failure notification rule for missed refresh.

**Step 6: Produce blueprint summary**
- Write 1-2 paragraphs describing architecture, security, and operating model.
- Include one risk and one mitigation.

### Deliverable

- **Input:** Assmang reporting requirements and cube model
- **Output:** Dashboard blueprint with 3 pages, 3 query definitions, and role matrix
- **Evidence:** Wireframe or layout sketch, query list, and role visibility matrix
- **Assmang Context:** Example: "If Khumani production falls below target and safety KPI turns amber, executives can act in one view instead of waiting for separate reports."

---

## Exercise 2

### Objective

Design a maintenance and support runbook for sustaining the cube in daily operations.

### Procedure

**Step 1: Define daily runbook tasks**
- 06:00 process completion verification.
- Post-process query health check on two key executive queries.
- Distribution of refresh status message to stakeholders.

**Step 2: Define weekly controls**
- Review processing logs for warnings and recurring failures.
- Validate one calculated measure and one KPI against baseline numbers.
- Confirm role-based security still maps correctly to users.

**Step 3: Define monthly controls**
- Perform full reprocess in maintenance window.
- Review partition growth and aggregation effectiveness.
- Audit data reconciliation results (SQL vs cube totals) for key measures.

**Step 4: Define incident response workflow**
- Incident severity levels: critical, major, minor.
- Define response times and ownership for each level.
- Include one fallback action if 06:00 process fails.

**Step 5: Define evidence and sign-off**
- Specify required logs and screenshots per cycle (daily/weekly/monthly).
- Define sign-off owner for each cycle.
- Add one checklist item confirming business communication was sent.

### Deliverable

- **Input:** Operational support requirements for the Assmang cube
- **Output:** Daily/weekly/monthly runbook with owners and SLAs
- **Evidence:** Runbook table, escalation matrix, and validation checklist
- **Assmang Context:** Example: "A missed 06:00 refresh must trigger escalation before 07:00 standup so leaders are not using stale production numbers."

---

## Exercise 3

### Objective

Identify trust risks in cube reporting and design controls that protect decision confidence.

### Procedure

**Step 1: Build risk list**
- List at least six risks (stale data, failed processing, mismatched totals, security leaks, broken calculations, slow queries).
- Assign each risk an impact level (high, medium, low).

**Step 2: Define controls per risk**
- For each risk, define one preventive control and one detective control.
- Example: stale data preventive control = fixed refresh schedule; detective control = refresh timestamp monitor.

**Step 3: Define measurable thresholds**
- Set one threshold per risk (for example, query latency >2 seconds triggers review).
- Tie each threshold to a response owner.

**Step 4: Define communication rules**
- Decide who is notified when each threshold is breached.
- Define message template elements (issue, impact, ETA, workaround).

**Step 5: Produce risk register**
- Create a risk table with columns: Risk, Impact, Control, Threshold, Owner.
- Add one example incident and show how the control framework responds.

### Deliverable

- **Input:** Assmang operational and governance risk considerations
- **Output:** Risk register with controls and thresholds
- **Evidence:** Completed risk table and one worked incident response example
- **Assmang Context:** Example: "If production totals shift after reprocessing, trust erodes quickly; reconciliation control prevents executives from acting on inconsistent numbers."

---

## ✅ Success Criteria

Your exercises are considered successful when:

- Your answer connects technical design to business decision quality.
- You provide concrete evidence for each recommendation.
- Your procedure is reproducible by another BI team member.
- Your risk and operations thinking reflects Assmang's daily reporting reality.

---

## 💡 Stretch Challenge (Optional)

Combine Exercise 1 and Exercise 3 into a single governance one-pager showing dashboard metrics, trust controls, and escalation paths.

---

*Assmang Pty Ltd — SSAS Fundamentals | Day 02 Independent Practice*
