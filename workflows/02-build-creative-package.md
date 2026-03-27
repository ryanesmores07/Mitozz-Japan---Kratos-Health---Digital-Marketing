# 02. Build Creative Package

Use this checklist when turning a calendar row into a creative package.

This workflow starts after the calendar-to-production handoff described in `workflows/03-post-calendar-production-flow.md`.

## Inputs

- selected calendar row
- relevant strategy and audience context
- `brand/references/business-context/visual/Brand Visual Direction.md`
- `brand/references/business-context/visual/Mitozz Instagram Production Standard.md`
- `brand/references/business-context/visual/Mitozz Instagram Story Strategy.md` when the asset is a Story
- `brand/references/business-context/visual/Mitozz Template Library Index.md`
- `brand/references/business-context/visual/template-mapping-rules.json`
- `brand/references/business-context/visual/reference-pack/reference-pack-index.md`

Read the calendar row using the current schema:

- `Section`
- `Format`
- `投稿テーマ`
- `Objective`
- `Primary Persona`
- `切り口`
- `Related Feed Post`
- `CTA`
- `補足メモ`

Then resolve the downstream production layer:

- `Template Set`
- `Slide Blueprint`
- `asset_archetype`
- `story_type` when needed
- `approved_references`

## Checklist

- Define the objective clearly: educate, reinforce, trust-build, or support conversion.
- Resolve `Template Set` and `Slide Blueprint` from the mapping rules before deciding layout details.
  - canonical resolver: `tools/resolve-template-mapping.py`
  - windows wrapper: `tools/resolve-template-mapping.ps1`
- Decide whether the asset needs the optional frontend-skill lens before prompt writing.
  - use it when the asset is campaign-critical, visually high-stakes, landing-page-connected, or weak in first-pass composition
  - use it to sharpen visual thesis, hierarchy, image dominance, spacing, and motion logic
  - do not use it to replace normal Mitozz prompt or production workflow
- Assign the right `asset_archetype`.
- Choose 2 to 4 `image_references`.
- Include at least 1 `style-anchor` when available.
- Add 1 approved `product-source` reference when the concept shows the bottle, cap, label, or tablets prominently.
- Use at most 1 close composition match.
- State what each image reference should influence:
  - palette
  - lighting
  - whitespace
  - product framing
  - pack fidelity
  - portrait mood
  - editorial layout
- Write `reference_strategy` in one short sentence.
- Write `variation_guardrails` as explicit change rules.
- Specify what must vary from the references so the result feels on-theme but not repetitive.

If the frontend-skill lens is used, add these internal planning notes before finalizing the package:

- `visual thesis`: one sentence describing mood, material, and energy
- `content plan`: hero, support, detail, final CTA
- `interaction thesis`: 2 to 3 motion ideas when the asset is a reel, animated story, or motion-led concept

## Reel Planning Add-On

If the selected row format is `Reel`, the creative package must become a motion plan, not just a static image brief.

Add all of the following:

- `reel_type`
- `target_runtime_seconds`
- `opening_hook_strategy`
- `continuity_tokens`
- `source_asset_plan`
- `freelancer_edit_blueprint`
- `freelancer_handoff_summary`
- `motion_guardrails`
- `transition_notes`
- `editor_notes`

For reels, also decide:

- whether the reel will use only generated images or a mix of generated images and existing footage
- how many source shots are needed before animation:
  - default to `3-6`
- which shots must show product fidelity
- which shots need extra negative space for kinetic text or subtitles
- whether text should be added in edit or baked into the generated frame

Each reel shot should be documented with:

- `Shot ID`
- `Narrative role`
- `Approx. duration`
- `Source asset needed`
- `Primary subject`
- `Framing`
- `Camera behavior`
- `Expected motion`
- `Transition behavior`
- `On-screen text`

## Required Handoff Fields

- `asset_archetype`
- `visual_intent`
- `brand_guardrails`
- `composition`
- `reference_strategy`
- `variation_guardrails`
- `selected_image_references`
- `variation_from_references`
- `text_overlay`
- `negative_prompts`

For reels, also require:

- `reel_type`
- `target_runtime_seconds`
- `continuity_tokens`
- `source_asset_plan`
- `freelancer_edit_blueprint`
- `freelancer_handoff_summary`
- `motion_guardrails`
- `transition_notes`
- `editor_notes`

## Output

- one creative package per asset
- inherits its mapped `Template Set` and `Slide Blueprint` from the central rules by default
- ready for prompt-engineering with no missing visual-reference decisions
- for reels, ready for prompt-engineering and freelancer handoff with no missing shot-level decisions
