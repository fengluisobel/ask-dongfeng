# Control Artifact Schema

## Minimal Artifact

Use this when the user needs a concise output.

```yaml
type: control-artifact
version: 0.1
goal: ""
controlled_object: ""
system_boundary:
  in_scope: []
  out_of_scope: []
  assumptions: []
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

## Expanded Field Shape

Use this when a teammate will review or implement the artifact.

```yaml
sensors:
  - name: ""
    observes: ""
    source: ""
    cadence: ""
    minimum_usable_signal: ""
    fallback_when_missing: ""

comparators:
  - name: ""
    compares: ""
    green: ""
    yellow: ""
    red: ""
    reviewer: ""

controllers:
  - name: ""
    trigger: ""
    action: ""
    owner: ""
    completion_standard: ""
    verification: ""

feedback_schedule:
  - layer: "action | parameter | system"
    cadence: ""
    questions: []
    output: ""

human_review_gates:
  - gate: ""
    before_action: ""
    reviewer: ""
    approval_criteria: []
```

## Completeness Rules

An artifact is incomplete if:

- `controlled_object` is empty.
- `system_boundary.out_of_scope` is empty for a complex task.
- a controlled variable has no sensor.
- a comparator has no threshold or acceptance rule.
- a red/yellow state has no controller action.
- feedback has only one layer.
- human review is absent before high-risk actions.

## Good Defaults

If the user gives little context, start with:

- controlled variables: outcome quality, execution progress, risk exposure
- sensors: artifact review, test result, user feedback, metric snapshot
- comparator levels: green/yellow/red
- cadence: per task, weekly or milestone, monthly or release
- gates: before implementation, before external release, before destructive changes
