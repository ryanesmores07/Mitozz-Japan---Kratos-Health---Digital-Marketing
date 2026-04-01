# 03B. Visual-Engine Preflight

Use this before building the creative package.

The goal is to prevent accidental text-only or abstract-only execution when the topic really needs a stronger human, product, or environment image.

## Why This Exists

The failure mode is not usually "bad typography."

The bigger failure mode is:

- the topic is lived-in or routine-led
- the post should feel human or atmospheric
- no one explicitly decides the image source early enough
- production defaults into shapes, cards, or text modules because they are faster to assemble

This preflight stops that drift.

## Required Decisions

Record these before the creative package is locked:

- `visual_engine`
- `anchor_set`
- `palette_variant`
- `source_lane`
- `source_strategy`
- `fallback_source`
- `icon_strategy`
- `generated_visual_role`

These are production decisions, not calendar fields.

### `palette_variant` Values

Choose one:

- `default`
- `cool_focus`
- `warm_editorial`

Use `default` when:

- the asset does not need a temperature shift
- education clarity is the primary job
- we want the safest brand-default execution

Use `cool_focus` when:

- the asset should feel slightly more clinical or science-forward
- the cooler atmosphere helps clarity without making the asset cold

Use `warm_editorial` when:

- the asset is more human, reassurance-led, or trust-led
- a softer warmth helps the frame feel more lived-in without drifting out of the Steel Light system

Do not invent new palette families ad hoc.
If the asset needs color play, do it through an approved `palette_variant`.

## Support-Layer Decisions

Every asset must also decide two support layers before execution:

- `icon_strategy`
- `generated_visual_role`

These are not optional by omission.
If the answer is `none`, record that intentionally.

### `icon_strategy` Values

Choose one:

- `none`
- `Better-Icons-semantic-support`

Use `Better-Icons-semantic-support` when:

- selector tiles would benefit from clearer meaning
- framework slides need cleaner semantic cues
- answer cards need small structural markers
- CTA reinforcement would benefit from a save, arrow, or question cue

Do not choose icons just because the slide feels empty.

### `generated_visual_role` Values

Choose one:

- `none`
- `subtle-background`
- `infographic-support`
- `hero-visual`
- `support-plate`

Use a generated visual role when:

- the post needs more atmosphere than pure typography can provide
- an infographic needs a cleaner custom support element than stock can provide
- the cover needs a hero object, illustration, or abstract scientific support form
- a subtle background or light texture would improve engagement without clutter

Do not add a generated visual just to fill space.

## Visual Engine Values

Choose one primary visual engine:

- `image-led`
- `type-led`
- `diagram-led`

Only one can be primary.

Support elements can still exist, but the main decision must stay clear.

## Default Selection Rules

Use `image-led` when the topic is about:

- routine
- daily life
- body state
- mood
- environment
- trust
- proof
- product-in-context

Use `diagram-led` when the topic is about:

- comparisons
- decision trees
- frameworks
- process explanation
- myth versus fact
- category navigation

Use `type-led` when the topic is about:

- short reframe statements
- sharp educational punchlines
- concise FAQs
- minimal editorial covers where imagery would not add clarity

If the topic is lifestyle, routine, or body-state based and the chosen engine is not `image-led`, write the reason explicitly before production.

## Source Lane Values

Choose one source lane:

- `owned-real-photo`
- `Unsplash-stock-image`
- `Nano-Banana-source-image`
- `design-first-no-image`

## Source-Lane Guidance

Use `owned-real-photo` when visual truth matters most:

- real bottle accuracy
- real label detail
- exact product-in-hand proof

Use `Unsplash-stock-image` when:

- we need a real-photo-feeling support image
- the image does not need product truth
- the image does not need custom generation
- a premium stock plate is enough

Use `Nano-Banana-source-image` when:

- we need a stock-style lifestyle, environment, object, or human image
- no owned asset exists
- the image needs to be custom to the post topic
- a subtle background, infographic support visual, hero visual, or support plate should be custom-generated instead of hand-built

Use `design-first-no-image` only by choice, not by omission.

This is valid when:

- the post is genuinely editorial
- structure is the main teaching device
- imagery would add noise instead of meaning

Even on `design-first-no-image` assets, still decide:

- whether Better Icons should support the structure
- whether a very subtle generated visual layer would improve the result

## Fallback Rule

Every image-led post needs a fallback before generation starts.

Choose one:

- `fallback to Unsplash stock image`
- `fallback to Nano Banana source image`
- `fallback to type-led structure by explicit approval`

Do not let the fallback become an accidental downgrade.

If `generated_visual_role` is not `none`, the fallback should also state whether that support layer falls back to:

- `Better Icons only`
- `simpler design-first structure`
- `Unsplash stock image`

## Sequence Lock

Use this sequence:

1. approve the calendar row
2. resolve the template set and slide blueprint
3. run this visual-engine preflight
4. gather or generate the source image if the post is image-led
5. decide whether Better Icons or a generated support visual should be part of the asset
6. build the creative package around the chosen source lane
7. execute the prompt or design build
8. review the first result against the chosen engine, support-layer decisions, and typography rules

## April 3 Lesson

The April 3 feed drifted because the topic was routine-led but the workflow never forced an early image-source decision.

The correction is simple:

- decide the visual engine first
- decide whether Unsplash, Nano Banana, owned imagery, or a no-image structure is the real image lane
- only then build the layout
