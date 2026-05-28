# Before / After Demo

This file shows the difference between ordinary planning output and Ask DongFeng output.

## User Goal

```text
I want to build an open-source Hermes skill that turns fuzzy product ideas into reviewable MVP specs.
Constraints:
- skill-first, not SaaS
- no database
- no automatic code generation
```

## Before: Ordinary Planning Style

This kind of answer is useful, but it is mostly a task list.

```text
1. Define the target user and problem.
2. Draft the skill prompt and output structure.
3. Create example prompts and sample outputs.
4. Build a validator for the generated artifact.
5. Test the skill on a few ideas.
6. Improve the README and publish to GitHub.
```

What is missing:

- no explicit controlled object
- no sensors for detecting drift
- no thresholds for good vs bad output
- no correction actions when quality falls
- no human review gates
- no feedback cadence

## After: Ask DongFeng Style

This is compressed on purpose. The full artifact can be larger, but the structure is what matters.

```yaml
type: control-artifact
goal: "Turn fuzzy product ideas into reviewable MVP specs through an open-source Hermes skill"
controlled_object: "The transformation from vague product idea to reviewable MVP spec artifact"
system_boundary:
  in_scope:
    - single-skill output design
    - reviewable spec generation
    - human approval before handoff
  out_of_scope:
    - SaaS implementation
    - database design
    - automatic code generation
variables:
  controlled:
    - spec completeness
    - scope clarity
  observed:
    - ambiguity count
    - missing section count
  control:
    - follow-up questions
    - output constraints
  disturbance:
    - vague input
    - scope creep
  lagging:
    - downstream implementation success
sensors:
  - name: section-check
    source: generated spec
    cadence: each run
  - name: ambiguity-scan
    source: generated spec
    cadence: each run
comparators:
  - name: readiness
    green: all required sections present and ambiguity low
    yellow: one required section missing or ambiguity moderate
    red: major omissions or high ambiguity
controllers:
  - name: re-ask
    trigger: yellow_or_red
    action: ask follow-up questions and regenerate
feedback_schedule:
  - layer: action
    cadence: each run
  - layer: parameter
    cadence: weekly
  - layer: system
    cadence: monthly
human_review_gates:
  - gate: final-spec-approval
    reviewer: product owner
risks:
  - vague inputs hide missing requirements
next_actions:
  - define required sections
  - review sample outputs
  - validate artifacts before release
```

## What Ask DongFeng Adds

Ordinary planning answers:

- what to do next

Ask DongFeng answers:

- what is being controlled
- how drift is observed
- when output quality is still acceptable
- what action runs when quality drops
- where a human must review before proceeding
- how the loop is reviewed over time

If those questions matter, Ask DongFeng is a better upstream framework than a plain plan.
