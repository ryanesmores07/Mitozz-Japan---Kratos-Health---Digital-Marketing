# Mitozz Bottle Size Spec

## Purpose

This file replaces the need to use `mitozz hand held.webp` directly in future generations.

Use it to keep bottle scale believable in lifestyle, desk, and reel scenes.

## Source Basis

The size rule was extracted from:

- `brand/references/business-context/visual/reference-pack/source-intake/mitozz hand held.webp`

Guide image dimensions:

- `750 x 1217`

That image is now a calibration source only, not an active generation reference.

## Locked Scale Rule

For bottle-in-hand or bottle-near-hand scenes:

- bottle should read as a normal one-hand supplement bottle
- bottle height should stay around `18% to 22%` of the full frame height
- bottle width should stay around `14% to 18%` of the full frame width
- bottle should feel close to one palm-length plus cap, not like a large thermos or jar

For `9:16` reel source frames at `1536 x 2752`, use this practical target:

- bottle height target: `500 px to 605 px`
- bottle width target: `215 px to 275 px`

These are target ranges, not rigid crop rules.
Stay inside the range unless the frame is a pure product hero.

## Desk Scene Rule

In lifestyle desk scenes:

- bottle should feel modest and believable
- bottle should usually sit around mug-height or slightly taller
- bottle must not dominate the tabletop
- if a hand is touching the bottle, the bottle should still feel fully graspable by one adult hand

## Product Hero Exception

Pure product hero frames may exceed this size range slightly.

Do not apply the lifestyle scale rule to:

- isolated Set 3 hero plates
- pack-only product compositions
- deliberate close crop product details

## Approval Rule

Reject and regenerate if:

- the bottle feels oversized for the hand
- the bottle dominates a lifestyle desk scene
- the bottle feels too large relative to mugs, notebooks, or fingers
- the bottle reads more like an ad prop than a real daily object

## Prompting Shortcut

Use this language in prompts:

`Use the Mitozz bottle size spec. Keep the bottle at a believable one-hand supplement-bottle scale: roughly 18% to 22% of frame height and 14% to 18% of frame width in lifestyle or desk scenes. In a 1536 x 2752 reel frame, target roughly 500 to 605 px tall and 215 to 275 px wide unless the shot is a pure product hero.`
