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
- `dominant_set_behavior`
- `variation_strategy`
- `selected_set_images`
- `variant_scope`
- `palette_variant`
- `type_profile`
- `source_lane`
- `source_strategy`
- `fallback_source`
- `icon_strategy`
- `generated_visual_role`

These are production decisions, not calendar fields.

`variant_scope` controls whether a new version is testing design only or design plus copy.

Default rule:

- for the same post, variants default to `design-only`
- if copy is also being tested, record `design-plus-copy` explicitly

Do not let same-post variants drift into different frontend copy by accident.

`anchor_set` and `dominant_set_behavior` are not the same thing.

- `anchor_set` = which references or set family we are borrowing from
- `dominant_set_behavior` = the main structural behavior we are actually adapting for this asset

Examples of `dominant_set_behavior`:

- `Set C answer-card`
- `Set D logic / branching`
- `Set E premium simplicity`
- `Set H pacing-led education`
- `anchor-editorial-whitespace`
- `anchor-portrait-trust`

`variation_strategy` should state what is changing from the most recent adjacent asset so we do not keep reusing the same internal rhythm by habit.

`selected_set_images` should list the actual screenshot files being adapted when the asset uses `Set A-H`.

Do not stop at:

- `Set C`
- `Set H`

Go one level deeper:

- which screenshot(s)
- what behavior each screenshot controls

Example:

- `Set C / Screenshot 2026-03-29 at 16.50.37.png = answer-card behavior`
- `Set H / Screenshot 2026-03-29 at 16.57.54.png = cover pacing`

Examples:

- `warmer image-led cover, cleaner type-led body`
- `portrait-trust opener instead of definition-led still life`
- `selector logic replaced by answer-card stack`
- `Set D branching behavior instead of the April 6 three-column model`

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

### `type_profile` Values

Choose one:

- `mitozz_sans`
- `humanist_sans`
- `editorial_serif`

Use `mitozz_sans` when:

- the asset should feel most like the default Mitozz system
- the copy is moderate in density
- we want the safest brand-default voice

Use `humanist_sans` when:

- the Japanese headline block feels visually cramped even after good line breaks
- the post is education-heavy and needs friendlier readability
- we want a calmer, more breathable feel without changing the layout structure
- boxes, bands, or container-led slides need a softer, more readable text rhythm inside structured modules

Use `editorial_serif` when:

- the concept benefits from a more editorial tone
- the serif treatment is limited and still clearly readable
- the batch was intentionally designed around that voice

Do not use type-profile changes as a substitute for bad spacing or bad line breaks.

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

## Rotation Rule

Do not reuse the same dominant set behavior on adjacent or near-adjacent feed posts unless:

- the posts are intentionally part of one campaign sequence
- the creative direction explicitly says the shared structure is the point

Use the broader `style-anchors/Set A-H` library actively.
Adapt the behavior to Mitozz; do not copy the reference literally.

Keep these consistent:

- palette tokens
- type discipline
- spacing quality
- premium calm

Rotate these when the topic benefits:

- dominant structural behavior
- panel rhythm
- cover treatment
- image role
- comparison vs answer-card vs editorial-note logic

## Source Lane Values

Choose one source lane:

- `owned-real-photo`
- `Unsplash-stock-image`
- `Nano-Banana-source-image`
- `design-first-no-image`

For this workspace moving forward, default fresh image creation to `Nano-Banana-source-image` through the MCP lane.
Treat `Unsplash-stock-image` as an explicit override only when the user specifically wants real stock realism or reference scouting.

## Source-Lane Guidance

Use `owned-real-photo` when visual truth matters most:

- real bottle accuracy
- real label detail
- exact product-in-hand proof

Use `Unsplash-stock-image` only when:

- the user explicitly wants a real-photo stock plate
- the asset needs reference scouting more than custom generation
- a premium real-photo look matters more than a custom text-safe composition
- Nano Banana is not the chosen lane by brief

Do not use `Unsplash-stock-image` as the default just because it exists.
For fresh cover plates, hero backgrounds, subtle support plates, and overlay-aware source images, use `Nano-Banana-source-image` unless the user explicitly asks for stock.

Use `Nano-Banana-source-image` when:

- we need a stock-style lifestyle, environment, object, or human image
- no owned asset exists
- the image needs to be custom to the post topic
- a subtle background, infographic support visual, hero visual, or support plate should be custom-generated instead of hand-built
- we want a fresh brand-fit image plate and stock would feel too generic
- we want a fresh brand-fit image plate and stock is too generic
- we need a clean text-safe zone, subject placement lock, or protected overlay area for later compositor assembly

When `Nano-Banana-source-image` is chosen for a cover or mixed-source compositor asset, also lock:

- `text_safe_zone`
- `subject_placement`
- `overlay_protection_zone`

These are generation constraints, not optional notes.

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

Fresh-source rule:

- if the asset uses photography as a meaningful part of the concept, evaluate whether a fresh source plate should replace repeated reuse of the last successful image
- do not reuse the same background image across new assets by default when the creative would benefit from a new atmosphere
- if an older source plate is reused intentionally, record the reason

Choose one:

- `fallback to a new Nano Banana source image`
- `fallback to a previously approved Nano Banana source image`
- `fallback to owned-real-photo`
- `fallback to type-led structure by explicit approval`

Do not let the fallback become an accidental downgrade.

If `generated_visual_role` is not `none`, the fallback should also state whether that support layer falls back to:

- `Better Icons only`
- `simpler design-first structure`
- `a simpler Nano Banana brief`

## Sequence Lock

Use this sequence:

1. approve the calendar row
2. resolve the template set and slide blueprint
3. run this visual-engine preflight
4. gather or generate the source image through Nano Banana MCP if the post is image-led
5. decide whether Better Icons or a generated support visual should be part of the asset
6. build the creative package around the chosen source lane
7. execute the prompt or design build
8. review the first result against the chosen engine, support-layer decisions, and typography rules

Typography fit rule:

- line height, tracking, and font size must be tuned together
- do not treat line height or letter spacing as fixed defaults once the headline length, tone, or slide role changes
- keep Japanese body copy and short labels near solid setting unless a very specific optical reason justifies otherwise
- check headline block density after line breaks are locked; if the block still feels cramped, adjust line height, size, and headline-to-subline spacing together
- use line-height by role instead of one loose default:
  display headlines approximately `1.08-1.18`
  supporting lines approximately `1.25-1.40`
  body copy approximately `1.45-1.60`
- if the copy block changes materially, re-evaluate tracking and line height before approval

## April 3 Lesson

The April 3 feed drifted because the topic was routine-led but the workflow never forced an early image-source decision.

The correction is simple:

- decide the visual engine first
- decide whether Unsplash, Nano Banana, owned imagery, or a no-image structure is the real image lane
- only then build the layout
