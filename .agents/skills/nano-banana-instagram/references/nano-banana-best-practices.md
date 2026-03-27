# Nano Banana Best Practices

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
- Verify the final Japanese strings are clean UTF-8 before paid generation. Do not generate from mojibake or corrupted copy.
- Use `tools/validate-text-integrity.ps1` when a prompt or supporting doc looks suspicious in the terminal. Validate the bytes instead of trusting terminal rendering.
- Separate document references from image references:
  - `reference_files` for business context, strategy, and visual-direction docs
  - `image_references` for actual visual inputs
- Use `reference_strategy` to explain which references should dominate and why.
- Use `variation_guardrails` to state what must change from the references.
- Pass negative prompts explicitly.
- If the tool parameter already controls variant count, ask for one finished image only in the prompt text. Do not also request "3 variants" inside the image prompt or the model may generate contact sheets.

## Reference Selection

- Use 2 to 4 image references per generation.
- Include at least 1 `style-anchor` when available.
- Add 1 approved `product-source` reference when product accuracy matters.
- Use at most 1 close composition match.
- Match feed educational assets primarily to whitespace, typography, and editorial layout references.
- Match product heroes primarily to lighting, palette, and product framing references.
- Match stories primarily to vertical breathing room and simplified composition references.
- Use product-source references only for bottle silhouette, cap finish, label fidelity, and tablet relationship.
- If a reference contains readable English, template labels, page numbers, or footer text, do not use it for text-led cards unless the prompt explicitly rejects inherited Latin-text contamination.

## Generation Method

- Generate 3 variants per asset before choosing a winner.
- Keep the same `image_references` across the first batch.
- Vary crop, camera distance, angle, and focal treatment across the variants.
- Select 1 winner and refine once if needed.
- If the failure mode is systemic, stop and tighten the prompt before the next batch instead of spending on another blind rerun.
