---
name: mitozz-compositor-executor
description: Assemble final Mitozz Japan creative assets from the approved source lane, locked copy, and approved design system without reinterpreting the brief.
---

# Mitozz Compositor Executor

Use this skill when the creative package and source assets already exist and the remaining job is to assemble the final asset cleanly.

This skill is the final-build layer for:

- text-led feed assets
- mixed-source feed assets
- Story sets with locked copy and structure
- design-first compositor paths using generated, stock, or owned image plates

## Role

This skill does not decide the concept.

It executes the approved:

- `visual_engine`
- `source_lane`
- `icon_strategy`
- `generated_visual_role`
- copy
- template set
- slide blueprint
- layout system

Its job is precision and consistency, not reinterpretation.

Lane rule:

- use the reusable HTML/CSS template lane when the approved layout grammar is already stable and likely to be reused
- use the PowerShell compositor lane when the approved asset still needs custom measured drawing or one-off layout logic
- if the same custom PowerShell layout family succeeds across more than one approved asset, recommend promoting it into the template lane instead of cloning more renderer scripts

## Inputs

Read:

- the approved creative package
- the chosen source assets
- the approved template mapping
- the production standard
- the asset review gate

## Responsibilities

- assemble the asset in the chosen system
- preserve intentional Japanese line breaks
- preserve batch consistency
- keep spacing, typography, and CTA behavior locked
- preserve the approved frontend copy exactly for design-only variants
- when a Story reinforces an approved feed family, inherit that feed family's type profile, container-centering behavior, and closing-card logic by default instead of improvising a lighter variant
- treat `type_profile` as a real production decision, not a cosmetic afterthought
- remove internal scaffolding from viewer-facing output
- make sure label bands, chips, row tags, and note cards carry meaningful content or act as clearly intentional accents
- center text optically inside modules when the component reads as a centered label
- center the full content block optically inside boxes, bubbles, bands, and cards instead of centering each line independently
- anchor right-side corner meta from the same outer margin as left-side meta instead of placing it by guessed x coordinates
- protect breathing room between the headline block and the first body module
- prefer `humanist_sans` for denser Japanese educational copy when it improves readability without changing the concept
- compose closing-note cards as centered closing components, not recycled body cards
- for Story close frames, center the whole lower composition stack as one measured group instead of tuning strip and card Y values ad hoc
- in the HTML/CSS template lane, use CSS Grid for macro layout and Flexbox for internal alignment
- keep boxes, bands, and comparison rows on shared grid tracks instead of hand-placed widths
- use the chosen image or source plate without drifting into a new concept
- preserve a protected text-safe zone when the layout uses an image-backed cover
- integrate the chosen icon family when `icon_strategy` calls for Better Icons support
- integrate the chosen generated visual layer when `generated_visual_role` is not `none`
- keep production output folders in the canonical date-first format: `YYYY-MM-DD-feed-slug-vNN`, `YYYY-MM-DD-story-slug-vNN`, or `YYYY-MM-DD-reel-slug-vNN`
- review the first result before promotion
- verify the latest rendered file after each fix before treating the issue as resolved
- for feed and reel assets, do not treat the asset as fully production-ready until `mitozz-posting-copy-optimizer` has produced the matching caption and hashtag output

## Do Not

- rewrite the approved messaging angle
- rewrite the approved frontend copy for a design-only variant
- change the primary source lane without a documented reason
- invent substitute motifs when an icon, image, or layout component was already chosen
- skip the approved icon or generated-visual layer and replace it with random geometry
- let `Set` names, placeholder markers, or English workflow labels leak into production artwork
- leave empty-looking side strips or meaningless badge text in the final asset
- treat forced line breaks or slightly off-center label alignment as acceptable
- treat visually off-balance container content as acceptable just because its coordinates are technically centered
- quietly assume posting copy will be handled later for a feed or reel that is otherwise ready to ship
- present raw first passes as final production

## Output Guidance

The final asset should map clearly back to:

- the creative package
- the chosen source lane
- the approved output path

If a tradeoff remains, note it before promotion.
