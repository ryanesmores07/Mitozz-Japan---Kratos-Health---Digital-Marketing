# Mitozz Asset Review Gate

## Purpose

This is the mandatory internal review gate for Mitozz Instagram production.

Use it before any feed post, Story set, reel source frame, or compositor export is presented as the production version.

## Non-Negotiable Rule

- do not present a raw first pass as the final production asset
- every asset must pass one internal critique loop before promotion
- for text-led assets, Japanese line breaks are editorial decisions, not browser defaults
- for feeds and reels, visual approval is incomplete until a prepared posting caption and hashtag set are traceable to the approved asset

## Review Loop

### 1. Preflight

Before generation or rendering, confirm:

- the asset is using the correct template set or workflow
- the chosen `visual_engine` and `source_lane` are explicitly locked
- the creative package explicitly names the `anchor_set`, `dominant_set_behavior`, and `variation_strategy`
- the creative package explicitly names the `variant_scope` when more than one version exists for the same post
- feed or reel assets have a traceable posting-copy owner and prepared posting-copy output
- the Japanese copy is clean UTF-8
- the references match the intended asset type
- the asset is using the design-first compositor when typography or layout precision matters
- all frontend-visible copy and image-placement decisions are explicitly owned by the approved creative direction rather than being improvised in execution
- if the Story is reinforcing an approved feed family, the renderer is inheriting that family's type profile, spacing rhythm, and centered-container behavior rather than using a looser custom variant

### 2. First-Pass Review

Review the first render or generated batch against:

- brand fit
- hierarchy clarity
- spacing and whitespace discipline
- strategic use of vertical space, especially in Stories
- top / center / bottom balance when the format benefits from it
- headline tracking and optical rhythm on large Japanese type
- whether the chosen type profile helps or hurts readability for this copy density
- line-height fit relative to font size and copy density
- near-solid Japanese setting on body and short-label copy
- headline block density and headline-to-subline separation
- consistent left/right safe margins across the batch
- protected breathing room between the headline block and the first module
- card padding, title offsets, and rule spacing consistency
- optical centering of full text blocks inside boxes, bubbles, bands, and closing cards
- per-column centering when horizontal strips or multi-part bars are used
- grid-track consistency when boxes, bands, tables, or comparison modules repeat across a row
- Japanese line-break quality
- module alignment and optical centering
- semantic clarity of badges, bands, chips, and side labels
- image-backed cover text safety and subject placement
- image-backed cover subject placement and protected overlay zones
- absence of internal workflow scaffolding in on-canvas copy
- batch uniformity
- whether the dominant structural behavior feels intentionally chosen for this topic rather than recycled from the last approved asset
- whether the asset is borrowing appropriately from the wider Set / anchor library instead of overfitting to one recent grammar
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
- top-left and top-right meta labels must sit on the same margin system; if one side feels further inset, the asset fails review
- top-left and top-right meta labels must sit on the same margin system; if one side feels further inset, the asset fails review
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
- a Story close frame relies on hardcoded vertical positions and the overall stack is visibly biased too high or too low inside the canvas
- a Story close frame relies on hardcoded vertical positions and the overall stack is visibly biased too high or too low inside the canvas
- the headline line breaks are correct but the letter spacing still makes the title feel cramped
- a different approved type profile would clearly improve readability and we did not test it
- Japanese body copy or short labels show visible artificial spacing between characters
- the line height, tracking, and font size feel mismatched to the amount of copy or the tone of the message
- the headline and subline read as one compressed dark block instead of two distinct reading layers
- the first module crowds the headline/subline block instead of giving it room to read
- margins drift from slide to slide without a compositional reason
- card padding or title offsets feel improvised instead of system-led
- the text inside a container is mathematically centered line by line but the whole block still feels visually off-balance
- a split card, left rail, or proof row is balanced on one side but the opposite content block still sits too high, too low, or too cramped inside its area
- a center pill or label band is technically centered but still feels vertically tight because the component height and text block do not match
- the text in a multi-column strip is not centered inside its own column
- repeated boxes or table-like modules do not share a real grid and look manually nudged
- the post is using the same dominant set behavior as an adjacent approved feed asset without a deliberate sequence reason
- the asset clearly wanted a different Set A-H behavior but still fell back to the last successful grammar out of convenience
- a same-post design variant changed frontend copy, CTA, or message framing without explicit `design-plus-copy` approval
- a feed or reel is treated as approved, delivered, or calendar-locked but there is no prepared caption block or posting-copy entry tied to that asset
- a feed or reel has a caption but no prepared hashtag set, or the hashtags are generic filler instead of a deliberate `3-5` relevant tags
- a Story support set drifts away from the approved parent feed family's typography or container behavior without an explicit creative-direction reason
- every box in a Story is using the same flat low-contrast fill so the modules blur together instead of carrying distinct roles
- the same key terms are repeated across one frame without adding clarity
- the same visible noun trio or label set is repeated across the cover, body, and close without a distinct role for that repetition
- a frontend-visible image crop, band label, support cue, or CTA line feels improvised rather than traceable to the creative direction
- the middle slide explains but does not guide the eye clearly
- the closing slide feels like another body slide instead of a resolution
- the closing-note card text feels forced, jammed, or off-center
- the image-backed cover does not preserve a clear, readable text zone
- the focal subject is trapped under the final overlay area, band, or text block
- a headline, band, or overlay crosses a face or the primary focal object even if the overall text-safe zone looked acceptable on paper
- the image-backed asset is reusing an older plate by habit when a fresh source would clearly improve distinctiveness
- the CTA behavior feels added on rather than integrated into the system
- bottle truth, pack scale, or lighting integration drift

## Presentation Rule

When sharing work:

- show finalists, not raw first passes
- if a tradeoff remains, name it clearly
- if another pass would materially improve the asset, take that pass before presenting the work as final
- after rerendering a fix, verify the latest output file itself before calling the issue resolved
