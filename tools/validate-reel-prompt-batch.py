#!/usr/bin/env python3
"""Validate Mitozz reel prompt batches against hard-lock workflow rules."""

from __future__ import annotations

import argparse
import json
import sys
from pathlib import Path
from typing import Iterable


FULL_BLEED_TERMS = (
    "full-bleed",
    "white bars",
    "blank bars",
    "letterboxing",
    "pillarboxing",
    "floating card layout",
    "inset image inside vertical canvas",
    "blank top padding",
    "blank bottom padding",
)

BOTTLE_LOCK_TERMS = (
    "locked bottle workflow",
    "real bottle design intact",
    "do not redesign",
    "do not repaint",
    "do not recolor",
    "do not relabel",
)

BOTTLE_NEGATIVE_TERMS = (
    "white bottle",
    "white cap",
    "unreadable label",
)

LOCKED_BOTTLE_WORKFLOW = (
    "brand/references/business-context/visual/Mitozz Locked Bottle Workflow.md"
)
BOTTLE_SIZE_SPEC = "brand/references/business-context/visual/Mitozz Bottle Size Spec.md"


def flatten_strings(value: object) -> str:
    parts: list[str] = []

    def walk(node: object) -> None:
        if isinstance(node, str):
            parts.append(node)
        elif isinstance(node, dict):
            for item in node.values():
                walk(item)
        elif isinstance(node, list):
            for item in node:
                walk(item)

    walk(value)
    return "\n".join(parts).lower()


def has_term(haystack: str, terms: Iterable[str]) -> bool:
    return any(term.lower() in haystack for term in terms)


def as_list(data: dict, key: str) -> list:
    value = data.get(key, [])
    if isinstance(value, list):
        return value
    return []


def is_bottle_led(data: dict) -> bool:
    image_references = as_list(data, "image_references")
    if any(
        isinstance(ref, dict) and ref.get("role") == "product-source"
        for ref in image_references
    ):
        return True

    text = flatten_strings(
        [
            data.get("motion_role", ""),
            data.get("topic", ""),
            data.get("notes", ""),
            data.get("composition", []),
            data.get("brand_guardrails", []),
        ]
    )
    return "bottle" in text or "product" in text


def validate_prompt(path: Path) -> tuple[list[str], list[str], dict]:
    errors: list[str] = []
    warnings: list[str] = []

    try:
        data = json.loads(path.read_text(encoding="utf-8"))
    except json.JSONDecodeError as exc:
        return [f"{path.name}: invalid JSON ({exc})"], warnings, {}

    if data.get("asset_archetype") != "reel-source-frame":
        errors.append(f"{path.name}: asset_archetype must be 'reel-source-frame'")

    if data.get("aspect_ratio") != "9:16":
        errors.append(f"{path.name}: aspect_ratio must be '9:16'")

    if not data.get("shot_id"):
        errors.append(f"{path.name}: shot_id is required")

    if not data.get("motion_role"):
        errors.append(f"{path.name}: motion_role is required")

    continuity_tokens = as_list(data, "continuity_tokens")
    if not continuity_tokens:
        errors.append(f"{path.name}: continuity_tokens must be present for reel shots")

    full_bleed_text = flatten_strings(
        [
            data.get("composition", []),
            data.get("brand_guardrails", []),
            data.get("variation_guardrails", []),
            data.get("negative_prompts", []),
            data.get("notes", ""),
        ]
    )
    if "full-bleed" not in full_bleed_text:
        errors.append(f"{path.name}: missing explicit full-bleed framing language")

    if not has_term(full_bleed_text, FULL_BLEED_TERMS[1:]):
        errors.append(
            f"{path.name}: missing rejection language for padding or letterbox failure modes"
        )

    bottle_led = is_bottle_led(data)
    reference_files = as_list(data, "reference_files")
    reference_text = flatten_strings(reference_files)
    negative_text = flatten_strings(as_list(data, "negative_prompts"))
    bottle_text = flatten_strings(
        [
            data.get("brand_guardrails", []),
            data.get("composition", []),
            data.get("variation_guardrails", []),
            data.get("notes", ""),
        ]
    )
    image_references = as_list(data, "image_references")

    if bottle_led:
        if not any(
            isinstance(ref, dict) and ref.get("role") == "product-source"
            for ref in image_references
        ):
            errors.append(f"{path.name}: bottle-led shots must include a product-source image")

        if LOCKED_BOTTLE_WORKFLOW.lower() not in reference_text:
            errors.append(
                f"{path.name}: bottle-led shots must reference Mitozz Locked Bottle Workflow.md"
            )

        if BOTTLE_SIZE_SPEC.lower() not in reference_text:
            errors.append(
                f"{path.name}: bottle-led shots must reference Mitozz Bottle Size Spec.md"
            )

        if not has_term(bottle_text, BOTTLE_LOCK_TERMS):
            errors.append(
                f"{path.name}: bottle-led shots must explicitly say the real bottle stays intact"
            )

        if "bottle size spec" not in bottle_text and "locked size spec" not in bottle_text:
            warnings.append(
                f"{path.name}: consider mentioning the bottle size spec directly in the prompt body"
            )

        missing_negative_terms = [
            term for term in BOTTLE_NEGATIVE_TERMS if term not in negative_text
        ]
        if missing_negative_terms:
            errors.append(
                f"{path.name}: missing bottle negative prompts: {', '.join(missing_negative_terms)}"
            )

    return errors, warnings, data


def validate_batch(data_by_path: list[tuple[Path, dict]]) -> tuple[list[str], list[str]]:
    errors: list[str] = []
    warnings: list[str] = []

    valid_items = [(path, data) for path, data in data_by_path if data]
    if not valid_items:
        return errors, warnings

    shot_positions: dict[int, Path] = {}
    shot_ids: dict[str, Path] = {}

    for path, data in valid_items:
        shot_position = data.get("shot_position")
        if isinstance(shot_position, int):
            if shot_position in shot_positions:
                errors.append(
                    f"duplicate shot_position {shot_position}: {shot_positions[shot_position].name} and {path.name}"
                )
            else:
                shot_positions[shot_position] = path
        else:
            errors.append(f"{path.name}: shot_position must be an integer")

        shot_id = data.get("shot_id")
        if isinstance(shot_id, str):
            if shot_id in shot_ids:
                errors.append(
                    f"duplicate shot_id {shot_id}: {shot_ids[shot_id].name} and {path.name}"
                )
            else:
                shot_ids[shot_id] = path

    if shot_positions:
        expected = list(range(1, len(shot_positions) + 1))
        actual = sorted(shot_positions)
        if actual != expected:
            warnings.append(
                f"shot positions are not contiguous from 1..{len(shot_positions)}: {actual}"
            )

    return errors, warnings


def main() -> int:
    parser = argparse.ArgumentParser(
        description="Validate one or more Mitozz reel prompt JSON files."
    )
    parser.add_argument("paths", nargs="+", help="Prompt JSON files or glob patterns")
    args = parser.parse_args()

    resolved_paths: list[Path] = []
    for raw_path in args.paths:
        matches = sorted(Path().glob(raw_path))
        if matches:
            resolved_paths.extend(path for path in matches if path.is_file())
            continue

        path = Path(raw_path)
        if path.is_file():
            resolved_paths.append(path)
        else:
            print(f"error: no files matched {raw_path}", file=sys.stderr)
            return 2

    unique_paths = sorted({path.resolve() for path in resolved_paths})
    all_errors: list[str] = []
    all_warnings: list[str] = []
    data_by_path: list[tuple[Path, dict]] = []

    for path in unique_paths:
        errors, warnings, data = validate_prompt(path)
        all_errors.extend(errors)
        all_warnings.extend(warnings)
        data_by_path.append((path, data))

    batch_errors, batch_warnings = validate_batch(data_by_path)
    all_errors.extend(batch_errors)
    all_warnings.extend(batch_warnings)

    if all_errors:
        print("FAILED")
        for error in all_errors:
            print(f"- {error}")
        if all_warnings:
            print("WARNINGS")
            for warning in all_warnings:
                print(f"- {warning}")
        return 1

    print("PASS")
    for path in unique_paths:
        print(f"- {path}")

    if all_warnings:
        print("WARNINGS")
        for warning in all_warnings:
            print(f"- {warning}")

    return 0


if __name__ == "__main__":
    raise SystemExit(main())
