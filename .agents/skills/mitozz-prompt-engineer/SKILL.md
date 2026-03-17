---
name: mitozz-prompt-engineer
description: Create and update Nano Banana Pro JSON prompts for Mitozz Japan from creatives director output and project context. Use when the user asks to build, refine, or standardize feed or story prompt files before executing Nano Banana Pro MCP.
---

# Mitozz Prompt Engineer

Use this skill after `mitozz-creatives-director` and before `nano-banana-instagram`.

## Inputs To Read

1. Creative packages from `brand/references/business-context/creative-packages/`
2. `prompts/instagram/shared/prompt-template.json`
3. Existing prompt examples in `prompts/instagram/feed/` and `prompts/instagram/stories/`
4. `.agents/skills/nano-banana-instagram/SKILL.md`
5. Visual reference sources:
   - `brand/references/business-context/visual/Brand Visual Direction.md`
   - `brand/references/business-context/visual/Brand Visual Direction.pdf`
   - `brand/references/business-context/visual/reference-pack/reference-pack-index.md`
   - `brand/references/business-context/visual/reference-pack/style-anchors/`
   - `brand/references/business-context/visual/reference-pack/working-examples/`

## Prompt Shape

Use this JSON structure:

- `asset_type`
- `campaign_name`
- `topic`
- `objective`
- `platform`
- `aspect_ratio`
- `audience`
- `visual_intent`
- `brand_guardrails`
- `composition`
- `image_references`
- `text_overlay`
- `negative_prompts`
- `reference_files`
- `notes`

## `image_references` Rules

Each prompt must carry structured image references with:

- `path`
- `role`
- `influence`
- `match_strength`

Default rules:

- feed educational assets prioritize whitespace, typography, and editorial layout references
- product hero assets prioritize lighting, palette, and product-framing references
- stories prioritize vertical breathing room and simplified composition references
- use 2 to 4 image references per generation
- include at least 1 `style-anchor` when available
- use at most 1 close composition match
- default `match_strength` to `medium`

Keep `reference_files` for business-context documents only. Use `image_references` for image inputs.

## Anti-Copy Guardrail

Always encode this rule in the prompt:

- match mood, palette, light quality, whitespace, and restraint
- do not duplicate exact crop, pose, object placement, or gradient pattern

## Quality Checks

Before finalizing a prompt, verify:

- the JSON is valid
- `image_references` and `reference_files` are separate
- the prompt reflects the creatives director concept
- the prompt encodes the Steel Light system
- the prompt includes variation guardrails so outputs stay cohesive without becoming repetitive

## Output

- Feed: `prompts/instagram/feed/ig-feed-YYYY-MM-DD-theme-v01.json`
- Story: `prompts/instagram/stories/ig-story-YYYY-MM-DD-theme-v01.json`

## Examples

See [references/examples.md](references/examples.md).
