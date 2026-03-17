---
name: mitozz-creatives-director
description: Create creative direction for Mitozz Japan Instagram posts from content calendar rows. Use when the user asks for design direction, messaging, Japanese copy, captions, positioning, or Nano Banana-ready visual guidance after a calendar has been created and before prompt execution.
---

# Mitozz Creatives Director

Use this skill after the monthly calendar is created. It produces creative packages, not final images.

## Quick Start

1. Identify the requested date or range.
2. Read the matching content-calendar row or rows.
3. Read only the most relevant strategy, audience, visual-direction, and reference-pack inputs.
4. Produce one creative package per calendar row.
5. Write all customer-facing copy in natural Japanese.
6. Hand off prompt-ready visual guidance, including selected image-reference archetypes, but do not write prompt JSON here.

## Inputs To Read

1. `brand/references/business-context/content-planning/`
2. `brand/references/business-context/strategy/`
3. `brand/references/business-context/audience/`
4. `brand/references/business-context/visual/Brand Visual Direction.pdf`
5. `brand/references/business-context/visual/Brand Visual Direction.md`
6. `brand/references/business-context/visual/reference-pack/reference-pack-index.md`
7. `brand/references/business-context/visual/reference-pack/style-anchors/`
8. `brand/references/business-context/visual/reference-pack/working-examples/`

If a directly relevant image is attached in chat, treat it as a candidate `style-anchor` and prioritize it.

## Required Output Sections

1. `Meta`
2. `Creative Direction`
3. `Copy and Messaging (Japanese)`
4. `Visual Direction`
5. `Nano Banana Handoff`

## Nano Banana Handoff Requirements

Always include:

- `visual_intent`
- `brand_guardrails`
- `composition`
- `selected_image_references`
- `variation_from_references`
- `text_overlay`
- `negative_prompts`

## Reference Selection Rules

- Choose 2 to 4 image references per asset.
- Include at least 1 `style-anchor` when available.
- Use at most 1 close composition match.
- State what each reference should influence:
  - palette
  - lighting
  - whitespace
  - product framing
  - human portrait mood
  - editorial education layout
- Explicitly state what should vary from the references so outputs stay on-theme without repeating.

## Creative Best Practices

Favor:

- one clear message per asset
- strong hierarchy in the first frame
- save-worthy educational framing for feed carousels
- calm premium trust signals rather than aggressive urgency
- enough white space for Instagram readability
- the current visual shorthand: steel-blue atmosphere, restrained apricot signal color, luminous white space, and editorial restraint
- consistent mood with rotated composition

## Input And Output

- Input folder: `brand/references/business-context/content-planning/`
- Output folder: `brand/references/business-context/creative-packages/`
- Naming: `creative-package-YYYY-MM-DD.md`

## Examples

See [references/examples.md](references/examples.md).
