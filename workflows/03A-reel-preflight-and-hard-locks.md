# 03A. Reel Preflight And Hard Locks

Use this before generating any reel source-frame batch.

This exists to stop us from relying on memory for rules that are already decided.

If the batch fails any step here, stop and fix the prompt or workflow first.

## Mandatory Inputs

Read these before execution:

- `workflows/03-generate-and-approve.md`
- `prompts/instagram/shared/prompt-template.json`
- `brand/references/business-context/visual/Mitozz Instagram Production Standard.md`
- `brand/references/business-context/visual/Mitozz Locked Bottle Workflow.md` when the bottle appears
- `brand/references/business-context/visual/Mitozz Bottle Size Spec.md` when the bottle appears near a hand or in a desk scene

## Preflight Gate

Before generation, confirm all of these:

- every reel source prompt uses `aspect_ratio = 9:16`
- every reel source prompt has `asset_archetype = reel-source-frame`
- every prompt includes explicit `continuity_tokens`
- every prompt includes explicit full-bleed framing language
- every prompt explicitly rejects white bars, blank bars, letterboxing, pillarboxing, inset-canvas behavior, and padding-based fake whitespace
- every prompt includes the hard-fail condition for its biggest risk

If any of those are missing, do not generate.

## Bottle-Led Gate

If the bottle appears in the shot, these rules become mandatory:

- use the locked bottle workflow
- keep the real bottle design intact
- do not ask the generator to redesign, repaint, recolor, simplify, or relabel the bottle
- include a `product-source` bottle reference
- include `Mitozz Locked Bottle Workflow.md` in `reference_files`
- include `Mitozz Bottle Size Spec.md` in `reference_files`
- use the bottle size rule for desk and hand scenes:
  - height around `18% to 22%` of frame height
  - width around `14% to 18%` of frame width
  - for `1536 x 2752` reel frames: about `500 px to 605 px` tall and `215 px to 275 px` wide
- reject any bottle-led output with wrong bottle color, wrong cap, weak label fidelity, invented label structure, or oversized scale

If bottle truth matters and the generator still drifts, reject the output and switch to the real-bottle workflow instead of forcing a full AI rerender.

## Validation Command

Run this before generation:

```bash
powershell -NoProfile -ExecutionPolicy Bypass -File tools/validate-reel-prompt-batch.ps1 "prompts/instagram/feed/ig-feed-reel-2026-03-25-daily-condition-shot-*-v02.json"
```

Do not generate if the command returns `FAILED`.

Optional cross-platform fallback when Python is available:

```bash
python tools/validate-reel-prompt-batch.py "prompts/instagram/feed/ig-feed-reel-2026-03-25-daily-condition-shot-*-v02.json"
```

## Approval Gate

Do not approve a reel source frame unless all of these are true:

- the frame clearly serves its assigned beat
- the frame stays full-bleed `9:16`
- the frame does not show white bands or padded whitespace
- text-safe space exists inside the scene, not outside it
- continuity holds across subject, environment, light direction, and styling
- if the bottle appears, pack truth, scale, contact shadow, and room-light integration all pass

## Promotion Rule

After approval:

- keep only approved frames in the live reel folder
- remove or archive rejected alternates
- do not leave version clutter in the active path

## Ownership Rule

The operator should treat this workflow as a hard gate, not a suggestion.

If a rule is known and documented, it must be enforced in prompt construction, generation, and approval.
