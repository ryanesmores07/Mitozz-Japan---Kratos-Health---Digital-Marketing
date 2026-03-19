# 02. Build Creative Package

Use this checklist when turning a calendar row into a creative package.

## Inputs

- selected calendar row
- relevant strategy and audience context
- `brand/references/business-context/visual/Brand Visual Direction.md`
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

## Checklist

- Define the objective clearly: educate, reinforce, trust-build, or support conversion.
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

## Reel Planning Add-On

If the selected row format is `Reel`, the creative package must become a motion plan, not just a static image brief.

Add all of the following:

- `reel_type`
- `target_runtime_seconds`
- `opening_hook_strategy`
- `continuity_tokens`
- `source_asset_plan`
- `sora_shot_prompts`
- `sora_master_prompt`
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
- `sora_shot_prompts`
- `sora_master_prompt`
- `motion_guardrails`
- `transition_notes`
- `editor_notes`

## Output

- one creative package per asset
- ready for prompt-engineering with no missing visual-reference decisions
- for reels, ready for prompt-engineering and Sora with no missing shot-level decisions
