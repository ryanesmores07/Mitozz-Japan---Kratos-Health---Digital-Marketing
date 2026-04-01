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
- the chosen `visual_engine` and `source_lane` are explicitly locked
- the Japanese copy is clean UTF-8
- the references match the intended asset type
- the asset is using the design-first compositor when typography or layout precision matters

### 2. First-Pass Review

Review the first render or generated batch against:

- brand fit
- hierarchy clarity
- spacing and whitespace discipline
- strategic use of vertical space, especially in Stories
- top / center / bottom balance when the format benefits from it
- headline tracking and optical rhythm on large Japanese type
- per-column centering when horizontal strips or multi-part bars are used
- Japanese line-break quality
- module alignment and optical centering
- semantic clarity of badges, bands, chips, and side labels
- absence of internal workflow scaffolding in on-canvas copy
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

## Module Alignment And Semantics Lock

For strips, chips, numbered rails, row tags, selector labels, and closing-note cards:

- centered labels must be optically centered both horizontally and vertically
- if a narrow band cannot hold meaningful viewer-facing text cleanly, redesign or simplify it before approval
- if a module is about named categories, prefer the category name itself over abstract numbering unless sequence is the point
- do not keep placeholder markers such as `Q`, `Set`, or other template residue in production output
- do not let a close card inherit body-slide alignment if the component is meant to read as a centered closing note

If a module looks unfinished, misaligned, or semantically empty, the asset is not ready yet.

## Rejection Triggers

Reject or refine the asset if:

- it looks like a generic first draft instead of a finished Mitozz asset
- one slide feels heavier, darker, glossier, or tighter than the rest of the batch
- a Japanese line break looks browser-made instead of designed
- internal scaffolding such as `Set` names, English workflow labels, or placeholder badge text appears on-canvas
- a side band, chip, or badge is empty, meaningless, or visually leftover
- a centered label is visibly off-center inside its module
- the frame has a large dead zone that is not doing compositional work
- the frame is heavily top-loaded when a middle or bottom zone should clearly be helping
- the headline line breaks are correct but the letter spacing still makes the title feel cramped
- the text in a multi-column strip is not centered inside its own column
- the same key terms are repeated across one frame without adding clarity
- the middle slide explains but does not guide the eye clearly
- the closing slide feels like another body slide instead of a resolution
- the closing-note card text feels forced, jammed, or off-center
- the CTA behavior feels added on rather than integrated into the system
- bottle truth, pack scale, or lighting integration drift

## Presentation Rule

When sharing work:

- show finalists, not raw first passes
- if a tradeoff remains, name it clearly
- if another pass would materially improve the asset, take that pass before presenting the work as final
- after rerendering a fix, verify the latest output file itself before calling the issue resolved
