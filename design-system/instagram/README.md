# Instagram Design-First Compositor

This system keeps layout, typography, spacing, and copy under code control for text-led Instagram assets.

Use it when:

- the asset is text-first
- typography accuracy matters
- layout consistency matters more than AI novelty
- you want AI to generate image slots only, not the full card

Do not use it as the default for:

- bottle-led product realism shots
- lifestyle-heavy single-image posts
- reel source frames
- assets where the whole scene needs to be invented by AI

## Core Idea

1. Build the card in HTML/CSS.
2. Fill the copy from JSON.
3. Drop approved AI imagery into controlled image zones only.
4. Export the final slide from the browser renderer.

This makes code the source of truth for:

- Japanese copy
- font family and weight
- line breaks
- spacing
- alignment
- card radius
- border / perimeter wash
- CTA micro-cues

## Lane Selection

Use the `HTML/CSS template lane` when:

- the layout behavior is likely to repeat across more than one post
- the same skeleton should support multiple copy swaps or image-slot swaps
- batch consistency matters more than one-off art direction
- we want the lowest-maintenance path for future reuse

Use the `PowerShell compositor lane` when:

- the asset is a custom one-off family that is not yet stable enough to promote
- the approved composition depends on hand-tuned drawing, measured centering, or custom panel logic
- we need a quick controlled build without prematurely abstracting it into a reusable template

Promotion rule:

- if a PowerShell compositor layout family proves useful across at least 2 approved assets, decide whether it should graduate into the reusable HTML/CSS template lane
- do not keep cloning one-off renderer scripts indefinitely when the behavior is clearly becoming a reusable template family
- do not force every new idea into the template lane before the layout grammar is actually stable

Layout rule for this lane:

- use `CSS Grid` for macro structure
- use `Flexbox` for internal stacking, chips, tag rows, and centered micro-alignment
- reserve absolute positioning for media plates, masks, glow layers, and decorative motifs only
- if a box, band, comparison row, or table-like module can be aligned by shared grid tracks, do not eyeball it with manual offsets

When Japanese copy quality matters, use explicit `headline_lines` and `subline_lines` in the data JSON instead of relying on browser wraps.

## Structure

- `templates/`
  - reusable HTML shells
- `styles/`
  - shared CSS tokens and component rules
- `tokens/`
  - shared Steel Light palette tokens, typography tokens, and approved variants
- `data/`
  - per-asset JSON content

Current palette source of truth:

- [mitozz-steel-light.tokens.psd1](C:\Users\esmoresernieryanocam\Desktop\Workspace\Mitozz%20Japan\design-system\instagram\tokens\mitozz-steel-light.tokens.psd1)
- [mitozz-typography.tokens.psd1](C:\Users\esmoresernieryanocam\Desktop\Workspace\Mitozz%20Japan\design-system\instagram\tokens\mitozz-typography.tokens.psd1)

Current typography helper:

- [load-mitozz-typography-tokens.ps1](C:\Users\esmoresernieryanocam\Desktop\Workspace\Mitozz%20Japan\tools\shared\load-mitozz-typography-tokens.ps1)

Cross-lane typography rule:

- the HTML/CSS template lane and the PowerShell compositor lane must read from the same shared typography token file
- font-profile family stacks, accent stacks, and reusable role scales should live in `mitozz-typography.tokens.psd1`, not in per-asset renderers
- if an HTML/CSS template needs a different approved type profile, use `-FontProfile` at render time or set `font_profile` in the asset JSON
- if a compositor script keeps getting reused, move any typography roles it depends on into the shared token file before cloning the script again
- do not let the template lane and compositor lane drift into separate headline sizes, tracking defaults, or line-height logic for the same family without an explicit system decision

Use the typography helper when compositor assets need:

- deliberate Japanese headline tracking
- near-solid Japanese body copy and short-label spacing
- shared line-height values by role
- measured centering for labels and chips
- typographic measurement instead of default loose glyph bounds for tracked centering
- more consistent margin and padding behavior across slides

HTML/CSS template rule:

- macro layout should follow shared grid tracks
- local content blocks should use flex or grid, not nested absolute nudges
- equal-width modules should use explicit grid columns such as `repeat(2|3|4, minmax(0, 1fr))`

## Rendering

Use:

- [render-instagram-template.ps1](C:\Users\esmoresernieryanocam\Desktop\Workspace\Mitozz%20Japan\tools\render-instagram-template.ps1)
- [render-instagram-batch.ps1](C:\Users\esmoresernieryanocam\Desktop\Workspace\Mitozz%20Japan\tools\render-instagram-batch.ps1)

The renderer:

- injects JSON data into the HTML
- injects the shared Steel Light palette tokens into the CSS
- injects the shared typography token block into the CSS
- converts local image paths into browser-safe file URIs
- inlines the shared CSS
- prefers the headless browser renderer in `auto` mode
- falls back to WinForms only if browser rendering is unavailable
- exports a final image from the renderer

Modern frontend note:

- the preferred renderer for this lane is headless Edge or Chrome
- the WinForms fallback is legacy-safe, but modern layout work should assume the browser path

Palette control:

- `render-instagram-template.ps1` supports `-PaletteVariant default|cool_focus|warm_editorial`
- `render-instagram-batch.ps1` supports `-PaletteVariant default|cool_focus|warm_editorial`
- use these variants instead of ad hoc recoloring when a template asset needs a cooler or warmer mood

## Current MVP

The first template is:

- `trust-carousel`

It supports three variants:

- `portrait-cover`
- `editorial-criteria`
- `editorial-close`

This is enough to prototype the March 30 trust carousel and prove the workflow.

## Image Slot Rules

For image-bearing templates:

- use raw image plates without baked-in text
- keep the image inside its assigned zone; do not ask AI to redraw the whole card
- if the source image already contains text or framing junk, treat it as an invalid slot asset and replace it

For `portrait-cover` specifically:

- the portrait lives on the right side only
- the left text column must remain protected even if the image source is imperfect

## Long-Term Rule

For text-led carousels and stories:

- AI generates the image slot only
- HTML/CSS renders the final post

That should reduce prompt drift, token waste, and layout inconsistency over time.
