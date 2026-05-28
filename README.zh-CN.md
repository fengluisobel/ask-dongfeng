# Ask DongFeng

[![CI](https://github.com/fengluisobel/ask-dongfeng/actions/workflows/ci.yml/badge.svg)](https://github.com/fengluisobel/ask-dongfeng/actions/workflows/ci.yml)

[English](./README.md) | 简体中文

Ask DongFeng 是一个以 Hermes 为主目标的 skill，用来把模糊目标、产品想法、工作流或项目系统，变成可审查的工程控制闭环。

30 秒说明：

- 普通 planning 负责说“要做什么”。
- Ask DongFeng 负责说“怎么发现跑偏、什么时候纠偏、哪里必须让人来拍板”。
- 它的核心输出是 `control-artifact`，适合放在 spec、implementation plan、code review、workflow design 之前。

核心闭环：

```text
模糊目标
  -> Ask DongFeng
  -> control-artifact
  -> validator + 人工审查
  -> spec / plan / code / workflow
```

## 它输出什么

Ask DongFeng 输出一个 `control-artifact`，通常包含：

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

适用场景不是“我需要更多任务列表”，而是“这件事如果没有观察、比较、纠偏，很容易悄悄跑偏”。

## 5 分钟快速评估

1. 先看样例：[examples/sample-control-artifact.yaml](./examples/sample-control-artifact.yaml)
2. 运行校验器：

   ```bash
   python scripts/validate_artifact.py examples/sample-control-artifact.yaml
   ```

3. 看下面任意一个 prompt，判断它是否适合做你现有 spec / plan 工作流的上游控制框架。

## 快速开始

Hermes 是主目标平台。

```bash
git clone https://github.com/fengluisobel/ask-dongfeng.git && cd ask-dongfeng
SKILL_HOME="${HERMES_HOME:-$HOME/.hermes}/skills/software-development/ask-dongfeng"; mkdir -p "$SKILL_HOME"; cp -a SKILL.md references scripts agents "$SKILL_HOME/"
hermes chat --skills ask-dongfeng
```

验证安装：

```bash
hermes skills list --source local --enabled-only | grep ask-dongfeng
```

一次性调用示例：

```bash
hermes chat --skills ask-dongfeng -q "Use Ask DongFeng to turn this goal into a control loop: build an open-source Hermes skill that turns fuzzy product ideas into reviewable MVP specs."
```

## 兼容性

这个仓库遵循常见的 `SKILL.md + references/ + scripts/ + agents/` 结构，因此不只可以给 Hermes 用。

### Hermes

安装到本地 Hermes skill 目录：

```bash
SKILL_HOME="${HERMES_HOME:-$HOME/.hermes}/skills/software-development/ask-dongfeng"
mkdir -p "$SKILL_HOME"
cp -a SKILL.md references scripts agents "$SKILL_HOME/"
hermes chat --skills ask-dongfeng
```

### Codex / OpenAI Skills

作为本地 Codex skill 安装：

```bash
mkdir -p "${CODEX_HOME:-$HOME/.codex}/skills"
cp -a . "${CODEX_HOME:-$HOME/.codex}/skills/ask-dongfeng"
```

然后让 Codex 使用 `ask-dongfeng` 做 control-loop planning。

### Claude / Claude Code

作为个人 Claude skill 安装：

```bash
mkdir -p "$HOME/.claude/skills"
cp -a . "$HOME/.claude/skills/ask-dongfeng"
```

或者作为项目级 skill：

```bash
mkdir -p .claude/skills
cp -a /path/to/ask-dongfeng .claude/skills/ask-dongfeng
```

Claude 可以直接使用说明部分；Python 校验脚本属于可选项，取决于运行环境是否允许执行脚本。

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

### 2. superpowers 风格 writing-plans

```text
Use Ask DongFeng to review a superpowers-style writing-plans workflow.

Context:
The workflow decomposes implementation into bite-sized tasks, exact files, test commands, and commit steps.

Risk:
It can produce good plans, but it may not detect when execution drifts from the plan over time.

Output a control-artifact and explain what Ask DongFeng adds beyond ordinary planning.
```

### 3. spike / 西西弗斯循环控制

```text
Use Ask DongFeng to control a spike workflow.

Context:
A spike is a disposable experiment: decompose -> research -> build -> verdict.

Risk:
The workflow can become an endless "needs more investigation" loop.

Model this as a control loop. Focus on stopping rules, repeated-experiment detection, verdict gates, and system review.
```

## 校验器

仓库里有两个轻量校验器。

校验生成出的 control artifact：

```bash
python scripts/validate_artifact.py path/to/artifact.md
```

校验 skill 包结构本身：

```bash
python scripts/validate_skill.py SKILL.md
```

`validate_artifact.py` 会检查：

- 是否缺 `controlled_object`
- 是否缺 `system_boundary`
- 是否缺 `variables`
- 是否缺 `sensors`
- 是否缺 `comparators`
- 是否缺 `controllers`
- 是否缺 `feedback_schedule`
- 是否缺 `human_review_gates`
- 是否缺 `risks`
- 是否缺 `next_actions`

它还会提示：

- comparator 是否缺 `green/yellow/red`
- controller 是否缺 `trigger/action`
- feedback 是否缺 `action / parameter / system` 三层

`validate_skill.py` 会检查：

- YAML frontmatter 是否存在
- 是否有必需的 `name` 和 `description`
- 是否有不该出现的顶层 key
- `SKILL.md` 里引用的 bundled files 是否真实存在

这两个脚本都只做保守的结构检查，不负责判断“策略是否高明”。

## 仓库结构

```text
ask-dongfeng/
├── .github/
│   └── workflows/
│       └── ci.yml
├── agents/
│   └── openai.yaml
├── examples/
│   └── sample-control-artifact.yaml
├── references/
│   ├── artifact-schema.md
│   ├── control-framework.md
│   ├── examples.md
│   └── review-questions.md
├── scripts/
│   ├── validate_artifact.py
│   └── validate_skill.py
├── LICENSE
├── README.md
├── README.zh-CN.md
└── SKILL.md
```

## 边界

这个仓库有意保持轻量。

不包含：

- backend
- SaaS 产品
- database
- automatic code generation
- 超出 control-loop framing 本身的大规模 workflow automation

## License

MIT
