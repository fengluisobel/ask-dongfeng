#!/usr/bin/env python3
"""Validate the minimal structure of the Ask DongFeng skill package."""

from __future__ import annotations

import argparse
import re
import sys
from pathlib import Path


ALLOWED_KEYS = {"name", "description", "license", "metadata"}
REQUIRED_KEYS = {"name", "description"}
REFERENCED_FILES = [
    "references/control-framework.md",
    "references/artifact-schema.md",
    "references/review-questions.md",
    "references/examples.md",
    "scripts/validate_artifact.py",
]


def extract_frontmatter(text: str) -> str:
    match = re.match(r"(?s)^---\s*\n(.*?)\n---\s*\n", text)
    if not match:
        raise ValueError("missing YAML frontmatter")
    return match.group(1)


def top_level_keys(frontmatter: str) -> list[str]:
    keys: list[str] = []
    for line in frontmatter.splitlines():
        if not line or line.startswith(" ") or line.startswith("\t") or line.startswith("#"):
            continue
        match = re.match(r"^([A-Za-z0-9_-]+)\s*:", line)
        if match:
            keys.append(match.group(1))
    return keys


def validate(skill_path: Path) -> tuple[list[str], list[str]]:
    errors: list[str] = []
    warnings: list[str] = []

    text = skill_path.read_text(encoding="utf-8")
    try:
        frontmatter = extract_frontmatter(text)
    except ValueError as exc:
        return [str(exc)], warnings

    keys = top_level_keys(frontmatter)
    seen = set(keys)

    for key in REQUIRED_KEYS - seen:
        errors.append(f"missing required frontmatter key: {key}")

    for key in seen - ALLOWED_KEYS:
        errors.append(f"unexpected frontmatter key: {key}")

    root = skill_path.parent
    for rel_path in REFERENCED_FILES:
        if rel_path in text and not (root / rel_path).exists():
            errors.append(f"referenced file not found: {rel_path}")

    if not (root / "agents" / "openai.yaml").exists():
        warnings.append("optional file missing: agents/openai.yaml")

    return errors, warnings


def main() -> int:
    parser = argparse.ArgumentParser(description="Validate a SKILL.md package.")
    parser.add_argument("skill", nargs="?", default="SKILL.md", help="Path to SKILL.md")
    args = parser.parse_args()

    skill_path = Path(args.skill)
    errors, warnings = validate(skill_path)

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
