#!/usr/bin/env bash
set -euo pipefail

usage() {
  cat <<'EOF'
Run a local Hermes smoke test for Ask DongFeng.

Usage:
  scripts/smoke_hermes.sh [--install] [--live] [--timeout SECONDS]

Checks:
  1. Hermes CLI exists.
  2. `hermes skills list --source local --enabled-only` includes ask-dongfeng.
  3. With --live, run one short Hermes prompt and require `control-artifact` in output.

Options:
  --install          Run scripts/install_hermes.sh before smoke testing.
  --live             Run a real model call with `hermes --skills ask-dongfeng -z`.
  --timeout SECONDS  Timeout for the live model call. Default: 180.
EOF
}

install_first=0
live=0
timeout_seconds=180

while [ "$#" -gt 0 ]; do
  case "$1" in
    --install)
      install_first=1
      ;;
    --live)
      live=1
      ;;
    --timeout)
      if [ "$#" -lt 2 ]; then
        echo "--timeout requires a value" >&2
        exit 2
      fi
      timeout_seconds="$2"
      shift
      ;;
    -h|--help)
      usage
      exit 0
      ;;
    *)
      echo "Unknown option: $1" >&2
      usage >&2
      exit 2
      ;;
  esac
  shift
done

script_dir="$(CDPATH= cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
repo_root="$(CDPATH= cd -- "$script_dir/.." && pwd)"

if command -v python3 >/dev/null 2>&1; then
  python_bin="python3"
elif command -v python >/dev/null 2>&1; then
  python_bin="python"
else
  echo "Python is required to validate the live smoke output, but neither python3 nor python was found." >&2
  exit 1
fi

if ! command -v hermes >/dev/null 2>&1; then
  echo "Hermes CLI was not found on PATH." >&2
  exit 1
fi

if [ "$install_first" -eq 1 ]; then
  "$repo_root/scripts/install_hermes.sh"
fi

skills_output="$(hermes skills list --source local --enabled-only)"
printf '%s\n' "$skills_output"

if ! grep -q "ask-dongfeng" <<<"$skills_output"; then
  echo "ask-dongfeng was not found in enabled local Hermes skills." >&2
  echo "Try: scripts/install_hermes.sh" >&2
  exit 1
fi

echo "PASS: Hermes can discover ask-dongfeng."

if [ "$live" -eq 0 ]; then
  echo "Skip live model call. Re-run with --live to test generated output."
  exit 0
fi

prompt='Use Ask DongFeng. Print only a tiny YAML control artifact. First line must be exactly: type: control-artifact. Goal: smoke test. Include non-empty controlled_object, system_boundary with out_of_scope, variables with controlled/observed/control/disturbance/lagging, one sensor, one comparator with green/yellow/red, one controller with trigger/action, feedback_schedule with action/parameter/system layers, one human_review_gate, risks, and next_actions.'

if command -v timeout >/dev/null 2>&1; then
  live_output="$(timeout "${timeout_seconds}s" hermes --skills ask-dongfeng -z "$prompt")"
else
  live_output="$(hermes --skills ask-dongfeng -z "$prompt")"
fi

printf '%s\n' "$live_output"

if ! grep -qi "control-artifact" <<<"$live_output"; then
  echo "Live Hermes smoke output did not contain control-artifact." >&2
  exit 1
fi

"$python_bin" "$repo_root/scripts/validate_artifact.py" <<<"$live_output"

echo "PASS: Live Hermes smoke output contained control-artifact."
