---
name: mitozz-content-calendar
description: Plan and draft the monthly Mitozz Japan Instagram content calendar. Use when the user asks to create, extend, or revise a monthly content calendar for Mitozz across feed, reels, and stories based on existing brand strategy, audience research, and prior calendars.
---

# Mitozz Monthly Content Calendar

Use this skill to create or update the monthly Instagram content calendar for Mitozz in a way that downstream skills can reliably consume.

## Quick Start

When the user asks for a monthly plan:

1. Identify the target month and year.
2. Read the most relevant audience, strategy, and visual inputs.
3. Infer pillars, cadence, and formats using the latest calendar as the baseline.
4. Draft a new monthly calendar in CSV-style tabular form with one row per content item.
5. Save it under `brand/references/business-context/content-planning/`.

## Purpose

Create a structured, repeatable monthly content plan that:

- aligns with documented audience personas and market research
- reflects current brand strategy, voice, and visual direction
- mirrors and evolves the existing calendar format and guidelines
- produces a clear calendar that downstream skills can use to generate creatives and prompts

## Inputs To Read

Prefer these inputs when available:

1. Audience
   - `brand/references/business-context/audience/Mitozz Japan Customer Personas.docx.pdf`
   - `brand/references/business-context/audience/Target audience & Market Analysis deep research for Mitozz Japan (1).pdf`
2. Strategy and brand
   - `brand/references/business-context/strategy/Mitozz Japan Digital Marketing Strategy.docx.pdf`
   - `brand/references/business-context/strategy/Mitozz JP Brand Overview (1).pdf`
   - `brand/references/business-context/strategy/Mitozz Japan Brand Voice And Messaging Guidelines.docx.pdf`
   - any other relevant PDF in `brand/references/business-context/strategy/`
3. Visual direction
   - `brand/references/business-context/visual/Brand Visual Direction.pdf`
   - `brand/references/business-context/visual/Brand Visual Direction.md`
4. Existing calendars and guidelines
   - `brand/references/business-context/content-planning/Mitozz Instagram Content Calendar - 2026 - March.csv`
   - `brand/references/business-context/content-planning/Internal Guideline Snippet — Organic Instagram Copy & Content Calendar (Mitozz Japan).pdf`

If a calendar for the requested month already exists, treat the task as a revision instead of a fresh plan.

## Output Format

Default to a CSV-compatible table with these columns:

- `Publish Date`
- `Day`
- `Format`
- `Working Title / Topic`
- `Content Pillar`
- `Objective`
- `Primary Persona`
- `Hook / Angle`
- `CTA`
- `Caption Status`
- `Creative Status`
- `Asset Link`
- `Notes`

When stories should be planned alongside feed posts, include a separate section or clearly tagged rows.

## Planning Workflow

1. Clarify scope.
2. Derive pillars and themes from strategy and audience docs.
3. Set cadence from the prior calendar.
4. Populate the month with clear topics, personas, objectives, hooks, and CTAs.
5. Check alignment before saving.

## Calendaring Guidelines

- Keep titles short but specific.
- Use personas and pillars exactly as defined in the research when possible.
- Use neutral, calendar-friendly language.
- Include at least one clear CTA and objective per post.
- Note holidays or key launches in `Notes` when relevant.

## Brand-Consistency Checklist

Before presenting a calendar, verify:

- The mix of posts reflects documented pillars and personas.
- The tone of hooks and CTAs matches the brand voice guidelines.
- The planned formats make sense for the current visual direction.
- The month supports the Steel Light system: airy education cards, cool product-light posts, and warmer trust-led moments.
- There is a clear relationship between feed posts and supporting stories.
- Educational, reassurance, proof, and soft-conversion content are balanced.

## Saving And Naming

- Save new calendars under `brand/references/business-context/content-planning/`
- Use `Mitozz Instagram Content Calendar - [YEAR] - [MONTH].csv`

## Input And Output

- Output folder: `brand/references/business-context/content-planning/`
- Downstream reader: `mitozz-creatives-director`

## Examples

- `brand/references/business-context/content-planning/Mitozz Instagram Content Calendar - 2026 - March.csv`
