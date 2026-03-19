---
name: mitozz-prompt-engineer
description: Create and update Nano Banana Pro JSON prompts for Mitozz Japan from creatives director output and project context. Use when the user asks to build, refine, or standardize feed or story prompt files before executing Nano Banana Pro MCP.
---

# Mitozz Prompt Engineer

Use this skill after `mitozz-creatives-director` and before `nano-banana-instagram`.

For reel workflows, this skill must produce prompts that are optimized for a later OpenAI Sora image-to-video or video-to-video step. Do not treat a reel as one generic feed prompt.

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
   - `brand/references/business-context/visual/reference-pack/source-intake/`
   - `brand/references/business-context/visual/reference-pack/working-examples/`
6. `workflows/02-build-creative-package.md`
7. `workflows/03-generate-and-approve.md`

## Calendar Compatibility

The content calendar is now Japanese-first for planning, but prompt JSON should stay operationally clear.

- use the calendar row only as planning context
- use the creative package as the source of truth for wording and production decisions
- keep prompt structure and control fields in English
- preserve exact customer-facing Japanese only inside `text_overlay` or other explicit copy fields
- do not copy raw calendar cells into the prompt without refining them through the creative package

## Prompt Shape

Use this JSON structure:

- `asset_type`
- `campaign_name`
- `topic`
- `objective`
- `asset_archetype`
- `platform`
- `aspect_ratio`
- `audience`
- `motion_role`
- `shot_id`
- `shot_position`
- `continuity_tokens`
- `visual_intent`
- `brand_guardrails`
- `composition`
- `image_references`
- `reference_strategy`
- `variation_guardrails`
- `text_overlay`
- `sora_handoff`
- `negative_prompts`
- `reference_files`
- `notes`

### Reel Prompt Packaging

When the source asset is a reel:

- create one prompt JSON per planned source shot or keyframe
- keep all reel shot prompts in the normal feed folder unless the user asks for a separate reel folder
- name them `ig-feed-reel-YYYY-MM-DD-theme-shot-01-v01.json`
- use `motion_role`, `shot_id`, and `shot_position` to keep the set coordinated
- encode the same continuity tokens across the full reel set unless a shot intentionally changes environment or subject

The prompt engineer is responsible for making the shot set easy to animate in Sora later.

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
- reel shot prompts prioritize continuity, subject legibility, clean motion potential, and text-safe negative space
- use 2 to 4 image references per generation
- include at least 1 `style-anchor` when available
- add 1 `product-source` reference when the bottle, cap, label, or tablets must stay accurate
- use at most 1 close composition match
- default `match_strength` to `medium`
- if no approved `working-example` exists, use `style-anchor` references only

Keep `reference_files` for business-context documents only. Use `image_references` for image inputs.

Product-source rules:

- use `brand/references/business-context/visual/reference-pack/source-intake/mitozz-bottle.jpg` for clean bottle hero fidelity
- use `brand/references/business-context/visual/reference-pack/source-intake/mitozz-bottle-with-tablets.jpg` when tablets should appear naturally in frame
- set `role` to `product-source`
- keep `influence` focused on pack fidelity, label placement, cap finish, bottle silhouette, or tablet relationship
- do not use product-source references to control palette, typography, or overall composition

## Anti-Copy Guardrail

Always encode this rule in the prompt:

- match mood, palette, light quality, whitespace, and restraint
- do not duplicate exact crop, pose, object placement, or gradient pattern

## Reel-Specific Rules

When building prompts for a reel:

- each prompt should represent one clear source asset for one shot
- default `text_overlay.allowed` to `false` unless the creative package explicitly wants baked-in text
- preserve generous negative space when captions, kinetic text, or CTA overlays will be added later
- use consistent subject description across the shot set so Sora does not drift
- use consistent product orientation when the bottle appears
- prefer simple, direct compositions that animate cleanly
- avoid overcomplicated background detail that creates unstable motion
- keep the first shot visually strong enough to serve as the opening frame
- make the last shot stable enough to hold the CTA beat

Every reel prompt must include a `sora_handoff` block with:

- `use_for_sora`
- `input_mode`
- `shot_goal`
- `duration_seconds`
- `camera_motion`
- `subject_motion`
- `transition_in`
- `transition_out`
- `prompt`
- `negative_prompt`

The `prompt` field should tell Sora exactly how to animate the generated image or how to extend the shot if video already exists.

The `negative_prompt` field should suppress:

- warped hands
- bottle shape drift
- unreadable typography
- sudden costume changes
- abrupt background swaps
- hyperactive camera motion
- flashy ad-style transitions

## Quality Checks

Before finalizing a prompt, verify:

- the JSON is valid
- `image_references` and `reference_files` are separate
- the prompt reflects the creatives director concept
- the prompt encodes the Steel Light system
- the prompt includes `asset_archetype` and `reference_strategy`
- the prompt includes variation guardrails so outputs stay cohesive without becoming repetitive
- reel prompt sets carry consistent continuity tokens and a complete `sora_handoff` block per shot

## Output

- Feed: `prompts/instagram/feed/ig-feed-YYYY-MM-DD-theme-v01.json`
- Story: `prompts/instagram/stories/ig-story-YYYY-MM-DD-theme-v01.json`
- Reel shot source image: `prompts/instagram/feed/ig-feed-reel-YYYY-MM-DD-theme-shot-01-v01.json`

## Examples

See [references/examples.md](references/examples.md).
