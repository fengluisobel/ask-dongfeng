# Ask DongFeng

Ask DongFeng is a Hermes skill for turning vague goals, product ideas, workflows, or project systems into reviewable engineering-control loops.

It is not a normal planning prompt. It asks:

```text
What is being controlled?
How is reality observed?
How is deviation detected?
What corrective action runs when the system drifts?
Where must a human approve before execution continues?
```

## What It Outputs

Ask DongFeng produces a `control-artifact` with:

- `controlled_object`
- `system_boundary`
- `variables`
- `sensors`
- `comparators`
- `controllers`
- `feedback_schedule`
- `human_review_gates`
- `risks`
- `next_actions`

Use it before writing a spec, implementation plan, code, or review process when the risk is not "we need more tasks" but "the work may drift without being noticed."

## Install

Clone the repo:

```bash
git clone https://github.com/YOUR_ORG/ask-dongfeng.git
cd ask-dongfeng
```

Install into the active Hermes local skill directory:

```bash
SKILL_HOME="${HERMES_HOME:-$HOME/.hermes}/skills/software-development/ask-dongfeng"
mkdir -p "$SKILL_HOME"
cp -a SKILL.md references scripts agents "$SKILL_HOME/"
```

Verify:

```bash
hermes skills list --source local --enabled-only | grep ask-dongfeng
```

Run:

```bash
hermes chat --skills ask-dongfeng
```

One-shot example:

```bash
hermes chat --skills ask-dongfeng -q "Use Ask DongFeng to turn this goal into a control loop: build an open-source Hermes skill that turns fuzzy product ideas into reviewable MVP specs."
```

## Example Prompts

### 1. Fuzzy Product Idea to MVP Spec

```text
Use Ask DongFeng to turn this goal into a control loop:
I want to build an open-source Hermes skill that turns fuzzy product ideas into reviewable MVP specs.

Constraints:
- skill-first, not SaaS
- no database
- no automatic code generation

Output a concise YAML control-artifact with controlled_object, system_boundary, variables, sensors, comparators, controllers, feedback_schedule, human_review_gates, risks, and next_actions.
```

### 2. Superpowers-Style Writing Plans

```text
Use Ask DongFeng to review a superpowers-style writing-plans workflow.

Context:
The workflow decomposes implementation into bite-sized tasks, exact files, test commands, and commit steps.

Risk:
It can produce good plans, but it may not detect when execution drifts from the plan over time.

Output a control-artifact and explain what Ask DongFeng adds beyond ordinary planning.
```

### 3. Spike / Sisyphus Loop Control

```text
Use Ask DongFeng to control a spike workflow.

Context:
A spike is a disposable experiment: decompose -> research -> build -> verdict.

Risk:
The workflow can become an endless "needs more investigation" loop.

Model this as a control loop. Focus on stopping rules, repeated-experiment detection, verdict gates, and system review.
```

## Validate Artifacts

Ask DongFeng includes a lightweight validator for saved control artifacts.

Save the output to a Markdown or YAML file, then run:

```bash
python scripts/validate_artifact.py path/to/artifact.md
```

The validator checks for missing core loop parts:

- `controlled_object`
- `system_boundary`
- `variables`
- `sensors`
- `comparators`
- `controllers`
- `feedback_schedule`
- `human_review_gates`
- `risks`
- `next_actions`

It also warns when comparators lack `green/yellow/red`, controllers lack `trigger/action`, or feedback does not include action, parameter, and system layers.

The validator is intentionally conservative. It checks completeness, not whether the strategy is correct.

## Repo Layout

```text
ask-dongfeng/
├── SKILL.md
├── agents/
│   └── openai.yaml
├── references/
│   ├── artifact-schema.md
│   ├── control-framework.md
│   ├── examples.md
│   └── review-questions.md
└── scripts/
    └── validate_artifact.py
```

## Publish to GitHub

From inside this standalone directory:

```bash
git init
git add .
git commit -m "Initial Ask DongFeng skill"
gh repo create ask-dongfeng --public --source=. --remote=origin --push
```

If you do not use GitHub CLI, create an empty GitHub repo first, then run:

```bash
git remote add origin https://github.com/YOUR_ORG/ask-dongfeng.git
git branch -M main
git push -u origin main
```

## License

MIT
