# Examples

These examples are intentionally centered on agent workflow skills rather than business domains. Ask DongFeng is most useful when it wraps a good local workflow skill with sensors, comparators, controllers, feedback, and review gates.

## Example 1: Superpowers-Style Writing Plans

Goal:

```text
Keep a writing-plans workflow from producing vague, oversized, or unexecutable implementation plans.
```

Control loop:

| Component | Example |
|---|---|
| Controlled object | One `writing-plans` run, from requirement intake to saved implementation plan |
| Controlled variables | task granularity, file-path precision, command executability, code-example completeness |
| Sensors | plan self-checklist, vague-word scan, path existence check, command dry-run notes |
| Comparators | green: every task has exact files/tests/commands; yellow: 1-2 vague items; red: oversized task or missing test command |
| Controllers | split oversized tasks, replace vague verbs with file-specific steps, add expected test output, require human plan approval |
| Feedback | per-task plan check, per-plan review, periodic review of planning template |

What Ask DongFeng adds:

```text
writing-plans defines what a good implementation plan looks like.
Ask DongFeng defines how to detect and correct plan drift.
```

## Example 2: Spike / Sisyphus-Loop Control

Goal:

```text
Prevent disposable experiments from turning into endless "needs more investigation" loops.
```

Control loop:

| Component | Example |
|---|---|
| Controlled object | One spike cycle, from falsifiable hypothesis to verdict |
| Controlled variables | verdict clarity, time containment, assumption coverage, learning density |
| Sensors | time-burn ratio, verdict audit, scope-drift log, duplicate-spike check |
| Comparators | green: binary verdict with evidence; yellow: evidence incomplete; red: no verdict, timeout, or repeated experiment |
| Controllers | force verdict on timeout, compress scope, block redundant spike, terminate repeated inconclusive spike chain |
| Feedback | per-spike postmortem, every 3 spikes parameter review, monthly exploration strategy review |

What Ask DongFeng adds:

```text
spike teaches how to explore.
Ask DongFeng adds stopping rules, repetition checks, and human gates so the stone does not roll forever.
```

## Example 3: TDD + Pre-Commit Review Quality System

Goal:

```text
Turn TDD and pre-commit code review from local action checks into a long-running engineering quality control system.
```

Control loop:

| Component | Example |
|---|---|
| Controlled object | Agent coding quality system, combining RED-GREEN-REFACTOR with pre-commit verification |
| Controlled variables | TDD discipline rate, commit safety score, regression count, auto-fix cycle count |
| Sensors | TDD cycle log, reviewer JSON verdict, test-suite health data, monthly production bug data |
| Comparators | green: tests fail first and pass later, no regressions; yellow: suggestions only; red: security issue, logic error, new regression, repeated non-TDD work |
| Controllers | block non-TDD code, run auto-fix then escalate, adjust reviewer prompt/model, split oversized diffs |
| Feedback | per task/test cycle, weekly quality parameter review, monthly system-health review |

What Ask DongFeng adds:

```text
TDD and review skills control one task or one commit.
Ask DongFeng controls whether the whole quality system remains reliable over time.
```
