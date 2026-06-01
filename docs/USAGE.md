# Ask DongFeng Usage Guide

Ask DongFeng is easiest to use as a startup skill for upstream work: spec shaping, plan guarding, spike control, review gates, and feedback loops.

It is not a magic autopilot. It reduces repeated human reminders by putting the reminders into the packet: sensors, thresholds, controllers, stop rules, and human gates.

## Start It

Install:

```bash
scripts/install_hermes.sh
```

Interactive:

```bash
scripts/ask_dongfeng.sh
```

Single prompt:

```bash
scripts/ask_dongfeng.sh "Use Ask DongFeng in intent-to-spec mode: turn this fuzzy idea into a DongFeng Packet: ..."
```

Script-friendly output:

```bash
scripts/ask_dongfeng.sh --quiet "Print only the control-artifact YAML for this goal: ..."
```

Raw Hermes command, if you do not want the wrapper:

```bash
hermes chat --skills ask-dongfeng -q "Use Ask DongFeng to ..."
```

## Three Tutorials

### 1. Fuzzy Idea To Reviewable Spec

Use when you would normally ask for a product spec.

```bash
scripts/ask_dongfeng.sh "Use Ask DongFeng in intent-to-spec mode. Goal: I want to build a Hermes skill that turns fuzzy product ideas into reviewable MVP specs. Produce a DongFeng Packet with MVP scope, non-goals, acceptance criteria, control artifact, review gate, and next implementation-planning prompt."
```

Expected output:

- mode: `intent-to-spec`
- decision: proceed / ask / spike / block
- MVP/spec execution contract
- review gate before implementation planning
- next prompt for planning or writing a real spec

### 2. Replace A Superpowers-Style Plan

Use when you would normally ask for a long implementation plan.

```bash
scripts/ask_dongfeng.sh "Use Ask DongFeng in plan-guard mode. I have a superpowers-style implementation planning workflow. Create a DongFeng Packet that defines task quality rules, drift sensors, freshness checks, test-command requirements, review gates, and the next execution prompt."
```

Expected output:

- mode: `plan-guard`
- task granularity rules
- exact-file / exact-command requirements
- drift log
- yellow/red correction actions
- human gate before execution or after red drift

### 3. Control A Long Spike

Use when exploration might become an endless research loop.

```bash
scripts/ask_dongfeng.sh "Use Ask DongFeng in spike-control mode. Goal: compare approaches for turning messy product notes into MVP specs. Define spike questions, time/depth budget, repeated-experiment check, forced verdict gate, and next action."
```

Expected output:

- mode: `spike-control`
- 2-5 spike questions
- time/depth budget
- repeated-spike detection
- verdict format
- stop condition

## Long Tasks

Ask DongFeng can help long tasks succeed without repeated human reminders only if the task is split into controlled stages.

Good long-task shape:

```text
Ask DongFeng Packet
  -> approved spec / plan / spike
  -> execution by Hermes, Codex, Claude Code, or another tool
  -> sensors collect evidence
  -> comparators classify green/yellow/red
  -> controllers correct drift
  -> human gate before irreversible actions
```

Main difficulties:

- context drift: the agent forgets earlier constraints
- scope creep: the task quietly becomes larger
- weak sensors: nobody checks whether output is still correct
- missing stop rules: research or planning never ends
- tool mismatch: the selected execution tool cannot do required file, terminal, web, or review actions
- over-autonomy: the agent changes code, publishes, deletes, or spends money without a gate

What Ask DongFeng can do:

- turn repeated human reminders into explicit checks
- set yellow/red thresholds before execution
- define what the next agent must produce
- force review before irreversible actions
- make long work restartable because the packet records state, gates, and next action

What it cannot guarantee:

- fully autonomous correctness on high-risk work
- no need for human review
- perfect execution when tools, credentials, or environment are missing
- safe irreversible actions without approval

Practical rule: let Ask DongFeng reduce babysitting, not remove accountability.

## Claude Code, Codex, DeepSeek, And Other Tools

Ask DongFeng is model-agnostic. It is a skill package and prompt workflow, not a model provider.

You can use it with:

- Hermes as the primary target
- Codex / OpenAI Skills by copying the repo into the local skills directory
- Claude / Claude Code by copying the repo into `.claude/skills` or `$HOME/.claude/skills`
- DeepSeek-backed Claude Code workflows if Claude Code is configured to use that provider or if your wrapper can read `SKILL.md`

The important distinction:

- Ask DongFeng decides the operating packet.
- Claude Code / Codex / Hermes / DeepSeek-backed tools execute or continue the work.

Recommended handoff:

```text
Use Ask DongFeng to produce a DongFeng Packet.
Then give the Packet to Claude Code / Codex / Hermes and ask it to execute only the approved next action.
Do not let the execution tool skip review gates.
```

## Keep It Simple

If the full packet feels too heavy, ask for one of these:

```text
Use Ask DongFeng. Give me only: mode, decision, execution contract, and next prompt.
```

```text
Use Ask DongFeng. Print only the control-artifact YAML.
```

```text
Use Ask DongFeng in review-gate mode. Decide green/yellow/red and list required fixes only.
```
