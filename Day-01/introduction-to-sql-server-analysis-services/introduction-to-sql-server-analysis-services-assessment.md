# Assessment — Introduction to SQL Server Analysis Services
## Day 01 | Assmang Pty Ltd — SSAS Fundamentals

---

## 📋 Assessment Overview

This assessment covers the key concepts from this topic. It includes:

- **Section A:** Multiple-choice questions (knowledge recall)
- **Section B:** Scenario-based question (application and reasoning)
- **Section C:** Practical challenge (hands-on demonstration)

**Passing score:** 70% (combined across all sections)

---

## Section A: Multiple-Choice Questions (1 point each)

**Q1. What is the main purpose of SSAS?**

- A) Store transactional rows
- B) Run analytical models over prepared data
- C) Replace SQL Server Engine
- D) Manage Windows users

**Q2. Which object represents how users slice data?**

- A) Measure
- B) Dimension
- C) Partition
- D) Perspective

**Q3. Which statement best describes processing?**

- A) Formatting reports
- B) Refreshing the cube structure and data
- C) Deleting measures
- D) Renaming dimensions

---

## Section B: Scenario Question (3 points)

**Scenario:**

Assmang executives ask for monthly production by mine, by commodity type, and by province. Explain why a processed SSAS cube is a better delivery layer than repeatedly writing raw SQL over source tables.

**Your answer should include:**

- A clear explanation of the SSAS concept involved
- How it connects to the Assmang business context
- What you would recommend and why
- Any risks or considerations

---

## Section C: Practical Challenge (5 points)

**Task:**

Create an SSAS project, connect it to `AssmangMining`, include the v1 dimensions in a Data Source View, and document your successful deployment validation steps.

**Submission requirements:**

- Screenshot(s) showing your work in SSDT or SSMS
- Brief written explanation of what you did and why
- Evidence that the result is correct (e.g., cube browser output, query result)

---

## 📝 Grading Rubric

| Section | Points | Criteria |
|---------|--------|----------|
| Section A (MCQ) | 3 | Correct answer = 1 point each |
| Section B (Scenario) | 3 | Clear reasoning (1) + Business context (1) + Recommendation (1) |
| Section C (Practical) | 5 | Correct execution (2) + Evidence (2) + Explanation (1) |
| **Total** | **11** | |

---

## ✅ Answer Key

### Section A Answers

- **Q1:** Run analytical models over prepared data
- **Q2:** Dimension
- **Q3:** Refreshing the cube structure and data

### Section B — Scenario Guidance

A strong answer should:

- Discuss business context specific to Assmang mining operations
- Reference SSAS terminology correctly (dimensions, measures, hierarchies, processing, etc.)
- Explain the design decision with clear reasoning
- Acknowledge trade-offs or limitations

### Section C — Practical Challenge Guidance

A strong submission should:

- Show correct SSAS object naming and configuration
- Demonstrate successful processing or querying
- Include evidence that validates correctness
- Be documented clearly enough for a reviewer to follow

---

*Assmang Pty Ltd — SSAS Fundamentals | Day 01 Assessment*
