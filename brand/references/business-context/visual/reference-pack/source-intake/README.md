# Source Intake

This folder stores extra visual inputs that are not part of the active style-anchor set.

Use it as a holding area when:

- an image influenced the direction but is too repetitive to become an anchor
- an image is useful for future review but should not dominate current generation style
- you want to keep the active `style-anchors/` set lean
- you need approved product-truth source photos for accurate packshot generation

## Current Approved Product Sources

The following files are approved as Mitozz bottle source references:

- `mitozz-bottle.jpg`
- `mitozz-bottle-with-tablets.jpg`

These files may be used downstream for:

- bottle shape and cap accuracy
- label placement and overall pack fidelity
- tablet relationship when a product-plus-tablets composition is needed

Guardrails:

- use these as product-truth references, not style anchors
- do not let them dominate palette, composition, typography, or overall art direction
- pair them with `style-anchors/` or other approved layout references when building prompt `image_references`
- prefer `mitozz-bottle.jpg` for clean hero/product-only shots
- prefer `mitozz-bottle-with-tablets.jpg` when the concept benefits from tablets in frame
