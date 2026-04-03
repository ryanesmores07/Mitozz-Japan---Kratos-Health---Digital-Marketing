# Prompt Naming Conventions

Use prompt filenames that are easy to scan, sort, and match against calendar dates.

## Standard Pattern

- Feed: `ig-feed-YYYY-MM-DD-theme-v01.json`
- Story: `ig-story-YYYY-MM-DD-theme-v01.json`

Examples:

- `2026-03-23-feed-mitochondria-basics-v01.json`
- `2026-03-23-story-mitochondria-basics-reinforcement-v01.json`

## Why This Pattern

- `ig`: keeps all Instagram prompt files visually grouped.
- `feed` or `story`: makes the asset type obvious.
- `YYYY-MM-DD`: makes date-based lookup deterministic and sortable.
- `theme`: makes the creative intent human-readable.
- `v01`: allows deliberate variants without creating naming chaos.

## Theme Rules

- Use short kebab-case only.
- Derive the theme from the calendar topic or creative package.
- Keep it descriptive but compact.
- Good:
  - `mitochondria-basics`
  - `trust-proof`
  - `epicatechin-qa`
- Avoid:
  - very long sentence-like names
  - vague names like `post-1` or `story-final`

## Create vs Update

- If the same format, date, and theme already exist, update that file.
- Only create `v02`, `v03`, etc. when the variant is meaningfully different.
- Do not create a new version only because of minor wording or small visual refinements.

## Date Range Requests

For a date range request, create one file per asset/date combination using the same pattern.

Example:

- `2026-03-23-feed-mitochondria-basics-v01.json`
- `ig-feed-2026-03-27-epicatechin-qa-v01.json`
- `2026-03-23-story-mitochondria-basics-reinforcement-v01.json`

## Execution Lookup Rule

The execution skill should search by:

- format first,
- date second,
- theme third,
- version last.

That makes requests like `Generate the March 23 feed creatives` predictable.

