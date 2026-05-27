# Review Questions

Use these questions when preparing a teammate review or human approval gate.

## Positioning

- Is the controlled object clearly named?
- Is this really a control loop, or just a plan with control-theory language?
- What is explicitly out of scope?
- What should the agent not do automatically?

## Variables

- Which variable best represents success?
- Which important variable is not observable yet?
- Which variable can the agent or user actually change?
- Which outcomes are lagging indicators and should not be used for immediate control?

## Sensors

- Is each sensor cheap enough to run repeatedly?
- What happens if the data is incomplete?
- Is the sensor measuring reality or merely model confidence?
- Can a human inspect the evidence?

## Comparators

- Are green/yellow/red thresholds concrete?
- Are the thresholds too strict to use or too vague to matter?
- Who decides ambiguous cases?
- What would make the comparator produce false confidence?

## Controllers

- Does every warning state trigger a real action?
- Is the action small enough to execute?
- Is there a completion standard?
- Does the action change future behavior, or only describe the problem?

## Feedback

- Is there an action-level feedback loop?
- Is there a parameter-level review?
- Is there a system-level redesign point?
- What evidence would cause the team to stop or pivot?

## Risk

- Are irreversible actions gated by human review?
- Are financial, legal, medical, safety, or public-release risks controlled?
- Is the system over-automated?
- What assumption would most likely break the loop?
