# Mitozz Bottle Label Spec

## Purpose

Use this whenever the Mitozz bottle appears and visible label truth matters.

This file exists because "accurate bottle" is too vague on its own.
The prompt must explicitly describe the visible front-label copy and block structure so the generator has concrete pack instructions.

## Source Of Truth

Approved reference image:

- `brand/references/business-context/visual/reference-pack/source-intake/mitozz-bottle.jpg`

## Locked Front Label Description

Describe the visible front label like this in prompts:

- matte black bottle body
- black ribbed cap
- centered white `MITOZZ` wordmark across the front
- small white footer text at bottom left: `60 Capsules`
- small white footer text at bottom right: `Net Weight: 30 g`

## Locked Structure Rules

Also describe the visible label structure:

- main front face is predominantly black, not a white sticker panel
- the `MITOZZ` wordmark is the dominant visible front element
- the footer copy sits low on the bottle body in two small text blocks
- visible side-label behavior may appear as narrow white information columns near the edges, but the front should still read as a black bottle with centered white brand typography

## Prompting Rule

Do not stop at "preserve label fidelity."

For bottle-led prompts, explicitly write:

- the front label must show `MITOZZ`
- the bottom-left footer must read `60 Capsules`
- the bottom-right footer must read `Net Weight: 30 g`
- do not invent extra front subtitle text that is not clearly supported by the approved reference image

If the shot angle makes some footer text only partially visible, the structure should still remain faithful to the approved pack.

## Rejection Rule

Reject and regenerate if:

- the visible wordmark is not `MITOZZ`
- invented subtitle copy appears on the front
- the footer text blocks disappear, drift, or become generic fake microcopy
- the front face becomes a generic supplement label instead of the approved Mitozz structure
