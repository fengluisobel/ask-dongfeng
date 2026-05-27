---
name: ask-dongfeng
description: "Use when a user wants to turn an ambiguous goal, product idea, workflow, project, or personal system into an engineering-cybernetics control loop with sensors, comparators, controllers, feedback cadence, human review gates, and actionable artifacts."
license: MIT
metadata:
  hermes:
    tags: [control, cybernetics, planning, spec, feedback, review, workflow, systems-thinking]
    related_skills: [plan, writing-plans, spike, requesting-code-review]
---

# Ask DongFeng

## Overview

Ask DongFeng is a workflow skill for making agent work controllable. It adapts engineering-cybernetics ideas into a practical loop:

```text
controlled object -> sensors -> comparators -> controllers -> execution -> feedback
```

The goal is not to produce a prettier plan. The goal is to make the agent's work observable, reviewable, correctable, and stable under disturbance.

## When to Use

Use this skill when the user asks to:

- turn a vague idea into an executable system or workflow
- design a spec that includes feedback and correction, not just requirements
- prevent an agent from jumping directly into code or implementation
- define review gates, thresholds, signals, or acceptance criteria
- build a reusable operating loop for product, engineering, finance, learning, operations, or personal systems
- create something "like spec", "like superpower", or "framework-style" but centered on feedback control

Do not use this skill for:

- one-off factual answers
- tiny implementation tasks with obvious acceptance criteria
- pure brainstorming where no execution or feedback loop is needed
- high-risk domains where the user expects automated financial, legal, medical, or safety-critical execution

## Load References As Needed

- Read `references/control-framework.md` when the task needs deeper control-loop reasoning or the user asks "why this structure".
- Read `references/artifact-schema.md` when producing a machine-readable artifact or validating completeness.
- Read `references/review-questions.md` when preparing peer review, teammate critique, or human approval gates.
- Read `references/examples.md` when the user asks for examples or the domain is unclear.
- Use `scripts/validate_artifact.py` when a generated artifact is saved to a file and needs deterministic completeness checks.

## Core Workflow

### 1. Define the System Boundary

Before planning or coding, identify:

- goal
- controlled object
- in-scope inputs and outputs
- out-of-scope areas
- constraints
- disturbance sources
- irreversible or high-risk actions

If the boundary is unclear, make a reasonable assumption and label it. Ask a question only when a wrong boundary would make the output unsafe or useless.

### 2. Identify Variables

Classify variables into:

- controlled variables: what the system must keep within target range
- observed variables: what can be measured or inspected
- control variables: what can be changed by the user or agent
- disturbance variables: what can affect the system but cannot be directly controlled
- lagging variables: outcomes that reveal success late

Avoid vague variables such as "quality" or "progress" unless they are tied to observable measures.

### 3. Design Sensors

For each controlled variable, define the minimum sensor:

- source of data or evidence
- collection frequency
- minimum usable signal
- fallback when data is missing
- owner or actor who supplies it

Prefer a crude sensor that starts the loop over a perfect sensor that blocks action.

### 4. Design Comparators

Define how the system decides whether it is normal, drifting, or failing.

Use three levels unless the domain requires more:

```text
green  = acceptable deviation
yellow = parameter adjustment needed
red    = correction or human review required
```

Each comparator must include a threshold, review rule, or concrete acceptance criterion.

### 5. Design Controllers

For each yellow or red signal, define a correction action:

- trigger condition
- corrective action
- owner
- completion standard
- verification method

Reject non-actions such as "continue monitoring", "optimize later", "improve quality", or "strengthen management" unless they are rewritten as specific actions.

### 6. Set Feedback Cadence

Use at least three layers:

| Layer | Cadence | Purpose |
|---|---|---|
| Action | after each task or run | verify local execution |
| Parameter | weekly, milestone, or sprint | adjust thresholds, scope, or pace |
| System | monthly, release, or quarter | decide whether to redesign the loop |

### 7. Produce a Control Artifact

Default output:

```yaml
type: control-artifact
goal:
controlled_object:
system_boundary:
variables:
  controlled: []
  observed: []
  control: []
  disturbance: []
  lagging: []
sensors: []
comparators: []
controllers: []
feedback_schedule: []
human_review_gates: []
risks: []
next_actions: []
```

Keep the artifact concise. If the user needs a full spec or implementation plan, treat the control artifact as the upstream input and then use the appropriate planning or spec workflow.

## Output Style

Be direct and operational:

- Start with the system boundary.
- Show the loop in a compact form.
- Use tables for variables, sensors, comparators, and controllers.
- End with 3-5 next actions.
- Flag weak sensors, missing thresholds, and risky automation plainly.
- Respect explicit length or format budgets. If the full artifact would exceed the user's budget, output a compressed artifact with all required sections present, then name what was omitted instead of expanding.
- For dry runs, output the artifact and a brief stability note only. Do not offer to start implementation unless the user explicitly asks.

## Common Pitfalls

1. Jumping from idea to implementation without defining the controlled object.
2. Producing a normal task plan with no sensors, thresholds, or correction actions.
3. Using theory words without operational meaning.
4. Treating human review as a bottleneck instead of a control input.
5. Designing too many fields, making the loop too heavy to run.
6. Making finance, legal, medical, or safety-critical actions automatic without human approval.

## Verification Checklist

- [ ] The controlled object is explicit.
- [ ] The system boundary says what is out of scope.
- [ ] Every controlled variable has at least one sensor.
- [ ] Every comparator has an observable threshold or acceptance rule.
- [ ] Every yellow/red state has a concrete controller action.
- [ ] Feedback cadence has action, parameter, and system layers.
- [ ] Human review gates are placed before irreversible or high-risk actions.
- [ ] The final artifact can be used as input for a spec, plan, review, or retrospective.

For saved artifacts, run:

```bash
python skills/ask-dongfeng/scripts/validate_artifact.py path/to/artifact.md
```
