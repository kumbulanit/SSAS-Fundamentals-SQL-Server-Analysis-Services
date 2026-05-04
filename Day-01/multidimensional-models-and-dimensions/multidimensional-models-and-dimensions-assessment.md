# Assessment — Multidimensional Models and Dimensions
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

**Q1. What is the main purpose of a hierarchy?**

- A) Increase row counts
- B) Support drill-down navigation
- C) Replace measures
- D) Store MDX code

**Q2. Which Assmang dimension naturally owns the hierarchy Year > Quarter > Month > Day?**

- A) Dim_Mine
- B) Dim_Date
- C) Dim_Department
- D) Dim_Employee

**Q3. Which SCD type keeps history?**

- A) Type 0
- B) Type 1
- C) Type 2
- D) Type 4

---

## Section B: Scenario Question (3 points)

**Scenario:**

Assmang wants to compare mines by commodity type first, then by province, then by site. Explain how you would implement that navigation path and why it is better than a flat member list.

**Your answer should include:**

- A clear explanation of the SSAS concept involved
- How it connects to the Assmang business context
- What you would recommend and why
- Any risks or considerations

---

## Section C: Practical Challenge (5 points)

**Task:**

Build `Dim_Mine` and `Dim_Date` in SSDT, process them, and confirm that users can browse both hierarchies successfully.

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

- **Q1:** Support drill-down navigation
- **Q2:** Dim_Date
- **Q3:** Type 2

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
