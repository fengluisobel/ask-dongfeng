# Ask DongFeng

[![CI](https://github.com/fengluisobel/ask-dongfeng/actions/workflows/ci.yml/badge.svg)](https://github.com/fengluisobel/ask-dongfeng/actions/workflows/ci.yml)

English | [Chinese README](./README.zh-CN.md)

Ask DongFeng is a Hermes-first skill for turning vague goals, product ideas, workflows, or project systems into reviewable engineering-control loops.

30-second pitch:

- Normal planning says what to do.
- Ask DongFeng says how to detect drift, when to correct it, and where a human must approve.
- The output is a `control-artifact` you can use upstream of specs, implementation plans, code review, or workflow design.

Core loop:

```text
vague goal
  -> Ask DongFeng
  -> control-artifact
  -> validator + human review
  -> spec / plan / code / workflow
```

## What It Produces

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

Use it when the real risk is not "we need more tasks," but "the work may drift without being noticed."

## Evaluate In 5 Minutes

1. Read the sample artifact: [examples/sample-control-artifact.yaml](./examples/sample-control-artifact.yaml)
2. Run the validator:

   ```bash
   python scripts/validate_artifact.py examples/sample-control-artifact.yaml
   ```

3. Read one example prompt below and decide whether this is the right upstream framework for your spec/plan workflow.

If you want the fastest "before vs after" view, read:

- [examples/demo-before-after.md](./examples/demo-before-after.md)

If you want ready-made example artifacts, start with:

- [examples/sample-control-artifact.yaml](./examples/sample-control-artifact.yaml)
- [examples/github-feedback-loop.yaml](./examples/github-feedback-loop.yaml)
- [examples/superpowers-writing-plans.yaml](./examples/superpowers-writing-plans.yaml)
- [examples/spike-sisyphus-loop.yaml](./examples/spike-sisyphus-loop.yaml)
- [examples/tdd-precommit-quality-system.yaml](./examples/tdd-precommit-quality-system.yaml)

If you want evidence from a real Hermes run, read:

- [examples/hermes-run-transcripts.md](./examples/hermes-run-transcripts.md)

## Quick Start

Hermes is the primary target.

```bash
git clone https://github.com/fengluisobel/ask-dongfeng.git && cd ask-dongfeng
SKILL_HOME="${HERMES_HOME:-$HOME/.hermes}/skills/software-development/ask-dongfeng"; mkdir -p "$SKILL_HOME"; cp -a SKILL.md references scripts agents "$SKILL_HOME/"
hermes chat --skills ask-dongfeng
```

Verify local install:

```bash
hermes skills list --source local --enabled-only | grep ask-dongfeng
```

One-shot example:

```bash
hermes chat --skills ask-dongfeng -q "Use Ask DongFeng to turn this goal into a control loop: build an open-source Hermes skill that turns fuzzy product ideas into reviewable MVP specs."
```

## Compatibility

Ask DongFeng is designed for Hermes first, but the repository follows the common `SKILL.md` package shape used by current agent-skill systems: a `SKILL.md` file plus optional `references/`, `scripts/`, and `agents/` resources.

### Hermes

Install under the local Hermes skill tree:

```bash
SKILL_HOME="${HERMES_HOME:-$HOME/.hermes}/skills/software-development/ask-dongfeng"
mkdir -p "$SKILL_HOME"
cp -a SKILL.md references scripts agents "$SKILL_HOME/"
hermes chat --skills ask-dongfeng
```

### Codex / OpenAI Skills

Install as a local Codex skill:

```bash
mkdir -p "${CODEX_HOME:-$HOME/.codex}/skills"
cp -a . "${CODEX_HOME:-$HOME/.codex}/skills/ask-dongfeng"
```

Then ask Codex to use `ask-dongfeng` for control-loop planning tasks.

### Claude / Claude Code

Install as a personal Claude skill:

```bash
mkdir -p "$HOME/.claude/skills"
cp -a . "$HOME/.claude/skills/ask-dongfeng"
```

Or as a project-local skill:

```bash
mkdir -p .claude/skills
cp -a /path/to/ask-dongfeng .claude/skills/ask-dongfeng
```

Claude can use the instructional parts directly. The Python validators are optional and only matter when the environment allows script execution.

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

Validated example artifact:

- [examples/sample-control-artifact.yaml](./examples/sample-control-artifact.yaml)

### 2. Superpowers-Style Writing Plans

```text
Use Ask DongFeng to review a superpowers-style writing-plans workflow.

Context:
The workflow decomposes implementation into bite-sized tasks, exact files, test commands, and commit steps.

Risk:
It can produce good plans, but it may not detect when execution drifts from the plan over time.

Output a control-artifact and explain what Ask DongFeng adds beyond ordinary planning.
```

Validated example artifact:

- [examples/superpowers-writing-plans.yaml](./examples/superpowers-writing-plans.yaml)

### 3. Spike / Sisyphus Loop Control

```text
Use Ask DongFeng to control a spike workflow.

Context:
A spike is a disposable experiment: decompose -> research -> build -> verdict.

Risk:
The workflow can become an endless "needs more investigation" loop.

Model this as a control loop. Focus on stopping rules, repeated-experiment detection, verdict gates, and system review.
```

Validated example artifact:

- [examples/spike-sisyphus-loop.yaml](./examples/spike-sisyphus-loop.yaml)

### 4. GitHub Feedback Loop

```text
Use Ask DongFeng to turn this goal into a control loop:
GitHub users should quickly understand Ask DongFeng, install it, try it, and file actionable feedback that can drive fast iteration.

Constraints:
- keep the project small
- avoid SaaS
- avoid heavy process

Output a concise YAML control-artifact.
```

Validated example artifact:

- [examples/github-feedback-loop.yaml](./examples/github-feedback-loop.yaml)

Real Hermes transcript:

- [examples/hermes-run-transcripts.md](./examples/hermes-run-transcripts.md)

## Before / After Demo

This repo includes a compact comparison between:

- a normal planning-style answer
- an Ask DongFeng control-artifact answer

Read:

- [examples/demo-before-after.md](./examples/demo-before-after.md)

The point is not that Ask DongFeng is always longer. The point is that it adds:

- observable signals
- deviation thresholds
- correction actions
- human review gates
- feedback cadence

## Validators

Ask DongFeng includes two lightweight validators.

Validate a generated control artifact:

```bash
python scripts/validate_artifact.py path/to/artifact.md
```

Validate the skill package shape itself:

```bash
python scripts/validate_skill.py SKILL.md
```

`validate_artifact.py` checks for missing core loop parts:

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

`validate_skill.py` checks for:

- YAML frontmatter existence
- required `name` and `description`
- unexpected top-level frontmatter keys
- referenced bundled files that do not exist

Both validators are intentionally conservative. They check package and artifact completeness, not whether the strategy is good.

## Feedback And Iteration

Ask DongFeng uses GitHub Issues as the feedback loop.

Use the issue templates for:

- bugs in installation, validators, or package shape
- practical feature requests with a concrete use case
- use-case feedback with an exact prompt and output excerpt

Maintainer loop:

- triage new issues within 48 hours when possible
- label by failure surface: install, first-run, validator, example, documentation, or scope
- convert repeated topics into an example artifact, validator rule, README patch, or SKILL.md change
- cut a patch release only after validators and at least one Hermes self-test pass

The control artifact for this loop is:

- [examples/github-feedback-loop.yaml](./examples/github-feedback-loop.yaml)

## Repo Layout

```text
ask-dongfeng/
|-- .github/
|   |-- ISSUE_TEMPLATE/
|   |   |-- bug_report.md
|   |   |-- feature_request.md
|   |   `-- use_case_feedback.yml
|   `-- workflows/
|       `-- ci.yml
|-- agents/
|   `-- openai.yaml
|-- examples/
|   |-- demo-before-after.md
|   |-- github-feedback-loop.yaml
|   |-- hermes-run-transcripts.md
|   |-- sample-control-artifact.yaml
|   |-- spike-sisyphus-loop.yaml
|   |-- superpowers-writing-plans.yaml
|   `-- tdd-precommit-quality-system.yaml
|-- references/
|   |-- artifact-schema.md
|   |-- control-framework.md
|   |-- examples.md
|   `-- review-questions.md
|-- scripts/
|   |-- validate_artifact.py
|   `-- validate_skill.py
|-- LICENSE
|-- README.md
`-- SKILL.md
```

## Boundaries

This repo is intentionally small.

It does not include:

- a backend
- a SaaS product
- a database
- automatic code generation
- broad workflow automation beyond the control-loop framing itself

## Publish To GitHub

From inside this standalone directory:

```bash
git init
git add .
git commit -m "Initial Ask DongFeng skill"
gh repo create ask-dongfeng --public --source=. --remote=origin --push
```

If you do not use GitHub CLI, create an empty GitHub repo first, then run:

```bash
git remote add origin https://github.com/fengluisobel/ask-dongfeng.git
git branch -M main
git push -u origin main
```

## License

MIT
