---
name: mitozz-prompt-engineer
description: Create and update Nano Banana JSON prompts for Mitozz Japan from creatives director output and project context. Use when the user asks to build, refine, or standardize feed or story prompt files before executing Nano Banana MCP.
---

# Mitozz Prompt Engineer

Use this skill after `mitozz-creatives-director` and before `nano-banana-instagram`.

For reel workflows, this skill produces source-asset prompts only. It does not create the freelancer edit brief itself.

If the prompt work materially improves production readiness, consistency, or execution quality, add a concise entry to the current monthly retainer action log under `brand/references/business-context/reporting/monthly-action-logs/`.

## Inputs To Read

1. Creative packages from `brand/references/business-context/creative-packages/`
2. `prompts/instagram/shared/prompt-template.json`
3. Existing prompt examples in `prompts/instagram/feed/` and `prompts/instagram/stories/`
4. `.agents/skills/nano-banana-instagram/SKILL.md`
5. Visual reference sources:
   - `brand/references/business-context/visual/Brand Visual Direction.md`
   - `brand/references/business-context/visual/Brand Visual Direction.pdf`
   - `brand/references/business-context/visual/Mitozz Template Library Index.md`
   - `brand/references/business-context/visual/template-mapping-rules.json`
   - `brand/references/business-context/visual/reference-pack/reference-pack-index.md`
   - `brand/references/business-context/visual/reference-pack/style-anchors/`
   - `brand/references/business-context/visual/reference-pack/source-intake/`
   - `brand/references/business-context/visual/reference-pack/working-examples/`
6. `workflows/02-build-creative-package.md`
7. `workflows/03-generate-and-approve.md`
8. `tools/resolve-template-mapping.py`
9. `tools/resolve-template-mapping.ps1` for Windows / PowerShell environments

## Calendar Compatibility

The content calendar is now Japanese-first for planning, but prompt JSON should stay operationally clear.

- use the calendar row only as planning context
- resolve `template_set` and `slide_blueprint` from the central mapping rules when the creative package does not already state them
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
- `template_set`
- `slide_blueprint`
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

The prompt engineer is responsible for making the source asset set easy to edit later.

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
- reel shot prompts prioritize continuity, subject legibility, clean edit potential, and text-safe negative space
- use 2 to 4 image references per generation
- include at least 1 `style-anchor` when available
- add up to 1 mode-specific `style-anchor` when the asset clearly matches a specialized anchor such as ingredient-led or bottle-shot-led creative
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

When a reel shot includes the Mitozz bottle as a visible focal element:

- do not rely on the `product-source` image alone
- explicitly write the bottle description into the prompt fields
- explicitly describe the front label orientation and readability
- include the bottle's visible form details such as silhouette, cap finish, bottle material/color, and label block structure
- treat this written pack description as mandatory for bottle-led reel shots, especially product reveals and CTA end frames
- prefer concise factual wording such as "Mitozz supplement bottle with the real label facing forward, clean white bottle body, white cap, and clear centered front label blocks" unless a newer approved source photo requires a more exact description

## Anti-Copy Guardrail

Always encode this rule in the prompt:

- match mood, palette, light quality, whitespace, and restraint
- do not duplicate exact crop, pose, object placement, or gradient pattern

## Reel-Specific Rules

When building prompts for a reel:

- each prompt should represent one clear source asset for one shot or beat
- default `text_overlay.allowed` to `false` unless the creative package explicitly wants baked-in text
- preserve generous negative space when captions, kinetic text, or CTA overlays will be added later
- use consistent subject description across the shot set so the asset family does not drift
- use consistent product orientation when the bottle appears
- for bottle shots, repeat a concise Mitozz bottle-and-label description inside `continuity_tokens`, `composition`, or other prompt text so the model receives explicit pack instructions in plain language
- prefer simple, direct compositions that cut cleanly in an edit
- avoid overcomplicated background detail that makes the reel visually noisy
- keep the first shot visually strong enough to serve as the opening frame
- make the last shot stable enough to hold the CTA beat

Add explicit hard-fail wording whenever relevant:

- for text-free source images, explicitly state `no readable text, letters, logos, labels, UI, or wordmarks anywhere in frame`
- for bottle-led shots, explicitly state the approved bottle color, cap color, label orientation, and label readability requirements
- for routine shots, explicitly state what object or gesture must be the real focal action so the model does not drift into generic still life
- for reframe beats, explicitly state what the shot must not become, such as `not a stock tabletop photo` or `not a generic supplement ad`

For bottle-led shots, encode a rejection rule in plain language:

- `reject and regenerate if bottle color changes`
- `reject and regenerate if label becomes unreadable, simplified, or invented`

## Story Batch Rules

When building prompts for a Story set:

- treat the full Story set as one locked batch, not as unrelated individual frames
- keep one exact card architecture across all frames
- keep one exact border rule or no border rule across all frames
- keep text color density, type weight family, and margin system identical across all frames
- let frame 03 add CTA emphasis only if the base layout system remains unchanged
- explicitly write these batch-lock rules into the prompt notes or variation guardrails

## Quality Checks

Before finalizing a prompt, verify:

- the JSON is valid
- `template_set` and `slide_blueprint` are present and match the mapped design system
- `image_references` and `reference_files` are separate
- the prompt reflects the creatives director concept
- the prompt encodes the Steel Light system
- the prompt includes `asset_archetype` and `reference_strategy`
- the prompt includes variation guardrails so outputs stay cohesive without becoming repetitive
- reel prompt sets carry consistent continuity tokens and clear shot roles per asset

Do not finalize a prompt if:

- the prompt leaves text contamination ambiguous on a text-free source asset
- the prompt leaves bottle color or label fidelity ambiguous on a bottle-led asset
- the prompt leaves Story batch architecture ambiguous across frames

## Output

- Feed: `prompts/instagram/feed/ig-feed-YYYY-MM-DD-theme-v01.json`
- Story: `prompts/instagram/stories/ig-story-YYYY-MM-DD-theme-v01.json`
- Reel shot source image: `prompts/instagram/feed/ig-feed-reel-YYYY-MM-DD-theme-shot-01-v01.json`

## Examples

See [references/examples.md](references/examples.md).
