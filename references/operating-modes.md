# Ask DongFeng Operating Modes

Use this reference when choosing how Ask DongFeng should behave as a framework workflow skill.

## Mode Selection

| Mode | Trigger language | Replaces or wraps | Must produce |
|---|---|---|---|
| `intent-to-spec` | idea, MVP, product, spec, make this buildable | lightweight spec workflows | problem, users, MVP scope, non-goals, acceptance criteria, control artifact, next spec prompt |
| `plan-guard` | plan, tasks, writing-plans, superpowers, implementation | implementation planning workflows | task quality rules, drift sensors, freshness checks, review gates, next execution prompt |
| `spike-control` | spike, prototype, compare, feasibility, is this possible | spike / Sisyphus workflows | spike questions, time/depth budget, repetition check, verdict format |
| `review-gate` | ready, approve, ship, merge, review, risk | review checklist workflows | green/yellow/red decision, blockers, required fixes, approval criteria |
| `iteration-loop` | feedback, users, GitHub issues, stars, adoption, release | feedback/ops loops | intake template, triage labels, repeated-topic controller, release gate |

## DongFeng Packet Template

````markdown
## Mode

- selected_mode:
- why:

## Boundary

- goal:
- controlled_object:
- in_scope:
- out_of_scope:
- assumptions:

## Decision

- state: proceed | ask | spike | revise | block
- reason:
- approval_needed:

## Control Artifact

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

## Execution Contract

- deliverable:
- quality_bar:
- validation:
- owner:
- stop_condition:
- handoff:

## Next Prompt Or Action

```text
...
```
````

## Execution Contracts By Mode

### intent-to-spec

Must include:

- target user or reviewer
- problem statement
- MVP scope and non-goals
- acceptance criteria
- review gate before implementation planning
- exact next prompt for turning the packet into a spec or implementation plan

### plan-guard

Must include:

- task granularity rule
- exact-file and command requirements
- drift log fields
- freshness check before execution
- yellow/red correction actions
- human approval before execution or after red drift

### spike-control

Must include:

- 2-5 spike questions, unless the user provided one exact spike
- time budget and depth budget
- repeated-spike check
- verdict format: VALIDATED, PARTIAL, INVALIDATED, or RE-SPIKE-WITH-DELTA
- stop rule when the spike exceeds budget or repeats prior work

### review-gate

Must include:

- green/yellow/red decision
- blockers
- required fixes
- residual risks
- approval criteria
- exact condition for proceeding

### iteration-loop

Must include:

- intake channel
- labels or categories
- triage cadence
- repeated-topic threshold
- release or update gate
- feedback-to-change mapping

## Failure Modes

The output is not good enough if:

- it explains control theory but gives no next action
- it produces only a task list
- it has no stop condition
- it has no review gate before irreversible actions
- it cannot be handed to another agent or human as an operating artifact
