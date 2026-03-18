# Nano Banana Pro Best Practices

Use these rules when building or executing Instagram image prompts for Mitozz.

## Core Principles

- Keep the visual system consistent: steel-blue atmosphere, cloud-white space, restrained apricot accents, and calm premium lighting.
- Match references for palette, light quality, whitespace, and restraint.
- Do not clone the exact crop, pose, object placement, or gradient pattern from any reference.
- Keep the output simple enough to feel premium on a mobile screen.

## Prompt Construction

- State the exact aspect ratio explicitly.
- State the asset archetype explicitly: `education-card`, `product-hero`, `portrait-trust`, or `story-reinforcement`.
- Include the exact on-image Japanese text in quotes when text is required.
- Separate document references from image references:
  - `reference_files` for business context, strategy, and visual-direction docs
  - `image_references` for actual visual inputs
- Use `reference_strategy` to explain which references should dominate and why.
- Use `variation_guardrails` to state what must change from the references.
- Pass negative prompts explicitly.

## Reference Selection

- Use 2 to 4 image references per generation.
- Include at least 1 `style-anchor` when available.
- Use at most 1 close composition match.
- Match feed educational assets primarily to whitespace, typography, and editorial layout references.
- Match product heroes primarily to lighting, palette, and product framing references.
- Match stories primarily to vertical breathing room and simplified composition references.

## Generation Method

- Generate 3 variants per asset before choosing a winner.
- Keep the same `image_references` across the first batch.
- Vary crop, camera distance, angle, and focal treatment across the variants.
- Select 1 winner and refine once if needed.
- Avoid repeated one-off prompting with large structural changes between attempts.

## Approval Rules

Only promote generated outputs into `working-examples` when they:

- clearly match the visual direction
- feel premium and calm
- do not look repetitive next to the current reference pack
- improve the system instead of diluting it

Promotion should stay human-approved, never automatic.

## Final Execution Checklist

- The prompt includes `asset_archetype`.
- The prompt includes `image_references` and `reference_files`.
- The prompt includes `reference_strategy`.
- The prompt includes `variation_guardrails`.
- The prompt includes explicit negative prompts.
- The selected references fit the asset type and do not overconstrain composition.
