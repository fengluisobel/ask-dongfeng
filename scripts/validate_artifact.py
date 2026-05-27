#!/usr/bin/env python3
"""Validate Ask DongFeng control artifacts with lightweight heuristics.

The validator intentionally avoids third-party dependencies. It accepts either a
plain artifact file or a Markdown file containing a ```yaml fenced block.
"""

from __future__ import annotations

import argparse
import re
import sys
from pathlib import Path


REQUIRED_TOP_LEVEL = [
    "controlled_object",
    "system_boundary",
    "variables",
    "sensors",
    "comparators",
    "controllers",
    "feedback_schedule",
    "human_review_gates",
    "risks",
    "next_actions",
]

VARIABLE_GROUPS = ["controlled", "observed", "control", "disturbance", "lagging"]
FEEDBACK_LAYERS = ["action", "parameter", "system"]


def extract_artifact(text: str) -> str:
    match = re.search(r"```(?:ya?ml)?\s*(.*?)```", text, flags=re.IGNORECASE | re.DOTALL)
    return match.group(1).strip() if match else text.strip()


def has_top_level_key(text: str, key: str) -> bool:
    return bool(re.search(rf"(?m)^{re.escape(key)}\s*:", text))


def section_text(text: str, key: str) -> str:
    pattern = rf"(?ms)^{re.escape(key)}\s*:\s*(.*?)(?=^[A-Za-z_][A-Za-z0-9_]*\s*:|\Z)"
    match = re.search(pattern, text)
    return match.group(1).strip() if match else ""


def looks_non_empty(value: str) -> bool:
    stripped = value.strip()
    return bool(stripped and stripped not in {"[]", "{}", '""', "''"})


def validate(text: str) -> tuple[list[str], list[str]]:
    artifact = extract_artifact(text)
    errors: list[str] = []
    warnings: list[str] = []

    for key in REQUIRED_TOP_LEVEL:
        if not has_top_level_key(artifact, key):
            errors.append(f"missing top-level field: {key}")
        elif not looks_non_empty(section_text(artifact, key)):
            warnings.append(f"field appears empty: {key}")

    variables = section_text(artifact, "variables")
    for group in VARIABLE_GROUPS:
        if not re.search(rf"(?m)^\s*(?:-\s*)?{re.escape(group)}\s*:", variables):
            warnings.append(f"variables missing group: {group}")

    system_boundary = section_text(artifact, "system_boundary")
    if not re.search(r"(?m)^\s*(?:-\s*)?out_of_scope\s*:", system_boundary):
        warnings.append("system_boundary missing out_of_scope")

    comparators = section_text(artifact, "comparators")
    for level in ["green", "yellow", "red"]:
        if not re.search(rf"\b{level}\b\s*:", comparators, flags=re.IGNORECASE):
            warnings.append(f"comparators missing {level} threshold")

    controllers = section_text(artifact, "controllers")
    for field in ["trigger", "action"]:
        if not re.search(rf"\b{field}\b\s*:", controllers, flags=re.IGNORECASE):
            warnings.append(f"controllers missing {field}")

    feedback = section_text(artifact, "feedback_schedule")
    for layer in FEEDBACK_LAYERS:
        if not re.search(rf"\b{layer}\b", feedback, flags=re.IGNORECASE):
            warnings.append(f"feedback_schedule missing {layer} layer")

    if errors:
        return errors, warnings
    return errors, warnings


def main() -> int:
    parser = argparse.ArgumentParser(description="Validate an Ask DongFeng control artifact.")
    parser.add_argument("artifact", nargs="?", help="Artifact file path. Reads stdin when omitted.")
    args = parser.parse_args()

    if args.artifact:
        text = Path(args.artifact).read_text(encoding="utf-8")
    else:
        text = sys.stdin.read()

    errors, warnings = validate(text)

    if errors:
        print("FAIL")
        for item in errors:
            print(f"ERROR: {item}")
    else:
        print("PASS")

    for item in warnings:
        print(f"WARN: {item}")

    return 1 if errors else 0


if __name__ == "__main__":
    raise SystemExit(main())
