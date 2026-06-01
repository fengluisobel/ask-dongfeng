---
name: ask-dongfeng
description: "Framework workflow skill for replacing or wrapping spec, planning, superpowers-style writing-plans, spike, and review-gate workflows. Use when a user wants to turn an ambiguous goal, product idea, workflow, project, research spike, or implementation plan into a DongFeng Packet: selected operating mode, reviewable control artifact, execution contract, sensors, comparators, controllers, feedback cadence, human gates, and next prompts/actions."
license: MIT
metadata:
  hermes:
    tags: [control, cybernetics, planning, spec, feedback, review, workflow, systems-thinking]
    related_skills: [plan, writing-plans, spike, requesting-code-review]
---

# Ask DongFeng

## Overview

Ask DongFeng is a framework workflow skill for making agent work controllable. It should behave less like a theory explainer and more like an upstream operating system for agent work.

Use it to replace or wrap these common workflows:

- spec framing: turn a fuzzy idea into a reviewable MVP/spec contract
- implementation planning: make a plan executable and drift-resistant
- spike workflows: prevent experiments from becoming endless research loops
- review gates: decide whether to proceed, revise, spike, or block
- feedback iteration: turn user or repo feedback into a controlled improvement loop

It adapts engineering-cybernetics ideas into a practical loop:

```text
controlled object -> sensors -> comparators -> controllers -> execution -> feedback
```

The goal is not to produce a prettier plan. The goal is to produce a handoff artifact that makes the next agent or human know what to do, how to detect drift, when to stop, and where approval is required.

## When to Use

Use this skill when the user asks to:

- turn a vague idea into an executable system or workflow
- design a spec that includes feedback and correction, not just requirements
- replace or wrap a planning/spec/superpowers/spike workflow
- prevent an agent from jumping directly into code or implementation
- define review gates, thresholds, signals, or acceptance criteria
- build a reusable operating loop for product, engineering, finance, learning, operations, or personal systems
- create something "like spec", "like superpower", or "framework-style" but centered on feedback control

Do not use this skill for:

- one-off factual answers
- tiny implementation tasks with obvious acceptance criteria
- pure brainstorming where no execution or feedback loop is needed
- high-risk domains where the user expects automated financial, legal, medical, or safety-critical execution

## Operating Modes

Choose one mode before producing the artifact. If the user does not specify a mode, infer it from the request.

| Mode | Use when | Primary output |
|---|---|---|
| `intent-to-spec` | user has a fuzzy product, repo, workflow, or MVP idea | MVP/spec contract plus control artifact |
| `plan-guard` | user has or needs an implementation plan | executable plan guardrails, drift sensors, review gates |
| `spike-control` | user is exploring feasibility or comparing approaches | spike questions, stopping rules, verdict gates |
| `review-gate` | user wants to decide whether to proceed, ship, merge, or revise | green/yellow/red decision and required corrections |
| `iteration-loop` | user has GitHub/user/team feedback and wants fast iteration | feedback intake, triage, release/update loop |

Default inference:

- product idea, MVP, spec, "turn this into a buildable thing" -> `intent-to-spec`
- plan, implementation plan, tasks, superpowers, writing-plans -> `plan-guard`
- spike, experiment, prototype, "is this possible", comparison -> `spike-control`
- review, approve, ship, merge, ready, risk -> `review-gate`
- GitHub feedback, stars, users, issues, adoption, iteration -> `iteration-loop`

## Default Output: DongFeng Packet

Unless the user asks for YAML only, produce a compact DongFeng Packet with these sections:

1. **Mode**: selected mode and why.
2. **Boundary**: goal, controlled object, in scope, out of scope, assumptions.
3. **Decision**: proceed, ask clarification, spike, revise, or block.
4. **Control Artifact**: the canonical control loop with sensors, comparators, controllers, feedback, human gates, risks, and next actions.
5. **Execution Contract**: the concrete handoff for the selected mode:
   - `intent-to-spec`: problem, users, MVP scope, non-goals, acceptance criteria, review gate
   - `plan-guard`: task quality rules, drift log, freshness checks, test commands, approval gate
   - `spike-control`: spike questions, time/depth budget, verdict format, repetition check
   - `review-gate`: green/yellow/red checklist, blockers, required fixes, approval criteria
   - `iteration-loop`: issue intake, labels, triage cadence, repeated-topic controller, release gate
6. **Next Prompt or Action**: the exact next prompt, command, or review step the user can run.

If the user explicitly requests a machine-readable artifact, output only the `control-artifact` YAML and keep every required field non-empty.

## Replacement Standard

Ask DongFeng can replace a planning/spec/spike workflow only when the output can be used without another explanation step.

The output must answer:

- What artifact should exist after this run?
- Who or what executes the next step?
- What evidence proves the output is good enough?
- What signals show drift or failure?
- What correction happens on yellow or red?
- What human approval is required before irreversible work?
- What prompt or command should be run next?

If the output only explains control theory or lists tasks, it failed the replacement standard.

## Load References As Needed

- Read `references/control-framework.md` when the task needs deeper control-loop reasoning or the user asks "why this structure".
- Read `references/artifact-schema.md` when producing a machine-readable artifact or validating completeness.
- Read `references/operating-modes.md` when choosing between intent-to-spec, plan-guard, spike-control, review-gate, and iteration-loop modes.
- Read `references/review-questions.md` when preparing peer review, teammate critique, or human approval gates.
- Read `references/examples.md` when the user asks for examples or the domain is unclear.
- Use `scripts/validate_artifact.py` when a generated artifact is saved to a file and needs deterministic completeness checks.

## Core Workflow

### 1. Select the Operating Mode

Infer or state the mode first. If two modes fit, choose the mode that controls the earliest failure point.

Examples:

- If the user has only an idea, start with `intent-to-spec`, not implementation planning.
- If the user already has a plan, use `plan-guard`, not a new plan.
- If feasibility is unknown, use `spike-control`, not a full spec.
- If the user asks "is this ready", use `review-gate`, not a rewrite.

### 2. Define the System Boundary

Before planning or coding, identify:

- goal
- controlled object
- in-scope inputs and outputs
- out-of-scope areas
- constraints
- disturbance sources
- irreversible or high-risk actions

If the boundary is unclear, make a reasonable assumption and label it. Ask a question only when a wrong boundary would make the output unsafe or useless.

### 3. Identify Variables

Classify variables into:

- controlled variables: what the system must keep within target range
- observed variables: what can be measured or inspected
- control variables: what can be changed by the user or agent
- disturbance variables: what can affect the system but cannot be directly controlled
- lagging variables: outcomes that reveal success late

Avoid vague variables such as "quality" or "progress" unless they are tied to observable measures.

### 4. Design Sensors

For each controlled variable, define the minimum sensor:

- source of data or evidence
- collection frequency
- minimum usable signal
- fallback when data is missing
- owner or actor who supplies it

Prefer a crude sensor that starts the loop over a perfect sensor that blocks action.

### 5. Design Comparators

Define how the system decides whether it is normal, drifting, or failing.

Use three levels unless the domain requires more:

```text
green  = acceptable deviation
yellow = parameter adjustment needed
red    = correction or human review required
```

Each comparator must include a threshold, review rule, or concrete acceptance criterion.

### 6. Design Controllers

For each yellow or red signal, define a correction action:

- trigger condition
- corrective action
- owner
- completion standard
- verification method

Reject non-actions such as "continue monitoring", "optimize later", "improve quality", or "strengthen management" unless they are rewritten as specific actions.

### 7. Set Feedback Cadence

Use at least three layers:

| Layer | Cadence | Purpose |
|---|---|---|
| Action | after each task or run | verify local execution |
| Parameter | weekly, milestone, or sprint | adjust thresholds, scope, or pace |
| System | monthly, release, or quarter | decide whether to redesign the loop |

### 8. Produce the DongFeng Packet or Control Artifact

Machine-readable control-artifact shape:

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

Keep the artifact concise. If the user needs a full spec, implementation plan, spike, or review gate, include the selected mode's Execution Contract in the DongFeng Packet.

## Output Style

Be direct and operational:

- Start with the system boundary.
- State the selected mode before deep analysis.
- Show the loop in a compact form.
- Use tables for variables, sensors, comparators, and controllers.
- End with 3-5 next actions or an exact next prompt.
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
7. Producing a `control-artifact` with no execution contract, leaving the user unsure what to do next.

## Verification Checklist

- [ ] The controlled object is explicit.
- [ ] The system boundary says what is out of scope.
- [ ] Every controlled variable has at least one sensor.
- [ ] Every comparator has an observable threshold or acceptance rule.
- [ ] Every yellow/red state has a concrete controller action.
- [ ] Feedback cadence has action, parameter, and system layers.
- [ ] Human review gates are placed before irreversible or high-risk actions.
- [ ] The final artifact can be used as input for a spec, plan, review, or retrospective.
- [ ] If replacing a workflow, the DongFeng Packet includes an execution contract and exact next prompt/action.

For saved artifacts, run:

```bash
python skills/ask-dongfeng/scripts/validate_artifact.py path/to/artifact.md
```
