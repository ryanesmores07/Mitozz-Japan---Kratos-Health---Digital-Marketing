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
- Use at most 1 close composition match.
- State what each image reference should influence:
  - palette
  - lighting
  - whitespace
  - product framing
  - portrait mood
  - editorial layout
- Write `reference_strategy` in one short sentence.
- Write `variation_guardrails` as explicit change rules.
- Specify what must vary from the references so the result feels on-theme but not repetitive.

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

## Output

- one creative package per asset
- ready for prompt-engineering with no missing visual-reference decisions
