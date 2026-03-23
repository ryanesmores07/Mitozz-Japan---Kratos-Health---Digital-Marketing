# Mitozz Instagram Production Standard

## Purpose

This file locks the Mitozz Instagram system for production.

It defines:

- what template sets are approved
- what gets repeated
- what gets varied
- how the grid stays consistent
- how often the library should refresh
- how feed assets should stay engaging without breaking the premium system

Feed engagement operating rules:

- [Mitozz Feed Engagement Standard.md](/Users/ernieryanesmores/Desktop/Workspace/Mitozz-Japan---Kratos-Health---Digital-Marketing/brand/references/business-context/visual/Mitozz%20Feed%20Engagement%20Standard.md)

## Approved Production System

The Mitozz grid should operate like a premium brand system, not a one-off design exercise.

Use the same core template families repeatedly.
Vary execution inside those families.

## Template Hierarchy

`Set 1: Education White Card` is the primary Mitozz feed signature.

This is the main template family the brand should be recognized for.
It should appear most often on the grid and define the premium, unique, education-first look of the account.

Production master:

- [Mitozz Set 1 Master Template Spec.md](/Users/ernieryanesmores/Desktop/Workspace/Mitozz-Japan---Kratos-Health---Digital-Marketing/brand/references/business-context/visual/Mitozz%20Set%201%20Master%20Template%20Spec.md)

Prompt-ready lock:

- [prompt-template.json](/Users/ernieryanesmores/Desktop/Workspace/Mitozz-Japan---Kratos-Health---Digital-Marketing/prompts/instagram/shared/prompt-template.json)

The other sets exist to support `Set 1`, not replace it:

- `Set 2` supports `Set 1` inside educational carousels
- `Set 3` handles product moments inside the same brand world
- `Set 4` adds realistic lifestyle rhythm
- `Set 5` adds trust, authority, and reassurance

If the grid ever starts drifting, bring it back by increasing `Set 1` usage.

## Approved Template Status

### Approved

`Set 1`

- status: approved
- role: primary education-first brand signature
- note: this should be the most repeated template family on the feed

`Set 4`

- status: approved directionally
- role: realistic lifestyle and routine support
- note: no-bottle version is the safer default

`Set 5`

- status: approved directionally
- role: trust, authority, advisor, reassurance

### Approved With Workflow Constraint

`Set 3`

- status: approved only through the real-photo composition workflow
- role: product hero, CTA end card, product relevance
- rule: use the real bottle as product truth

### Structural Support Set

`Set 2`

- status: approved as a structural support mode
- role: inner educational slides, frameworks, comparisons
- note: it should follow the language of `Set 1`, not behave like a separate visual world

## What Repeats

These should repeat consistently:

- Steel Light palette
- whitespace discipline
- typography logic
- full-canvas rounded white card treatment for `Set 1`
- minimal edge atmosphere instead of a floating-card background
- premium calm tone
- save-worthy education feel
- minimal composition
- restrained warmth

## Typography Lock

Typography is locked as a system, not an asset-by-asset interpretation.

For `Set 1` and `Set 2`:

- use one Japanese sans-serif family consistently
- keep the typographic personality stable across the whole carousel or story set
- do not let inner slides drift into heavier, lighter, or more decorative text styles

Production lock:

- cover headline: `Noto Sans JP Bold`
- cover supporting line: `Noto Sans JP Medium`
- inner carousel slides: `Noto Sans JP Medium`
- carousel CTA slide: `Noto Sans JP Medium`
- story frames: `Noto Sans JP Medium`

Emphasis should come from:

- spacing
- line breaks
- card scale
- placement
- contrast against whitespace

Emphasis should not come from:

- random weight changes
- mixed font families
- decorative type styles
- outlined text
- faux button treatments
- ad-like CTA styling

If a generated asset changes the typographic personality from the rest of the set, regenerate it.

## Batch Consistency Rule

Every asset batch must behave like one designed family.

For one batch of connected assets, lock these before approving anything:

- font family
- font weight by role
- text color
- text opacity
- support-visual opacity
- edge-glow intensity
- background softness
- contrast level

What this means in practice:

- do not let one slide become darker, heavier, brighter, or glossier than the rest by accident
- do not let one story frame or carousel slide introduce a new type personality
- do not let support graphics suddenly become more visible unless that role was intentionally defined

Allowed variation inside a batch:

- copy
- crop
- support visual type
- image subject
- focal placement

Not allowed unless intentionally approved as a variant:

- different font weights for the same role
- different text color values within the same set
- noticeably different opacity treatment
- different edge treatment from one frame to the next
- inconsistent glow strength or color temperature

If a batch does not feel like it was designed together, regenerate before approval.

Automatic QA rule:

- do not accept a generated batch on first pass by default
- compare it against the locked master references
- if border thickness, card size, spacing, typography presence, or edge treatment drift, regenerate the incorrect slide
- only promote slides that pass the locked system checks

## Aspect Ratio Lock

Aspect ratio is locked by asset type.

Use only these production ratios:

- feed default = `4:5`
- square feed asset = `1:1`
- stories = `9:16` or `1:1`
- reels and reel source frames = `9:16`

Story approval rule:

- choose one approved ratio for the whole story set: `9:16` or `1:1`
- do not mix story ratios within one set or one batch intended to feel uniform
- use `9:16` for native full-screen Story-first publishing
- use `1:1` only when the story concept or AI-video workflow benefits from square framing and the full set stays square

Approval rule:

- do not approve a feed asset that exports outside `4:5` unless the asset was explicitly planned as square
- do not allow random landscape outputs into the working set
- do not approve a story set that mixes `9:16` and `1:1`
- if an image generator drifts to the wrong ratio, regenerate it

## What Rotates

These should rotate to avoid repetition:

- crop
- focal distance
- card alignment
- background plate
- light softness
- surface treatment
- realistic scene type
- portrait framing

## Feed Rotation Rule

Default feed rhythm:

1. `Set 1`
2. `Set 4` or `Set 3`
3. `Set 5`
4. `Set 1`
5. `Set 3` or `Set 4`
6. `Set 1`
7. `Set 5`
8. `Set 3`
9. `Set 4`

Practical interpretation:

- `Set 1` should remain the dominant face of the brand
- `Set 4` and `Set 5` should create relief and human rhythm around it
- `Set 3` should appear selectively so product moments stay premium and credible
- the grid should mostly feel like `Education White Card`, not like five equally weighted visual systems

This keeps the grid:

- education-led
- premium
- varied
- human enough
- product-aware without becoming salesy

## Feed Engagement Rule

The feed should not rely on aesthetics alone.

Every feed asset should also be evaluated for:

- hook strength
- swipe logic
- save or share value
- contextual relevance
- clarity of final behavior

Do not solve weak engagement by making the layout louder.

Solve it by improving:

- first-slide relevance
- narrative pacing
- real-life context
- CTA clarity

## Product Post Rule

Do not use one single product template forever.

For `Set 3`, build a mini-library of product plates and rotate them.

Recommended product mini-library:

- `Plate A`: clean tabletop, cool editorial light
- `Plate B`: softer curtain-light atmosphere
- `Plate C`: warmer ritual-led product setting

All three must use the same real bottle workflow.

## Refresh Rule

Do not redesign the system every month.

Refresh cadence:

- minor additions: every 6 to 8 weeks if the grid starts to feel repetitive
- major refresh: every quarter
- full redesign: only if strategy or brand direction changes

## Approval Rule

Only promote something into the working system if it:

- clearly fits the Steel Light world
- improves variety without breaking consistency
- feels premium and restrained
- reads well on mobile
- supports the brand better than the current library

## Production Defaults

If no override is needed:

- education posts use `Set 1 + Set 2`
- use `Set 3` only when product context or an end card clearly helps
- product posts use `Set 3` with real bottle workflow
- lifestyle posts use `Set 4`
- authority posts use `Set 5`
- stories simplify `Set 1`, `Set 4`, or `Set 5`

## Posting Logic

When posting to the feed, use the sets like this:

`Set 1: Education White Card`

- main feed template
- use for most educational carousels, explainers, and save-worthy posts
- this is the premium and uniquely recognizable Mitozz look

`Set 2: Editorial Science Layer`

- support template for `Set 1`
- use for inner carousel slides, structured breakdowns, and comparison logic
- it should never feel like a different brand aesthetic

`Set 3: Luminous Product Hero`

- use for product-led posts, end cards, and product relevance frames
- always preserve real bottle truth through the approved workflow
- use selectively so product presence feels premium, not repetitive

`Set 4: Real-Life Ritual Lifestyle`

- use for reels, daily-condition visuals, and realistic routine moments
- helps the feed feel lived-in and believable
- keep it secondary to `Set 1`

`Set 5: Warm Trust Portrait`

- use for trust posts, reassurance posts, advisor-style authority, and calm credibility moments
- this adds warmth and confidence to the system without changing the brand world

## Final Rule

The brand should look consistent enough to be recognizable and varied enough to stay alive.

That is the production standard.
