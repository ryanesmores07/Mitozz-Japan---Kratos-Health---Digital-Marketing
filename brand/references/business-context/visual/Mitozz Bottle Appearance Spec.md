# Mitozz Bottle Appearance Spec

## Purpose

Use this whenever the Mitozz bottle appears and visible pack appearance matters.

The reference image alone is not enough.
The prompt must explicitly describe the bottle's color, finish, cap, neck band, and front-face behavior in words so generation stays locked.

## Source Of Truth

Approved appearance reference:

- `brand/references/business-context/visual/reference-pack/source-intake/mitozz-bottle.png`

## Locked Appearance Description

Describe the bottle like this in prompts:

- deep matte black bottle body
- black ribbed cap
- visible pale white neck band directly below the cap
- predominantly black front face, not a white label wrap
- centered white `MITOZZ` wordmark on the front
- low-contrast small footer copy near the bottom of the front face

## Color And Finish Rules

Explicitly state:

- the bottle body must stay deep matte black
- do not let the bottle drift into gray, charcoal, washed-out black, or glossy black
- the bottle should hold a soft matte finish, not a reflective commercial gloss
- adapt highlights and shadows to the scene, but do not lighten the bottle body so much that it stops reading as black

## Structure Rules

Explicitly state:

- the cap is black and vertically ribbed
- a pale white neck band remains visible under the cap
- the front face stays mostly black with white typography, not a white sticker block
- narrow side information columns may appear near the left and right bottle edges

## Prompting Rule

For bottle-led prompts, explicitly write:

- `deep matte black bottle body`
- `black ribbed cap`
- `visible pale white neck band below the cap`
- `predominantly black front face with centered white MITOZZ wordmark`

Do not rely on vague wording like:

- `accurate bottle`
- `preserve pack fidelity`
- `match the product reference`

Those can stay in the prompt, but they are not enough on their own.

## Rejection Rule

Reject and regenerate if:

- the bottle body shifts away from deep matte black
- the cap is not black and ribbed
- the neck band disappears or becomes black
- the front face becomes a generic white label panel
- the bottle finish becomes glossy or metallic
