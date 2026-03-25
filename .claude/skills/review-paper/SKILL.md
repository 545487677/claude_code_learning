---
name: review-paper
description: Comprehensive academic paper review workflow for all research domains. Use this skill whenever the user wants to review, analyze, or critically evaluate any academic paper, research article, or scientific publication. Trigger this when the user mentions "review this paper", "analyze this research", "evaluate this article", "what do you think of this paper", "critique this study", or references a paper file (.pdf, .md) and asks for analysis. Also use when the user wants peer review feedback, research evaluation, or academic assessment of any scientific work across ML/AI, materials science, biology, chemistry, physics, computer science, or any other academic field.
---

# Academic Paper Review Workflow

This skill orchestrates a comprehensive, systematic review of academic papers across all research domains. It follows a structured six-stage workflow that progressively deepens understanding, validates reasoning, identifies boundaries, and synthesizes critical insights into a formal peer review.

## Workflow Overview

The review process consists of six stages, each building on the previous:

1. **Paper Analysis** - Systematic deconstruction of the paper's structure, methodology, and claims
2. **Deep Research** - Contextual investigation of related work, concepts, and field developments
3. **Reasoning Validation** - Logical verification of the paper's argument chains
4. **Boundary Detection** - Identification of research limits, gaps, and unexplored areas
5. **Critical Thinking** - Deep analysis of contributions, problems, and improvements
6. **Reflection** - Synthesis of findings and insights

Each stage produces an intermediate output file for transparency and traceability.

## Output Structure

All outputs are saved to: `paper-review-<paper-name>/`

**Intermediate outputs:**
- `01-paper-analysis.md` - Structural analysis and methodology assessment
- `02-deep-research.md` - Literature context and technical investigation
- `03-reasoning-validation.md` - Logical chain verification
- `04-boundary-detection.md` - Research boundaries and limitations
- `05-critical-thinking.md` - Deep critical analysis
- `06-reflection.md` - Session insights and learnings

**Final output:**
- `PEER_REVIEW.md` - Formal academic peer review with recommendation

## Instructions

### Stage 0: Setup and Preparation

Before starting the review workflow:

1. **Identify the paper** - Get the paper file path from the user or current context
2. **Extract paper metadata** - Determine:
   - Paper title
   - Authors
   - Field/domain
   - Publication venue (if available)
   - Key claims or contributions mentioned in abstract

3. **Create output directory**:
   ```bash
   mkdir -p "paper-review-<sanitized-paper-title>"
   cd "paper-review-<sanitized-paper-title>"
   ```

4. **Inform the user**:
   ```
   Starting comprehensive review of: [Paper Title]
   Output directory: paper-review-<title>/

   This review will proceed through 6 stages:
   ✓ Stage 1: Paper Analysis
   ✓ Stage 2: Deep Research
   ✓ Stage 3: Reasoning Validation
   ✓ Stage 4: Boundary Detection
   ✓ Stage 5: Critical Thinking
   ✓ Stage 6: Reflection

   Each stage will produce an intermediate output file.
   Final peer review will be saved to: PEER_REVIEW.md

   Estimated time: 15-25 minutes
   ```

### Stage 1: Paper Analysis

Use the `/paper-analysis` skill to systematically deconstruct the paper.

**Execution:**
```
/paper-analysis
```

**Focus areas:**
- Problem definition and research questions
- Methodology and experimental design
- Core contributions and novelty claims
- Results and their interpretation
- Conclusion validity

**Save output:**
Write the analysis results to `01-paper-analysis.md` with sections:
- **Paper Overview** - Title, authors, venue, domain
- **Problem Statement** - What problem does this solve?
- **Methodology** - How do they approach it?
- **Key Contributions** - What's new or novel?
- **Experimental Design** - How is it validated?
- **Results Summary** - What did they find?
- **Initial Assessment** - First impressions of quality and rigor

### Stage 2: Deep Research

Use the `/deep-research` skill to investigate the paper's context and technical foundations.

**Research dimensions:**

1. **Related work verification** - Check if cited papers support the claims made
2. **Technical concept investigation** - Deep dive into key methods/algorithms mentioned
3. **Field context** - Understanding current state-of-the-art and recent developments
4. **Competitive analysis** - How does this compare to similar approaches?

**Execution:**

For each research dimension, invoke `/deep-research` with specific queries:

```
/deep-research "<key concept from paper> state of the art and recent advances"
/deep-research "<methodology used> compared to alternative approaches"
/deep-research "limitations and challenges of <technique> in <domain>"
```

Aim for 2-4 focused research queries based on the paper's complexity.

**Save output:**
Consolidate research findings into `02-deep-research.md` with sections:
- **Literature Context** - Where does this fit in the field?
- **Technical Foundations** - Are the methods well-established or novel?
- **Competitive Landscape** - How does it compare to alternatives?
- **Field Developments** - What's the current state of research in this area?
- **Citation Accuracy** - Do cited works actually support the claims?

### Stage 3: Reasoning Validation

Use the `/reasoning:reasoning-chain-validate` skill to verify logical coherence.

**Execution:**
```
/reasoning:reasoning-chain-validate
```

**Focus on:**
- Does the problem statement logically lead to the proposed solution?
- Are experimental results sufficient to support the conclusions?
- Do the claims follow from the evidence presented?
- Are there logical gaps or leaps in the argumentation?
- Is the causal reasoning sound?

**Also consider using:**
```
/reasoning:reasoning-multi-path
```
To explore alternative interpretations or explanations.

**Save output:**
Write validation results to `03-reasoning-validation.md` with sections:
- **Argument Structure** - Map the logical flow from problem → method → results → conclusions
- **Reasoning Quality** - Assessment of logical soundness
- **Gaps Identified** - Where does the reasoning break down?
- **Alternative Paths** - Could the evidence support different conclusions?
- **Validation Verdict** - Is the reasoning chain valid?

### Stage 4: Boundary Detection

Use the `/boundary:boundary-detect` skill to identify research limits and unexplored areas.

**Execution:**
```
/boundary:boundary-detect
```

**Also use:**
```
/boundary:boundary-risk-assess
```

**Focus on:**
- What did the paper investigate vs. what did it leave unexplored?
- What are the scope limitations (domain, data, methodology)?
- Where might the approach fail or not apply?
- What assumptions constrain the findings?
- Are there unstated limitations?

**Save output:**
Write boundary analysis to `04-boundary-detection.md` with sections:
- **Research Boundaries** - What's in scope vs. out of scope?
- **Methodological Limits** - Where does the approach stop working?
- **Unstated Assumptions** - What's assumed but not discussed?
- **Generalizability** - How broadly do findings apply?
- **Risk Assessment** - What could go wrong if applied elsewhere?
- **Unexplored Territories** - What should have been investigated?

### Stage 5: Critical Thinking

Use the `/dev:ultra-think` skill for deep critical analysis.

**Execution:**
```
/dev:ultra-think
```

**Also consider:**
```
/brainstorming
```
For generating improvement ideas or alternative approaches.

**Focus on:**
- What are the true contributions vs. incremental improvements?
- What are the significant problems or weaknesses?
- Is the experimental validation sufficient?
- Are there methodological flaws?
- What would make this work stronger?
- What are the implications for the field?

**Save output:**
Write critical analysis to `05-critical-thinking.md` with sections:
- **Strengths** - What does the paper do exceptionally well?
- **Weaknesses** - What are the significant problems?
- **Novelty Assessment** - How original is this work?
- **Methodological Critique** - Are the methods appropriate and rigorous?
- **Experimental Sufficiency** - Is the validation convincing?
- **Improvement Suggestions** - What would make this better?
- **Field Impact** - What's the potential influence on the research community?

### Stage 6: Reflection

Use the `/reflection` skill to synthesize insights.

**Execution:**
```
/reflection
```

**Focus on:**
- Key patterns observed across all stages
- Most important insights gained
- Evolution of understanding throughout the review
- Meta-observations about the review process

**Save output:**
Write reflection to `06-reflection.md` with sections:
- **Review Journey** - How did understanding evolve?
- **Key Insights** - Most important discoveries
- **Patterns Identified** - Recurring themes across stages
- **Lessons Learned** - What did this review teach us?

### Stage 7: Synthesize Peer Review

Based on all intermediate outputs (stages 1-6), create a formal academic peer review.

**Structure:**

```markdown
# Peer Review: [Paper Title]

**Reviewer**: Claude (AI Assistant)
**Date**: [Current Date]
**Review Type**: Comprehensive Academic Assessment

---

## Summary

[2-3 paragraph summary of the paper's main contributions, approach, and findings]

---

## Strengths

1. [Strength 1 with explanation]
2. [Strength 2 with explanation]
3. [Strength 3 with explanation]
...

---

## Weaknesses

1. [Weakness 1 with explanation and suggested improvement]
2. [Weakness 2 with explanation and suggested improvement]
3. [Weakness 3 with explanation and suggested improvement]
...

---

## Detailed Comments

### Originality and Significance
[Assessment of novelty and contribution to the field]

### Methodology and Rigor
[Evaluation of experimental design and technical soundness]

### Clarity and Presentation
[Assessment of writing quality and organization]

### Related Work and Context
[Evaluation of literature coverage and positioning]

### Reproducibility
[Assessment of whether the work can be reproduced]

### Limitations and Future Work
[Discussion of boundaries and unexplored directions]

---

## Questions for Authors

1. [Question 1]
2. [Question 2]
3. [Question 3]
...

---

## Minor Issues

- [Typo or minor issue 1]
- [Minor issue 2]
...

---

## Recommendation

**Decision**: [Accept / Minor Revision / Major Revision / Reject]

**Confidence**: [High / Medium / Low]

**Justification**:
[2-3 paragraphs explaining the recommendation, balancing strengths and weaknesses]

---

## Additional Notes

[Any other observations, suggestions for related work, or contextual comments]

---

## Review Quality Metrics

- **Depth of Analysis**: [Score 1-5 with brief justification]
- **Contextual Understanding**: [Score 1-5 with brief justification]
- **Critical Rigor**: [Score 1-5 with brief justification]
- **Constructiveness**: [Score 1-5 with brief justification]

---

*This review was generated through a systematic 6-stage analysis workflow combining automated analysis tools with critical reasoning validation.*
```

**Save output:**
Write the peer review to `PEER_REVIEW.md`

### Stage 8: Final Communication

Inform the user that the review is complete:

```
✅ Comprehensive paper review completed!

📁 All outputs saved to: paper-review-<title>/

📄 Review stages:
  ✓ 01-paper-analysis.md
  ✓ 02-deep-research.md
  ✓ 03-reasoning-validation.md
  ✓ 04-boundary-detection.md
  ✓ 05-critical-thinking.md
  ✓ 06-reflection.md

📋 Final peer review: PEER_REVIEW.md

**Recommendation**: [Accept/Minor Revision/Major Revision/Reject]
**Key Strengths**: [1-2 sentence summary]
**Key Weaknesses**: [1-2 sentence summary]

Would you like me to elaborate on any specific aspect of the review?
```

## Important Notes

### Handling Large Papers

If the paper file is too large to read in one operation:
- Read abstract, introduction, and conclusion first
- Then read methodology and results sections
- Use grep/search to locate specific sections when needed
- For papers over 50 pages, consider reading section-by-section

### Adapting to Different Domains

The workflow is domain-agnostic, but you should:
- Use domain-appropriate terminology
- Understand field-specific standards (e.g., p-values in biology, ablation studies in ML)
- Recognize what's novel in that specific field
- Apply appropriate evaluation criteria (theory vs. empirical work)

### When Skills Aren't Available

If any skill in the workflow isn't available:
- Perform that analysis manually using available tools
- Maintain the same depth and rigor
- Save output to the corresponding intermediate file
- Don't skip stages—each builds on the previous

### Time Management

- Each stage takes roughly 2-4 minutes
- Deep research may take longer (5-8 minutes) depending on complexity
- Total workflow: 15-25 minutes for most papers
- Keep the user informed of progress after each stage

### Quality Standards

This workflow aims to produce peer-review-quality analysis. Ensure:
- **Thoroughness**: Don't rush—each stage should be comprehensive
- **Objectivity**: Balance praise and criticism fairly
- **Constructiveness**: Suggest improvements, not just problems
- **Accuracy**: Verify claims before criticizing
- **Clarity**: Write reviews that are clear and actionable

## Example Usage

**User says:** "Review the paper I have open" or "Analyze this research paper"

**You respond:**
1. Identify the paper file
2. Create output directory
3. Execute stages 1-7 sequentially
4. Synthesize final peer review
5. Report completion with summary

**User says:** "Review Closed-Loop Machine Learning in Materials Discovery.md"

**You respond:**
1. Create `paper-review-closed-loop-ml-materials/`
2. Execute full workflow
3. Produce comprehensive peer review in `PEER_REVIEW.md`
