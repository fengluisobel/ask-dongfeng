#!/usr/bin/env bash
set -euo pipefail

usage() {
  cat <<'EOF'
Start Ask DongFeng through Hermes.

Usage:
  scripts/ask_dongfeng.sh
  scripts/ask_dongfeng.sh "turn this idea into a DongFeng Packet: ..."
  scripts/ask_dongfeng.sh --quiet "turn this idea into a DongFeng Packet: ..."
  scripts/ask_dongfeng.sh --raw-oneshot "print only YAML for: ..."

Modes:
  no arguments   Start interactive Hermes chat with ask-dongfeng preloaded.
  prompt text    Run `hermes chat --skills ask-dongfeng -q <prompt>`.
  --quiet        Run `hermes chat --skills ask-dongfeng -Q -q <prompt>`.
  --raw-oneshot  Run `hermes --skills ask-dongfeng -z <prompt>`.
EOF
}

quiet=0
raw_oneshot=0

if [ "${1:-}" = "-h" ] || [ "${1:-}" = "--help" ]; then
  usage
  exit 0
fi

if [ "${1:-}" = "--quiet" ] || [ "${1:-}" = "-Q" ]; then
  quiet=1
  shift
elif [ "${1:-}" = "--raw-oneshot" ] || [ "${1:-}" = "-z" ]; then
  raw_oneshot=1
  shift
fi

if ! command -v hermes >/dev/null 2>&1; then
  echo "Hermes CLI was not found on PATH." >&2
  exit 1
fi

if [ "$#" -eq 0 ]; then
  if [ "$quiet" -eq 1 ] || [ "$raw_oneshot" -eq 1 ]; then
    echo "This mode requires a prompt." >&2
    usage >&2
    exit 2
  fi
  exec hermes chat --skills ask-dongfeng
fi

prompt="$*"

if [ "$raw_oneshot" -eq 1 ]; then
  exec hermes --skills ask-dongfeng -z "$prompt"
fi

if [ "$quiet" -eq 1 ]; then
  exec hermes chat --skills ask-dongfeng -Q -q "$prompt"
fi

exec hermes chat --skills ask-dongfeng -q "$prompt"
