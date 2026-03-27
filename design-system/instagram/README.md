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

## Structure

- `templates/`
  - reusable HTML shells
- `styles/`
  - shared CSS tokens and component rules
- `data/`
  - per-asset JSON content

## Rendering

Use:

- [render-instagram-template.ps1](C:\Users\esmoresernieryanocam\Desktop\Workspace\Nano banana\tools\render-instagram-template.ps1)
- [render-instagram-batch.ps1](C:\Users\esmoresernieryanocam\Desktop\Workspace\Nano banana\tools\render-instagram-batch.ps1)

The renderer:

- injects JSON data into the HTML
- converts local image paths into browser-safe file URIs
- inlines the shared CSS
- prefers the headless browser renderer in `auto` mode
- falls back to WinForms only if browser rendering is unavailable
- exports a final image from the renderer

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
