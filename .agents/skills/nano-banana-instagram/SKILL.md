---
name: nano-banana-instagram
description: Execute Nano Banana MCP for Mitozz Instagram assets using existing JSON prompt files. Use when the user asks to generate feed or story creatives from prepared prompts, or to lightly refine and then execute prompt files already created in this workspace.
---

# Nano Banana Instagram

Use this skill for Instagram organic image generation with Nano Banana by executing prompt JSON files plus the approved visual reference pack.

Model preference for this workspace:

- use `gemini-3.1-flash-lite-preview` by default
- use Nano Banana `model_tier = flash`
- do not switch to `pro`, `nb2`, or `auto` unless the user explicitly asks to override this preference

For reels, this skill generates the coordinated source images that will later be edited by the freelancer. It does not replace editing or final assembly.

If a batch completion, quality improvement, or execution-system fix materially advances retainer delivery, add a concise entry to the current monthly retainer action log under `brand/references/business-context/reporting/monthly-action-logs/`.

## Inputs To Read

1. Prompt files in `prompts/instagram/feed/`, `prompts/instagram/stories/`, and `prompts/instagram/shared/`
2. `brand/references/business-context/visual/Brand Visual Direction.md`
3. `brand/references/business-context/visual/Brand Visual Direction.pdf`
4. `brand/references/business-context/visual/reference-pack/reference-pack-index.md`
5. `brand/references/business-context/visual/reference-pack/style-anchors/`
6. `brand/references/business-context/visual/reference-pack/source-intake/`
7. `brand/references/business-context/visual/reference-pack/working-examples/`
8. `brand/references/business-context/visual/Mitozz Approved Post Library.csv`
9. Strategy, audience, and content-planning docs when relevant
10. `workflows/03-generate-and-approve.md`
11. `references/nano-banana-best-practices.md`

## Required Execution Behavior

- Load every prompt `image_references` entry as an actual visual reference input.
- Treat `style-anchor` references as the highest-priority visual input.
- When a prompt includes a mode-specific style anchor, use it only for that asset's specialized mood or composition logic.
- Treat `product-source` references as factual product inputs for bottle shape, cap, label, and tablet accuracy.
- Use `working-example` references to reinforce brand uniformity, not to clone an existing post.
- Treat `working-example` references as unavailable unless they were explicitly approved into the folder.
- If no `working-example` exists for the asset type, fall back to `style-anchor` references plus the visual-direction docs.
- When a prompt includes both `style-anchor` and `product-source`, preserve the anchor-led art direction while using the product-source only for pack fidelity.
- Keep any prompt refinements minimal and execution-focused.
- If the prompt is for stock-style feed or Story support imagery, treat Nano Banana as the source-image generator and keep the output scoped to the needed plate, background, or support image rather than inventing the whole text-led asset.

For reel shot prompts:

- execute each shot prompt as part of one coordinated shot family
- default reel source images to `4:5` unless the user explicitly requests another ratio
- preserve shared continuity tokens across the whole set
- keep the subject description, palette, environment, and light direction stable unless the prompt explicitly changes them
- when the bottle is a featured subject, make sure the prompt text itself explicitly describes the Mitozz bottle and its front label, not just the attached product-source image
- prioritize simple clean compositions that edit cleanly in the final reel
- protect negative space for later text overlays and subtitles
- do not bake text into source images unless the prompt explicitly requires it

Mandatory rejection behavior:

- do not treat a generated asset as approved just because generation succeeded
- inspect each generated asset against the prompt's hard-fail conditions before accepting it
- if a text-free source image contains any readable text, reject it
- if a bottle-led image breaks pack truth on color, silhouette, cap, or label, reject it
- reject any bottle-led image if the deep matte black body, black ribbed cap, pale white neck band, or predominantly black front face drift from the approved pack appearance
- before treating any bottle-led image as approved, compare it side by side with the approved `source-intake/` bottle reference and reject it if the bottle color, cap, wordmark, visible text, or label design drift from the real pack
- reject any bottle-led image if the visible front-label copy drifts from the approved pack wording or footer structure
- reject any bottle-led image where the pack is accurate but the bottle does not inherit the shot's lighting, reflections, shadows, or perspective convincingly
- if a reel frame fails its beat function or continuity role, reject it
- if a Story frame looks individually fine but breaks set uniformity, reject the set

Mandatory internal review behavior:

- run one review pass against `brand/references/business-context/visual/Mitozz Asset Review Gate.md` before presenting any asset as final
- for text-led compositor assets, inspect the rendered PNGs rather than approving from JSON or HTML alone
- if Japanese line breaks, spacing, hierarchy, or CTA closure still feel unresolved, refine once before presenting the asset as final
- present finalists or clearly labeled tradeoff candidates, not raw first-pass outputs

## Variation Guardrails

When building the final generation request, explicitly instruct Nano Banana to:

- match palette, lighting, whitespace, mood, and restraint from the selected references
- preserve accurate bottle silhouette, cap finish, label placement, and tablet relationship from any selected product-source references
- preserve the approved bottle appearance in words and in references: deep matte black body, black ribbed cap, visible pale white neck band, predominantly black front face
- keep the approved bottle design locked while adapting the bottle's lighting, reflections, shadow behavior, and angle to the surrounding scene so it feels physically present
- preserve the approved visible front-label wording and structure, not just the overall bottle silhouette
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

## Output

- Input feed folder: `prompts/instagram/feed/`
- Input story folder: `prompts/instagram/stories/`
- Output feed folder: `output/instagram/feed/`
- Output story folder: `output/instagram/stories/`
- Default generated outputs to `.jpg` for smaller file sizes.
- Use `.jpeg` only if a tool or export path requires it.
- When a feed or Story asset used Nano Banana as a stock-style source-image step, make sure that source strategy is easy to map back into the approved post library after approval.

For reels:

- save all approved source frames for the reel under one clearly grouped output location
- preserve shot order in filenames when possible
- keep the winning frame for each shot easy to map back to its prompt JSON

This skill's deliverable for reels is:

- approved source frame per shot
- optional alternates
- clean source assets ready for the freelancer handoff packet

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
- bottle-led shots explicitly mention bottle silhouette, cap finish, and front-label orientation/readability in the prompt text
- text-safe space is preserved where needed
- the first shot can function as a hook frame
- the last shot can hold for CTA or brand presence

For Stories, also verify:

- all frames use one coherent card system
- border treatment is consistent across the set
- typography weight, darkness, and spacing feel locked across the set
- the CTA frame evolves the same system instead of introducing a new one

## Approval Standard

Use these approval rules before saving outputs as winners:

- reels: approve at the beat level and the sequence level
- stories: approve at the set level, not frame by frame
- any asset that fails a hard lock should be rejected immediately instead of being carried forward as a provisional winner

## Examples

See [references/prompt-examples.md](references/prompt-examples.md).
