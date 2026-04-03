---
name: mitozz-stock-image-sourcing
description: Source stock-style images for Mitozz Japan creatives using the local Unsplash Smart MCP Server only when the user explicitly wants a real stock-photo lane or reference scouting.
---

# Mitozz Stock Image Sourcing

Use this skill only when a Mitozz creative explicitly needs a real-photo stock lane or when the task is reference scouting rather than custom image generation.

This skill defines the narrow cases where Unsplash should still be used inside the Mitozz workflow.

## Primary Tool

Use the local Unsplash Smart MCP Server installed in this workspace at:

- `C:\Users\esmoresernieryanocam\Desktop\Workspace\Mitozz Japan\tools\unsplash-smart-mcp-server`

Treat it as the stock-photo source lane.

## When To Use Unsplash

Use Unsplash when the user explicitly wants:

- a real-photo stock look instead of a generated image
- reference scouting before a creative direction is locked
- an external realism check against what Nano Banana is producing

Good fits after that explicit choice:

- workday desk atmosphere
- morning light on a table
- clean food ingredient context
- soft movement or walking support imagery
- architectural or environmental calm

## When Not To Use Unsplash

Do not use Unsplash when:

- the real Mitozz bottle must be visible
- exact product truth matters
- the concept needs a custom scene tailored tightly to the copy
- generated imagery would align better with the brand composition
In those cases, prefer:

- `owned-real-photo`
- `Nano-Banana-source-image`

## Mitozz Selection Rules

Choose images that feel:

- premium
- calm
- natural
- editorial
- softly lit
- uncluttered

Avoid images that feel:

- generic corporate stock
- fake startup marketing
- overly fitness-led
- loud, saturated, or ad-like
- medically theatrical
- emotionally exaggerated

## Composition Rules

Prefer images with:

- negative space for copy
- clear focal hierarchy
- restrained color
- believable natural light
- clean surfaces
- simple scenes

Avoid images with:

- busy backgrounds
- heavy visual noise
- too many people
- obvious staged stock-photo gestures
- hard-to-read overlays zones

## Workflow Rule

When a creative needs imagery, decide source order like this:

1. `owned-real-photo` if product truth or owned brand imagery matters
2. `Nano-Banana-source-image` for fresh cover plates, support plates, and overlay-aware source images
3. `Unsplash stock image` only when the user explicitly wants real stock or reference scouting

Do not default to Unsplash just because it is available.
Use it only when real stock is intentionally the right answer.

## Output Guidance

When you use Unsplash for a creative, record:

- why stock was chosen
- the selected image role
- photographer attribution if required downstream
- where the asset is used in the batch
- whether the image is a background, support plate, or main visual
