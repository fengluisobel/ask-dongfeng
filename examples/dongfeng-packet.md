# DongFeng Packet Example

User goal:

```text
I want to build an open-source Hermes skill that turns fuzzy product ideas into reviewable MVP specs.
```

## Mode

- selected_mode: `intent-to-spec`
- why: The user has a fuzzy product idea and needs a reviewable artifact before implementation planning.

## Boundary

- goal: Turn fuzzy product ideas into reviewable MVP specs through a Hermes skill.
- controlled_object: The transformation from vague product idea to MVP spec handoff.
- in_scope: skill behavior, output structure, validation, human approval.
- out_of_scope: SaaS, database, automatic code generation.
- assumptions: The first public version should stay small enough to install and inspect in minutes.

## Decision

- state: proceed
- reason: Scope is small, artifact can be validated, and implementation can wait until the spec contract is reviewable.
- approval_needed: Human approval before writing an implementation plan or publishing a release.

## Control Artifact

```yaml
type: control-artifact
goal: Turn fuzzy product ideas into reviewable MVP specs
controlled_object: The idea-to-spec transformation performed by the skill
system_boundary:
  in_scope:
    - skill prompt and output behavior
    - MVP spec contract
    - validator-backed completeness check
  out_of_scope:
    - SaaS implementation
    - database
    - automatic code generation
variables:
  controlled:
    - spec completeness
    - scope clarity
  observed:
    - missing section count
    - ambiguity count
  control:
    - follow-up questions
    - output template constraints
  disturbance:
    - vague input
    - scope creep
  lagging:
    - downstream implementation success
sensors:
  - name: section-check
    source: generated spec
    cadence: each run
comparators:
  - name: spec-readiness
    green: all required sections present and no unresolved blocker
    yellow: one required section weak or ambiguity remains
    red: missing core sections or scope is not bounded
controllers:
  - name: tighten-spec
    trigger: yellow_or_red
    action: ask targeted clarification questions or regenerate with stricter section constraints
feedback_schedule:
  - layer: action
    cadence: each generated spec
  - layer: parameter
    cadence: weekly while examples are being added
  - layer: system
    cadence: each release
human_review_gates:
  - gate: spec-approval-before-plan
    reviewer: maintainer or product owner
risks:
  - polished wording can hide missing acceptance criteria
next_actions:
  - define the MVP spec sections
  - generate one sample spec
  - validate the artifact before implementation planning
```

## Execution Contract

- deliverable: A reviewable MVP spec with problem, target user, scope, non-goals, acceptance criteria, risks, and next implementation prompt.
- quality_bar: A maintainer can decide whether to build without asking what the product is supposed to do.
- validation: Run `python scripts/validate_artifact.py <artifact>` and perform human review against the acceptance criteria.
- owner: Skill author or agent using Ask DongFeng.
- stop_condition: Stop before implementation if the spec has missing scope, weak acceptance criteria, or no human approval.
- handoff: Use the approved packet as input to writing-plans, implementation planning, or code review.

## Next Prompt Or Action

```text
Use Ask DongFeng in intent-to-spec mode. Create a reviewable MVP spec contract for this Hermes skill idea. Include problem, target user, MVP scope, non-goals, acceptance criteria, risks, human review gate, and next implementation-planning prompt.
```
