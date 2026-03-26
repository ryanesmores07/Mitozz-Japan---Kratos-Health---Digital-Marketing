# Mitozz Template Library Index

## Purpose

This file is the operational mapping layer between the content calendar and the Mitozz design system.

Use it together with the central mapping config so image generation can become more consistent and more automatable without changing the calendar schema.

The goal is:

- every calendar row maps to a template set
- every image generation starts from that assigned template
- the full grid stays visually consistent because all templates belong to the same `Steel Light System`

## Master Rule

Every feed or story asset should resolve to a designated `Template Set` before creative generation starts.

That template assignment should come from the mapping rules plus the calendar strategy fields, not be guessed later during prompt creation.

## Brand Hierarchy

`Set 1: Education White Card` is the primary Mitozz template family.

This is the main visual signature the feed should be known for.
It should be the most repeated system across the grid because it best captures the premium, creative, educational identity of the brand.

The other sets are support systems:

- `Set 2` extends `Set 1`
- `Set 3` handles product presence
- `Set 4` brings lifestyle realism
- `Set 5` brings trust and authority

Primary config:

- [template-mapping-rules.json](template-mapping-rules.json)

## Template Library

### `Set 1`

Name:

`Education White Card`

Primary use:

- main Mitozz feed signature
- educational covers
- mitochondria explainers
- ingredient introductions
- save-worthy text-first frames

Default prompt direction:

- white-led
- text-first
- calm abstract science cue

Production master:

- [Mitozz Set 1 Master Template Spec.md](Mitozz%20Set%201%20Master%20Template%20Spec.md)

### `Set 2`

Name:

`Editorial Science Layer`

Primary use:

- support mode for `Set 1`
- mid-carousel education slides
- frameworks
- comparisons
- structured concept breakdowns

Default prompt direction:

- layered editorial layout
- one supporting visual or abstract device
- slightly more offset composition

### `Set 3`

Name:

`Luminous Product Hero`

Primary use:

- product-led posts
- end-card CTA slides
- product relevance frames
- ritual product emphasis

Default prompt file:

- [ig-feed-2026-03-21-template-set-3-product-hero-v01.json](../../../../prompts/instagram/feed/ig-feed-2026-03-21-template-set-3-product-hero-v01.json)
- locked bottle version: [ig-feed-2026-03-21-template-set-3-locked-bottle-v01.json](../../../../prompts/instagram/feed/ig-feed-2026-03-21-template-set-3-locked-bottle-v01.json)

### `Set 4`

Name:

`Real-Life Ritual Lifestyle`

Primary use:

- lifestyle posts
- routine scenes
- realistic daily-condition visuals
- bridge frames between education and product

Default prompt file:

- [ig-feed-2026-03-21-template-set-4-ritual-lifestyle-v01.json](../../../../prompts/instagram/feed/ig-feed-2026-03-21-template-set-4-ritual-lifestyle-v01.json)

### `Set 5`

Name:

`Warm Trust Portrait`

Primary use:

- expert or authority posts
- advisor-style trust content
- calm credibility slides
- proof and reassurance frames

Default prompt file:

- [ig-feed-2026-03-21-template-set-5-trust-portrait-v01.json](../../../../prompts/instagram/feed/ig-feed-2026-03-21-template-set-5-trust-portrait-v01.json)

## Mapping Rules

Going forward, the automation layer should resolve at least these two production fields:

- `Template Set`
- `Slide Blueprint`

### `Template Set`

This is the primary visual system for the asset.

Allowed values:

- `Set 1`
- `Set 2`
- `Set 3`
- `Set 4`
- `Set 5`
- `Set 1 + Set 2`
- `Set 1 + Set 2 + Set 3`
- `Set 4 + Set 3`
- `Set 5 + Set 1`

Use one value for static posts and stories.
Use a mixed value for carousels and reels when needed.

### `Slide Blueprint`

This is the structural map for how the template set should behave across the asset.

Allowed default values:

- `1-slide`
- `3-slide`
- `5-slide`
- `7-slide`
- `10-slide`
- `story-3-frame`
- `reel-4-shot`
- `reel-5-shot`

## Default Mapping By Format

`Carousel`

- default `Template Set`: `Set 1 + Set 2`
- default `Slide Blueprint`: `5-slide`

`Reel`

- default `Template Set`: `Set 4 + Set 3`
- default `Slide Blueprint`: `reel-4-shot`

`Static Post`

- default `Template Set`: depends on post type
- default `Slide Blueprint`: `1-slide`

`Story`

- default `Template Set`: simplified `Set 1`, `Set 4`, or `Set 5`
- default `Slide Blueprint`: `story-3-frame`

## Default Mapping By Post Type

Educational explainer:

- template: `Set 1 + Set 2`
- blueprint: `5-slide`

Ingredient explainer:

- template: `Set 1 + Set 2`
- blueprint: `5-slide` or `7-slide`

Product post:

- template: `Set 3`
- blueprint: `1-slide`
- workflow: `locked bottle workflow` when pack fidelity matters

Lifestyle post:

- template: `Set 4 + Set 1`
- blueprint: `3-slide` or `1-slide`

Authority post:

- template: `Set 5 + Set 1`
- blueprint: `1-slide` or `3-slide`

Story reinforcement:

- template: `Set 1`
- blueprint: `story-3-frame`

Poll or question story:

- template: `Set 4` or `Set 5`
- blueprint: `story-3-frame`

Reel about daily condition or routine:

- template: `Set 4 + Set 3`
- blueprint: `reel-4-shot`

## Grid Consistency Rule

Different template sets are allowed, but the grid should still feel unified because every set must preserve:

- the same palette family
- the same whitespace discipline
- the same typography logic
- the same premium restraint
- the same calm science-led tone

This means variety happens inside one brand world, not across unrelated aesthetics.

In practice:

- the grid should mostly read as `Education White Card`
- product, lifestyle, and trust modes should orbit that core system
- consistency comes from repeating the same main signature while rotating supporting modes carefully

## Workflow Rule

The content calendar should stay strategy-focused and the mapping config should make the template decision early.

Recommended flow:

1. content calendar assigns strategy fields such as `Format`, `Content Pillar`, `Objective`, and `Primary Persona`
2. mapping config resolves `Template Set` and `Slide Blueprint`
3. creative package follows that assignment and only refines execution
4. prompt generation uses the assigned template as the starting system
5. image generation stays inside the designated template family

## Calendar Schema

No calendar schema change is required for the automation to work.

Keep the current shared calendar fields and let the rules file derive visual assignments.

## Automation Rule

If the mapping rules resolve `Template Set` and `Slide Blueprint`, downstream steps should not re-decide the visual system unless the user explicitly overrides it.

That is the key to making the design process more automatable and more consistent over time.
