---
name: nano-banana-instagram
description: Execute Nano Banana Pro MCP for Mitozz Instagram assets using existing JSON prompt files. Use when the user asks to generate feed or story creatives from prepared prompts, or to lightly refine and then execute prompt files already created in this workspace.
---

# Nano Banana Instagram

Use this skill for Instagram organic image generation with Nano Banana Pro by executing prompt JSON files plus the approved visual reference pack.

## Inputs To Read

1. Prompt files in `prompts/instagram/feed/`, `prompts/instagram/stories/`, and `prompts/instagram/shared/`
2. `brand/references/business-context/visual/Brand Visual Direction.md`
3. `brand/references/business-context/visual/Brand Visual Direction.pdf`
4. `brand/references/business-context/visual/reference-pack/reference-pack-index.md`
5. `brand/references/business-context/visual/reference-pack/style-anchors/`
6. `brand/references/business-context/visual/reference-pack/working-examples/`
7. Strategy, audience, and content-planning docs when relevant

## Required Execution Behavior

- Load every prompt `image_references` entry as an actual visual reference input.
- Treat `style-anchor` references as the highest-priority visual input.
- Use `working-example` references to reinforce brand uniformity, not to clone an existing post.
- If no `working-example` exists for the asset type, fall back to `style-anchor` references plus the visual-direction docs.
- Keep any prompt refinements minimal and execution-focused.

## Variation Guardrails

When building the final generation request, explicitly instruct Nano Banana to:

- match palette, lighting, whitespace, mood, and restraint from the selected references
- keep the Steel Light system consistent
- vary crop, camera distance, angle, product balance, and glow treatment
- avoid duplicating exact crop, pose, object placement, or gradient pattern

## Prompt Expectations

Prompt files should include:

- `image_references` for actual image assets
- `reference_files` for documents and business context
- exact `text_overlay.headline_ja` and `text_overlay.slides_ja`

## Output

- Input feed folder: `prompts/instagram/feed/`
- Input story folder: `prompts/instagram/stories/`
- Output feed folder: `output/instagram/feed/`
- Output story folder: `output/instagram/stories/`
- Save images as `.jpg` or `.jpeg`

## Brand Checklist

Before generating, verify:

- selected references match the asset type
- at least 1 style anchor is present when available
- no more than 1 close composition match is present
- the generation request preserves luminous clinical minimalism with warm vitamin energy

## Examples

See [references/prompt-examples.md](references/prompt-examples.md).
