# Ask DongFeng Control Framework

## Purpose

This reference expands the control-loop method used by the `ask-dongfeng` skill. Load it when the user needs deeper reasoning, peer-review-ready framing, or a stronger explanation of why the workflow is not just ordinary planning.

## Control Loop Mapping

| Control concept | Practical meaning for agent work |
|---|---|
| Controlled object | The thing being shaped: product, workflow, behavior, project, learning system, financial routine |
| Controlled variable | The outcome that must stay within target range |
| Sensor | A lightweight way to observe reality |
| Comparator | A rule that compares observed state with desired state |
| Controller | A corrective action that changes future behavior |
| Feedback | A scheduled review that updates actions, parameters, or system design |
| Disturbance | External or internal factors that affect the system but are not directly controlled |
| Stability | The system does not drift, explode in scope, or silently fail |
| Robustness | The loop still works with incomplete data, model variance, or skipped reviews |

## Core Discipline

The skill should always convert abstractions into operational checks.

Bad:

```text
Improve product quality.
```

Better:

```text
If the weekly review finds more than 3 unresolved critical defects, freeze feature work for 48 hours and run a defect-burn-down pass. Completion standard: critical defects <= 1 and regression tests pass.
```

## Minimum Viable Loop

A loop is minimally viable when it has:

1. A controlled object.
2. One to three controlled variables.
3. At least one sensor per controlled variable.
4. A green/yellow/red comparator.
5. At least one controller action for yellow or red.
6. A feedback cadence.
7. A human review gate before risky or irreversible execution.

If one of these is missing, do not pretend the loop is complete. Call out the gap.

## Layered Feedback

Use three layers by default:

| Layer | Question | Typical output |
|---|---|---|
| Action layer | Did this task produce the expected local result? | pass/fail, fix now, rerun |
| Parameter layer | Are thresholds, scope, or cadence still right? | adjust limits, reprioritize, cut scope |
| System layer | Is this still the right control system? | redesign loop, merge/split loops, stop work |

## Human Review Gates

Human review is a control input, not a decoration. Put gates before:

- scope expansion
- external publishing
- irreversible data changes
- money movement
- user-facing automation
- deleting or rewriting important artifacts
- declaring success based on weak evidence

## Differentiation From Spec / Planning Workflows

A normal spec describes what should be built. Ask DongFeng describes how the work stays aligned after reality pushes back.

Ask DongFeng should not merely add control-theory vocabulary on top of a spec or plan. It should produce a usable operating packet: selected mode, boundary, decision, control artifact, execution contract, and next prompt/action.

Therefore, a strong Ask DongFeng output includes:

- requirements or target state
- observation method
- deviation threshold
- correction action
- review cadence
- residual risk
- exact handoff instruction

Without feedback and correction, it is only a spec, not a control loop.
