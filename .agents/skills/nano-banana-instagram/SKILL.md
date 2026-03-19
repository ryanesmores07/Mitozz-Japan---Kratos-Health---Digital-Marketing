---
name: nano-banana-instagram
description: Execute Nano Banana Pro MCP for Mitozz Instagram assets using existing JSON prompt files. Use when the user asks to generate feed or story creatives from prepared prompts, or to lightly refine and then execute prompt files already created in this workspace.
---

# Nano Banana Instagram

Use this skill for Instagram organic image generation with Nano Banana Pro by executing prompt JSON files plus the approved visual reference pack.

For reels, this skill generates the coordinated source images that will later be animated in OpenAI Sora. It does not replace Sora or final editing.

## Inputs To Read

1. Prompt files in `prompts/instagram/feed/`, `prompts/instagram/stories/`, and `prompts/instagram/shared/`
2. `brand/references/business-context/visual/Brand Visual Direction.md`
3. `brand/references/business-context/visual/Brand Visual Direction.pdf`
4. `brand/references/business-context/visual/reference-pack/reference-pack-index.md`
5. `brand/references/business-context/visual/reference-pack/style-anchors/`
6. `brand/references/business-context/visual/reference-pack/source-intake/`
7. `brand/references/business-context/visual/reference-pack/working-examples/`
8. Strategy, audience, and content-planning docs when relevant
9. `workflows/03-generate-and-approve.md`
10. `references/nano-banana-pro-best-practices.md`

## Required Execution Behavior

- Load every prompt `image_references` entry as an actual visual reference input.
- Treat `style-anchor` references as the highest-priority visual input.
- Treat `product-source` references as factual product inputs for bottle shape, cap, label, and tablet accuracy.
- Use `working-example` references to reinforce brand uniformity, not to clone an existing post.
- Treat `working-example` references as unavailable unless they were explicitly approved into the folder.
- If no `working-example` exists for the asset type, fall back to `style-anchor` references plus the visual-direction docs.
- When a prompt includes both `style-anchor` and `product-source`, preserve the anchor-led art direction while using the product-source only for pack fidelity.
- Keep any prompt refinements minimal and execution-focused.

For reel shot prompts:

- execute each shot prompt as part of one coordinated shot family
- preserve shared continuity tokens across the whole set
- keep the subject description, palette, environment, and light direction stable unless the prompt explicitly changes them
- prioritize simple clean compositions that animate well in Sora
- protect negative space for later text overlays and subtitles
- do not bake text into source images unless the prompt explicitly requires it

## Variation Guardrails

When building the final generation request, explicitly instruct Nano Banana to:

- match palette, lighting, whitespace, mood, and restraint from the selected references
- preserve accurate bottle silhouette, cap finish, label placement, and tablet relationship from any selected product-source references
- keep the Steel Light system consistent
- vary crop, camera distance, angle, product balance, and glow treatment
- avoid duplicating exact crop, pose, object placement, or gradient pattern

## Prompt Expectations

Prompt files should include:

- `asset_archetype` for the visual archetype
- `image_references` for actual image assets
- `reference_files` for documents and business context
- `reference_strategy` for which references should dominate
- `variation_guardrails` for what must change from the references
- exact `text_overlay.headline_ja` and `text_overlay.slides_ja`

Reel shot prompts should also include:

- `motion_role`
- `shot_id`
- `shot_position`
- `continuity_tokens`
- `sora_handoff`

## Output

- Input feed folder: `prompts/instagram/feed/`
- Input story folder: `prompts/instagram/stories/`
- Output feed folder: `output/instagram/feed/`
- Output story folder: `output/instagram/stories/`
- Default generated outputs to `.jpg` for smaller file sizes.
- Use `.jpeg` only if a tool or export path requires it.

For reels:

- save all approved source frames for the reel under one clearly grouped output location
- preserve shot order in filenames when possible
- keep the winning frame for each shot easy to map back to its prompt JSON

This skill's deliverable for reels is:

- approved source frame per shot
- optional alternates
- intact Sora handoff data from the prompt set

## Brand Checklist

Before generating, verify:

- selected references match the asset type
- at least 1 style anchor is present when available
- product-source references are included whenever product fidelity matters
- no more than 1 close composition match is present
- the generation request preserves luminous clinical minimalism with warm vitamin energy

For reels, also verify:

- each shot has a clear role in the sequence
- continuity tokens match across the reel set
- text-safe space is preserved where needed
- the first shot can function as a hook frame
- the last shot can hold for CTA or brand presence

## Examples

See [references/prompt-examples.md](references/prompt-examples.md).
