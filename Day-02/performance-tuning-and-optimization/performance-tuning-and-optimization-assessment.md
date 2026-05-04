# Assessment — Performance Tuning and Optimization
## Day 02 | Assmang Pty Ltd — SSAS Fundamentals

---

## 📋 Assessment Overview

This assessment covers the key concepts from this topic. It includes:

- **Section A:** Multiple-choice questions (knowledge recall)
- **Section B:** Scenario-based question (application and reasoning)
- **Section C:** Practical challenge (hands-on demonstration)

**Passing score:** 70% (combined across all sections)

---

## Section A: Multiple-Choice Questions (1 point each)

**Q1. Which storage mode is usually fastest for query performance?**

- A) MOLAP
- B) ROLAP
- C) CSV
- D) XMLA

**Q2. What is the main purpose of partitioning?**

- A) To rename cubes
- B) To improve manageability and processing scalability
- C) To remove measures
- D) To disable dimensions

**Q3. Why can too many aggregations be a problem?**

- A) They can increase processing cost
- B) They delete data
- C) They break MDX
- D) They prevent deployment

---

## Section B: Scenario Question (3 points)

**Scenario:**

Assmang's monthly executive dashboard is fast, but detailed drill-through into one mining period is slow. Explain at least three areas you would investigate.

**Your answer should include:**

- A clear explanation of the SSAS concept involved
- How it connects to the Assmang business context
- What you would recommend and why
- Any risks or considerations

---

## Section C: Practical Challenge (5 points)

**Task:**

Write a tuning note recommending storage mode, one aggregation improvement, and one partition strategy for the Assmang cube.

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

- **Q1:** MOLAP
- **Q2:** To improve manageability and processing scalability
- **Q3:** They can increase processing cost

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

*Assmang Pty Ltd — SSAS Fundamentals | Day 02 Assessment*
