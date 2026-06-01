# Hermes Run Transcripts

These runs were executed on 2026-05-29 from WSL Ubuntu with:

```text
Hermes Agent v0.13.0 (2026.5.7)
Skill: ask-dongfeng
Source: local
Status: enabled
Working directory: /mnt/d/AI Projects/AIToBe/ask-dongfeng
```

This is not a mock transcript. The commands below were run with `hermes chat --skills ask-dongfeng`. Long YAML output is summarized only where the full artifact is already stored as a separate example file.

## Run 1: GitHub Feedback Loop

Command:

```bash
hermes chat --skills ask-dongfeng -q 'Use Ask DongFeng to turn this goal into a control loop: GitHub users should quickly understand Ask DongFeng, install it, try it, and file actionable feedback that can drive fast iteration. Constraints: keep the project small, avoid SaaS, avoid heavy process. Output a concise YAML control-artifact.'
```

Observed behavior:

```text
preparing skill_view...
skill     ask-dongfeng
```

Hermes generated a control artifact, wrote it to disk, then validated it with the bundled validator:

```text
python3 /home/laura/.hermes/skills/software-development/ask-dongfeng/scripts/validate_artifact.py "/mnt/d/AI Projects/AIToBe/ask-dongfeng/adoption-control-artifact.yaml"
PASS. Artifact saved and validated.
```

Session:

```text
Session: 20260529_114901_88185f
Duration: 2m 23s
Messages: 10 (1 user, 8 tool calls)
```

The cleaned, ASCII-normalized artifact is stored at:

- [github-feedback-loop.yaml](./github-feedback-loop.yaml)

## Run 2: Superpowers-Style Writing Plans

Command:

```bash
hermes chat --skills ask-dongfeng -q 'Use Ask DongFeng to review a superpowers-style writing-plans workflow. Context: the workflow decomposes implementation into bite-sized tasks, exact files, test commands, and commit steps. Risk: it can produce good plans, but it may not detect when execution drifts from the plan over time. Output a concise YAML control-artifact. Do not create or modify files; print only.'
```

Observed behavior:

```text
preparing skill_view...
skill     software-development/writing-plans
skill     software-development/ask-dongfeng
```

Important output excerpt:

```text
It diagnoses the core gap you identified -- execution drift has no sensor -- and adds a feedback loop around the existing writing-plans workflow without replacing it.
```

The output added a drift sensor, freshness gate, granularity gate, coverage sensor, and human gates for red execution-fidelity or freshness states.

Session:

```text
Session: 20260529_115143_d8d9d6
Duration: 1m 43s
Messages: 5 (1 user, 3 tool calls)
```

Related validated example:

- [superpowers-writing-plans.yaml](./superpowers-writing-plans.yaml)

## Run 3: Spike / Sisyphus Loop Control

Command:

```bash
hermes chat --skills ask-dongfeng -q 'Use Ask DongFeng to control a spike workflow. Context: a spike is a disposable experiment: decompose, research, build, verdict. Risk: the workflow can become an endless needs-more-investigation loop. Model this as a control loop. Focus on stopping rules, repeated-experiment detection, verdict gates, and system review. Output a concise YAML control-artifact. Do not create or modify files; print only.'
```

Important output excerpt:

```text
Every spike produces a decisive verdict (go / no-go / re-spike-with-delta) within a bounded time and depth budget.
```

The output emphasized elapsed-time, depth, and similarity sensors; yellow/red thresholds; forced verdict controllers; repeated-spike blocking; and human review gates before re-spike authorization.

Session:

```text
Session: 20260529_115339_1c5605
Duration: 1m 14s
Messages: 2 (1 user, 0 tool calls)
```

Related validated example:

- [spike-sisyphus-loop.yaml](./spike-sisyphus-loop.yaml)

## Run 4: Framework Replacement / DongFeng Packet

Command:

```bash
hermes chat --skills ask-dongfeng -Q -q 'Use Ask DongFeng to replace a superpowers-style planning workflow for this goal: build a Hermes skill that turns fuzzy product ideas into reviewable MVP specs. Output a concise DongFeng Packet, not only a control artifact.'
```

Important output excerpt:

```text
# DongFeng Packet: Product Idea -> MVP Spec Skill

## 1. Mode: `intent-to-spec`

## 3. Decision: PROCEED

## 5. Execution Contract (intent-to-spec)
```

What this run proves:

- Ask DongFeng now selects an operating mode before generating the artifact.
- The output is not only a control artifact; it includes a decision, execution contract, review gate, and next actions.
- This is closer to a framework workflow replacement for spec/planning tools than the earlier control-loop-only behavior.

## What These Runs Prove

- Hermes can discover and load the local `ask-dongfeng` skill.
- Ask DongFeng produces outputs that differ from ordinary planning by adding sensors, comparators, controllers, feedback cadence, and human gates.
- The skill can wrap another workflow skill (`writing-plans`) instead of replacing it.
- The bundled validator can be used from inside a Hermes run to check a generated artifact.
- Ask DongFeng can produce a full `DongFeng Packet`, not just a standalone YAML control artifact.
