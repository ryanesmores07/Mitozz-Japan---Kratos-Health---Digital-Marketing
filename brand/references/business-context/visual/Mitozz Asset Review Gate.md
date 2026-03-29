# Mitozz Asset Review Gate

## Purpose

This is the mandatory internal review gate for Mitozz Instagram production.

Use it before any feed post, Story set, reel source frame, or compositor export is presented as the production version.

## Non-Negotiable Rule

- do not present a raw first pass as the final production asset
- every asset must pass one internal critique loop before promotion
- for text-led assets, Japanese line breaks are editorial decisions, not browser defaults

## Review Loop

### 1. Preflight

Before generation or rendering, confirm:

- the asset is using the correct template set or workflow
- the Japanese copy is clean UTF-8
- the references match the intended asset type
- the asset is using the design-first compositor when typography or layout precision matters

### 2. First-Pass Review

Review the first render or generated batch against:

- brand fit
- hierarchy clarity
- spacing and whitespace discipline
- Japanese line-break quality
- batch uniformity
- ending behavior or CTA quality

### 3. Repair Pass

If the issue is structural:

- fix the copy, JSON, HTML, CSS, or prompt
- rerender or regenerate only the failing asset

If the issue is systemic:

- stop and tighten the workflow input before spending more tokens

### 4. Promotion Gate

Promote only assets that pass the review.

- active output folders should contain approved assets only
- rejected or superseded versions belong in version folders or a sibling `rejected/` archive
- do not move an asset into the live production path while critique holes are still obvious

## Japanese Copy And Line-Break Lock

For covers, hooks, CTA slides, and any text-led layout:

- define headline lines by meaning unit, not by approximate character count
- define sublines explicitly when browser wrapping creates awkward rhythm
- keep particles, punctuation, and compound phrases with the line they belong to when possible
- do not let key Japanese copy depend on auto-wrap if the break quality affects polish

If a line break feels accidental, the asset is not ready yet.

## Rejection Triggers

Reject or refine the asset if:

- it looks like a generic first draft instead of a finished Mitozz asset
- one slide feels heavier, darker, glossier, or tighter than the rest of the batch
- a Japanese line break looks browser-made instead of designed
- the middle slide explains but does not guide the eye clearly
- the closing slide feels like another body slide instead of a resolution
- the CTA behavior feels added on rather than integrated into the system
- bottle truth, pack scale, or lighting integration drift

## Presentation Rule

When sharing work:

- show finalists, not raw first passes
- if a tradeoff remains, name it clearly
- if another pass would materially improve the asset, take that pass before presenting the work as final
