# Ask DongFeng

[![CI](https://github.com/fengluisobel/ask-dongfeng/actions/workflows/ci.yml/badge.svg)](https://github.com/fengluisobel/ask-dongfeng/actions/workflows/ci.yml)

[English](./README.md) | 简体中文

Ask DongFeng 是一个 Hermes-first 框架式 skill，用来把模糊目标、产品想法、计划、spike 或审查决策，转成可执行的控制包。

30 秒说明：

- 普通计划回答“下一步做什么”。
- Ask DongFeng 先选择合适的 operating mode，再回答“如何观察跑偏、什么时候纠偏、哪里必须人工确认”。
- 输出是一个 `DongFeng Packet`：mode、boundary、decision、`control-artifact`、execution contract、review gates 和下一步 prompt/action。

核心闭环：

```text
模糊目标
  -> Ask DongFeng
  -> DongFeng Packet
  -> validator + 人工审查
  -> spec / plan / code / workflow
```

## 它替代或包住什么

Ask DongFeng 的目标是替代或包住 spec、planning、superpowers-style writing-plans、spike、review-gate 这些上游工作流。

| 现有工作流需求 | Ask DongFeng mode | 输出 |
|---|---|---|
| 模糊想法 -> 可审查 spec | `intent-to-spec` | MVP/spec contract + control artifact |
| implementation plan 需要防跑偏 | `plan-guard` | drift sensors、freshness checks、review gates |
| 实验可能变成无限研究 | `spike-control` | time/depth budget、repetition check、verdict gate |
| 需要 go/no-go 决策 | `review-gate` | green/yellow/red decision + required fixes |
| GitHub/user feedback 要快速迭代 | `iteration-loop` | intake、triage、repeated-topic controller、release gate |

## 输出什么

Ask DongFeng 输出一个 `DongFeng Packet`，通常包含：

- selected operating mode
- boundary and decision
- `control-artifact`
- execution contract
- review gates
- exact next prompt or action

其中内嵌的 `control-artifact` 通常包含：

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

它适合的场景不是“我需要更多任务列表”，而是“这件事可能在执行中悄悄跑偏，需要观察、比较、纠偏和审查”。

## 5 分钟评估

1. 先看样例：[examples/sample-control-artifact.yaml](./examples/sample-control-artifact.yaml)
2. 跑 validator：

   ```bash
   python scripts/validate_artifact.py examples/sample-control-artifact.yaml
   ```

3. 再看真实 Hermes 运行记录：[examples/hermes-run-transcripts.md](./examples/hermes-run-transcripts.md)

教程：

- [docs/USAGE.md](./docs/USAGE.md)

最快的 before/after 对比：

- [examples/demo-before-after.md](./examples/demo-before-after.md)
- [examples/dongfeng-packet.md](./examples/dongfeng-packet.md)

可验证的样例 artifact：

- [examples/sample-control-artifact.yaml](./examples/sample-control-artifact.yaml)
- [examples/github-feedback-loop.yaml](./examples/github-feedback-loop.yaml)
- [examples/superpowers-writing-plans.yaml](./examples/superpowers-writing-plans.yaml)
- [examples/spike-sisyphus-loop.yaml](./examples/spike-sisyphus-loop.yaml)
- [examples/tdd-precommit-quality-system.yaml](./examples/tdd-precommit-quality-system.yaml)

## 快速开始

Hermes 是主要目标平台。

```bash
git clone https://github.com/fengluisobel/ask-dongfeng.git && cd ask-dongfeng
scripts/install_hermes.sh
hermes chat --skills ask-dongfeng
```

也可以用封装启动脚本：

```bash
scripts/ask_dongfeng.sh
scripts/ask_dongfeng.sh "Use Ask DongFeng in intent-to-spec mode: turn this idea into a DongFeng Packet: ..."
scripts/ask_dongfeng.sh --quiet "Print only the control-artifact YAML for this goal: ..."
```

验证本地安装：

```bash
hermes skills list --source local --enabled-only | grep ask-dongfeng
```

运行本地 smoke test：

```bash
scripts/smoke_hermes.sh
scripts/smoke_hermes.sh --live
```

`--live` 会通过 Hermes 真实调用模型，需要本地已经配置好 provider credentials。

如果不想运行安装脚本，也可以手动安装：

```bash
SKILL_HOME="${HERMES_HOME:-$HOME/.hermes}/skills/software-development/ask-dongfeng"
mkdir -p "$SKILL_HOME"
cp -a SKILL.md references scripts agents "$SKILL_HOME/"
```

一次性调用示例：

```bash
hermes chat --skills ask-dongfeng -q "Use Ask DongFeng to turn this goal into a control loop: build an open-source Hermes skill that turns fuzzy product ideas into reviewable MVP specs."
```

## 兼容性

Ask DongFeng 面向 Hermes 优先设计，但仓库遵循常见的 `SKILL.md + references/ + scripts/ + agents/` 结构，也可以被 Codex 或 Claude 类 agent 读取使用。

### Hermes

```bash
scripts/install_hermes.sh
hermes chat --skills ask-dongfeng
```

### Codex / OpenAI Skills

```bash
mkdir -p "${CODEX_HOME:-$HOME/.codex}/skills"
cp -a . "${CODEX_HOME:-$HOME/.codex}/skills/ask-dongfeng"
```

然后让 Codex 在控制闭环、spec 上游设计、workflow 稳定性审查等任务里使用 `ask-dongfeng`。

### Claude / Claude Code

```bash
mkdir -p "$HOME/.claude/skills"
cp -a . "$HOME/.claude/skills/ask-dongfeng"
```

Claude 可以直接使用 `SKILL.md` 和 `references/` 里的说明。Python validator 是可选增强，取决于运行环境是否允许执行脚本。

## 示例 Prompt

### 1. 模糊产品想法 -> MVP Spec

```text
Use Ask DongFeng to turn this goal into a control loop:
I want to build an open-source Hermes skill that turns fuzzy product ideas into reviewable MVP specs.

Constraints:
- skill-first, not SaaS
- no database
- no automatic code generation

Output a concise YAML control-artifact with controlled_object, system_boundary, variables, sensors, comparators, controllers, feedback_schedule, human_review_gates, risks, and next_actions.
```

样例 artifact：

- [examples/sample-control-artifact.yaml](./examples/sample-control-artifact.yaml)

### 2. Superpowers 风格 writing-plans

```text
Use Ask DongFeng to review a superpowers-style writing-plans workflow.

Context:
The workflow decomposes implementation into bite-sized tasks, exact files, test commands, and commit steps.

Risk:
It can produce good plans, but it may not detect when execution drifts from the plan over time.

Output a control-artifact and explain what Ask DongFeng adds beyond ordinary planning.
```

样例 artifact：

- [examples/superpowers-writing-plans.yaml](./examples/superpowers-writing-plans.yaml)

### 3. Spike / 西西弗斯循环控制

```text
Use Ask DongFeng to control a spike workflow.

Context:
A spike is a disposable experiment: decompose -> research -> build -> verdict.

Risk:
The workflow can become an endless "needs more investigation" loop.

Model this as a control loop. Focus on stopping rules, repeated-experiment detection, verdict gates, and system review.
```

样例 artifact：

- [examples/spike-sisyphus-loop.yaml](./examples/spike-sisyphus-loop.yaml)

### 4. GitHub 反馈闭环

```text
Use Ask DongFeng to turn this goal into a control loop:
GitHub users should quickly understand Ask DongFeng, install it, try it, and file actionable feedback that can drive fast iteration.

Constraints:
- keep the project small
- avoid SaaS
- avoid heavy process

Output a concise YAML control-artifact.
```

样例 artifact：

- [examples/github-feedback-loop.yaml](./examples/github-feedback-loop.yaml)

真实 Hermes 运行记录：

- [examples/hermes-run-transcripts.md](./examples/hermes-run-transcripts.md)

## 它比普通计划多什么

普通计划通常输出：

- 要做哪些任务
- 大概顺序是什么
- 最后怎么交付

Ask DongFeng 额外要求：

- 被控制对象是什么
- 用什么信号观察跑偏
- 什么阈值算 green / yellow / red
- 跑偏后执行什么纠偏动作
- 哪些地方必须人工审查
- action / parameter / system 三层反馈节奏是什么

## Validator

验证生成的 control artifact：

```bash
python scripts/validate_artifact.py path/to/artifact.md
```

验证 skill 包结构：

```bash
python scripts/validate_skill.py SKILL.md
```

`validate_artifact.py` 会检查核心字段是否存在，并对 comparator、controller、feedback layer 做保守提醒。它不判断策略是否高明，只检查 artifact 是否完整。

## 反馈和迭代

Ask DongFeng 使用 GitHub Issues 作为反馈闭环。

Issue 模板支持：

- 安装、validator 或 skill 包问题
- 有具体场景的功能建议
- 带真实 prompt / output excerpt 的 use-case feedback

维护者循环：

- 尽量在 48 小时内 triage 新 issue
- 按失败面打标签：install、first-run、validator、example、documentation、scope
- 重复出现的问题优先转成 example artifact、validator rule、README patch 或 `SKILL.md` 修改
- 行为变化只在 validators 和至少一次 Hermes self-test 通过后发布 patch release

这个反馈闭环本身也有 artifact：

- [examples/github-feedback-loop.yaml](./examples/github-feedback-loop.yaml)

## 边界

这个仓库有意保持轻量。

不包含：

- backend
- SaaS 产品
- database
- automatic code generation
- 超出 control-loop framing 本身的大规模 workflow automation

不适合：

- 很小、验收标准很明显的一次性任务
- 只需要 brainstorm、不需要执行闭环的讨论
- 想要直接生成代码或替代完整 spec 工具的场景
- 金融、法律、医疗或安全关键执行的自动化决策

## 仓库结构

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
|-- docs/
|   `-- USAGE.md
|-- examples/
|   |-- demo-before-after.md
|   |-- dongfeng-packet.md
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
|   |-- operating-modes.md
|   `-- review-questions.md
|-- scripts/
|   |-- ask_dongfeng.sh
|   |-- install_hermes.sh
|   |-- smoke_hermes.sh
|   |-- validate_artifact.py
|   `-- validate_skill.py
|-- LICENSE
|-- README.md
|-- README.zh-CN.md
`-- SKILL.md
```

## License

MIT
