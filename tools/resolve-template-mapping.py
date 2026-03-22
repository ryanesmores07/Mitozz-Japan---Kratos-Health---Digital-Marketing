#!/usr/bin/env python3

import argparse
import csv
import json
import sys
from pathlib import Path


def normalize_format(section: str, format_value: str) -> str:
    section_value = section.strip().lower()
    format_clean = format_value.strip()
    if section_value == "story" and not format_clean:
        return "Story"
    return format_clean


def load_rules(path: Path) -> dict:
    return json.loads(path.read_text(encoding="utf-8"))


def add_resolution(resolution: dict, incoming: dict, source: str) -> None:
    if not incoming:
        return
    for key in ("template_set", "slide_blueprint"):
        value = incoming.get(key)
        if value:
            resolution[key] = value
    resolution["applied_rules"].append({"source": source, **incoming})


def resolve_mapping(row: dict, rules: dict) -> dict:
    section = row.get("Section", "").strip()
    format_value = normalize_format(section, row.get("Format", ""))
    content_pillar = row.get("Content Pillar", "").strip()
    objective = row.get("Objective", "").strip()
    persona = row.get("Primary Persona", "").strip()

    defaults = rules.get("defaults", {})
    if section.lower() == "story":
        base = defaults.get("story", {})
    elif format_value == "Carousel":
        base = defaults.get("carousel", {})
    elif format_value == "Reel":
        base = defaults.get("reel", {})
    elif format_value == "Static Post":
        base = defaults.get("static_post", {})
    else:
        base = defaults.get("carousel", {})

    resolution = {
        "template_set": base.get("template_set", ""),
        "slide_blueprint": base.get("slide_blueprint", ""),
        "preferred_support_set": "",
        "applied_rules": [],
        "resolved_from": {
            "Section": section,
            "Format": format_value,
            "Content Pillar": content_pillar,
            "Objective": objective,
            "Primary Persona": persona,
        },
    }

    if base:
        resolution["applied_rules"].append({"source": "defaults", **base})

    story_mode = section.lower() == "story"
    resolution_order = list(rules.get("resolution_order", []))

    if story_mode:
        resolution_order = [
            source_name
            for source_name in resolution_order
            if source_name in {"format_mapping", "objective_overrides"}
        ]

    for source_name in resolution_order:
        source_rules = rules.get(source_name, {})
        lookup_value = ""
        if source_name == "format_mapping":
            lookup_value = format_value
        elif source_name == "content_pillar_mapping":
            lookup_value = content_pillar
        elif source_name == "objective_overrides":
            lookup_value = objective
        add_resolution(resolution, source_rules.get(lookup_value), source_name)

    persona_rule = rules.get("persona_overrides", {}).get(persona, {})
    if persona_rule:
        resolution["preferred_support_set"] = persona_rule.get("preferred_support_set", "")
        resolution["applied_rules"].append({"source": "persona_overrides", **persona_rule})

    return resolution


def row_from_csv(csv_path: Path, row_number: int) -> dict:
    with csv_path.open(newline="", encoding="utf-8-sig") as handle:
        reader = csv.DictReader(handle)
        for index, row in enumerate(reader, start=1):
            if index == row_number:
                return row
    raise ValueError(f"Row {row_number} not found in {csv_path}")


def build_row_from_args(args: argparse.Namespace) -> dict:
    return {
        "Section": args.section or "",
        "Format": args.format_value or "",
        "Content Pillar": args.content_pillar or "",
        "Objective": args.objective or "",
        "Primary Persona": args.persona or "",
    }


def parser() -> argparse.ArgumentParser:
    command = argparse.ArgumentParser(
        description="Resolve Mitozz template mapping from existing calendar strategy fields."
    )
    command.add_argument(
        "--rules",
        default="brand/references/business-context/visual/template-mapping-rules.json",
        help="Path to the template mapping rules JSON.",
    )
    command.add_argument("--csv", help="Path to a calendar CSV file.")
    command.add_argument("--row", type=int, help="1-based data row number inside the CSV.")
    command.add_argument("--row-json", help="Raw JSON object representing one calendar row.")
    command.add_argument("--section", help="Fallback row field: Section.")
    command.add_argument("--format", dest="format_value", help="Fallback row field: Format.")
    command.add_argument("--content-pillar", help="Fallback row field: Content Pillar.")
    command.add_argument("--objective", help="Fallback row field: Objective.")
    command.add_argument("--persona", help="Fallback row field: Primary Persona.")
    command.add_argument("--pretty", action="store_true", help="Pretty-print the output JSON.")
    return command


def main() -> int:
    args = parser().parse_args()
    rules = load_rules(Path(args.rules))

    if args.row_json:
        row = json.loads(args.row_json)
    elif args.csv and args.row:
        row = row_from_csv(Path(args.csv), args.row)
    else:
        row = build_row_from_args(args)

    resolution = resolve_mapping(row, rules)
    json.dump(resolution, sys.stdout, ensure_ascii=False, indent=2 if args.pretty else None)
    sys.stdout.write("\n")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
