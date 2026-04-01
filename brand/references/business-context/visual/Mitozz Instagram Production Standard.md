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

- [Mitozz Feed Engagement Standard.md](Mitozz%20Feed%20Engagement%20Standard.md)

Story operating rules:

- [Mitozz Instagram Story Strategy.md](Mitozz%20Instagram%20Story%20Strategy.md)

## Default Production Order

Use this order for day-to-day production:

1. read the approved calendar row
2. resolve the post-calendar production layer:
   `Template Set`, `Slide Blueprint`, `asset_archetype`, `story_type`, and `story_delivery_mode` when needed
3. lock `visual_engine`, `anchor_set`, `source_lane`, `source_strategy`, `fallback_source`, `icon_strategy`, and `generated_visual_role`
4. choose the correct approved references from the reference pack
5. build the creative package
6. generate the asset or source plate
7. review against the approval rules and [Mitozz Asset Review Gate.md](Mitozz%20Asset%20Review%20Gate.md) before promotion

## Approved Production System

The Mitozz grid should operate like a premium brand system, not a one-off design exercise.

Use the same core template families repeatedly.
Vary execution inside those families.

## Visual Engine Lock

Every feed post and Story set must choose one primary visual engine before production:

- `image-led`
- `type-led`
- `diagram-led`

This choice happens in:

- [workflows/03B-visual-engine-preflight.md](../../../../workflows/03B-visual-engine-preflight.md)

Default rules:

- routine, lifestyle, body-state, trust, and product-in-context topics should default to `image-led`
- comparisons, frameworks, myth-versus-fact, and decision logic should default to `diagram-led`
- editorial reframes, short FAQs, and sharp educational statements can default to `type-led`

Do not let a routine-led or lifestyle-led topic become type-led only because layout production was faster.

If `type-led` is chosen for a lived-experience topic, the reason should be explicit before generation.

## Default Enhancement Rule

Every asset must also make two explicit enhancement decisions before execution:

- `icon_strategy`
- `generated_visual_role`

This means we do not default to plain text layouts just because they are faster to assemble.

Ask two questions every time:

1. would Better Icons improve clarity here
2. would a generated support visual improve engagement here

If the answer is no, record `none` intentionally.

## Template Hierarchy

`Set 1: Education White Card` is the primary Mitozz feed signature.

This is the main template family the brand should be recognized for.
It should appear most often on the grid and define the premium, unique, education-first look of the account.

Production master:

- [Mitozz Set 1 Master Template Spec.md](Mitozz%20Set%201%20Master%20Template%20Spec.md)

Prompt-ready lock:

- [prompt-template.json](../../../../prompts/instagram/shared/prompt-template.json)

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

## Token Lock

Use the shared palette token source as the production default:

- [mitozz-steel-light.tokens.psd1](../../../../design-system/instagram/tokens/mitozz-steel-light.tokens.psd1)

Do not hardcode one-off palette values in new renderers when the shared tokens can provide them.

Approved palette variants:

- `default`
- `cool_focus`
- `warm_editorial`

Rule:

- creative exploration is allowed inside these approved variants
- do not introduce a new hue family just because one asset wants more novelty
- keep batch consistency inside the chosen variant

## Typography Lock

Typography is locked as a system, not an asset-by-asset interpretation.

For `Set 1` and `Set 2`:

- use one Japanese sans-serif family consistently
- keep the typographic personality stable across the whole carousel or story set
- do not let inner slides drift into heavier, lighter, or more decorative text styles

Production lock:

- cover headline: `Hiragino Sans W6`
- cover supporting line: `Hiragino Sans W4`
- inner carousel slides: `Hiragino Sans W4`
- carousel CTA slide: `Hiragino Sans W4`
- story frames: `Hiragino Sans W4`
- optional editorial accent: `Hiragino Mincho ProN W3` or `W6` for very short labels, numerals, or micro-accents only when the full batch was intentionally designed that way

Emphasis should come from:

- spacing
- line breaks
- card scale
- placement
- contrast against whitespace

Japanese line-break lock:

- define key headline lines by meaning unit
- define sublines explicitly when auto-wrap produces awkward rhythm
- do not let cover hooks or CTA lines depend on accidental browser wraps
- if punctuation, particles, or compound phrases land awkwardly, refine the layout before approval

Micro-alignment lock:

- text inside narrow side bands, selector tiles, row labels, chips, and note cards must be optically centered when the module reads as a centered label
- do not rely on default text origins when a module needs horizontal or vertical centering
- if a centered label looks even slightly off, fix the coordinates before approval
- closing-note cards should behave like closing-note cards, not like reused left-aligned body cards

Template-scaffolding lock:

- internal process labels must never appear in production-facing artwork
- do not leak `Set` names, reference codes, English workflow scaffolding, or QA markers into final assets
- if a colored strip, badge, or side band visually behaves like a label area, give it meaningful viewer-facing content or redesign it as a true accent area
- do not leave empty-looking label bands that read like unfinished template residue

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
- if module alignment, label semantics, or closing-card balance drift, regenerate the incorrect slide
- only promote slides that pass the locked system checks
- do not present first-pass assets as final delivery before they pass the review gate

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

## Icon Rule

Icons are allowed when they add semantic clarity.

Use icons for:

- selector tiles
- answer-card labels
- framework cues
- small CTA support
- comparison markers

Do not use icons as decorative filler.

Production rules:

- use one icon family per asset or batch
- keep icon treatment consistent
- prefer simple editorial icons over playful or app-like sets
- if an icon is needed, source it intentionally instead of drawing random symbolic shapes
- route icon sourcing through the Better Icons MCP lane when icons are chosen

## Generated Support Visual Rule

Generated visuals are encouraged when they materially improve the asset.

Good uses:

- subtle backgrounds
- infographic-support elements
- hero visuals
- support plates
- restrained scientific or editorial support forms

Do not use generated visuals as filler.

Production rules:

- the generated layer must support the chosen visual engine, not fight it
- keep it restrained enough that copy and hierarchy still lead
- prefer Nano Banana when the support visual should be custom rather than stock
- if a generated layer is chosen, document its role clearly in the creative package

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

Visual defaults:

- `Set 1 + Set 2` education posts can be `type-led` or `diagram-led`, but should still become `image-led` when the topic is lived-in or routine-based
- `Set 4` should usually be `image-led`
- `Set 5` should usually be `image-led`
- `Set 3` should use real-photo truth when the product is visible
- Story whitespace should be used intentionally; the middle of the frame should carry structure, context, or a support module rather than feeling accidentally empty
- If a Story card is teaching named categories like `睡眠 / 食事 / 運動`, prefer those labels inside the module over abstract numbers unless sequence itself is the point

Stock-image defaults:

- use Unsplash when a premium real-photo support image is enough
- use Nano Banana when the image needs stronger custom composition, more exact contextual fit, or more brand-specific staging than stock can reliably provide

Story composition defaults:

- use the top, center, and bottom of the frame strategically when the message benefits from clearer vertical rhythm
- do not force fillers just to occupy space; each zone should have a compositional job or stay intentionally quiet
- if a Story feels top-heavy, solve it with guidance, support structure, or a meaningful module before adding decoration
- large Japanese headlines should be checked for optical tracking and rhythm so they do not feel cramped even when line breaks are correct
- avoid repeating the same core terms multiple times inside one frame unless the repetition is doing clear hierarchy or navigation work
- when a horizontal strip is divided into columns, center the text inside each actual column, not by rough visual guesses
- fix cramped titles with a combination of line height, tracking, and size adjustment rather than only shrinking the type

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
