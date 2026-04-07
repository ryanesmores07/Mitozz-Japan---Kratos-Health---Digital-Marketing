# Canva Carousel Setup

## Purpose

This file defines the clean-slate Canva setup for Mitozz Japan Instagram carousels.

Use it when building or maintaining the Canva workspace so Canva stays aligned with the repo brand system instead of becoming a separate design language.

## Current Canva State

As checked on `2026-04-07`:

- Brand kit found: `Mitozz Japan`
- Top-level folder found: `Mitozz Japan`
- Carousel workspace folder found: `Mitozz Japan - Carousels`

The carousel folder was empty at setup time, so it is safe to treat as the clean production lane.

Created inside `Mitozz Japan - Carousels`:

- `01 Carousel Masters`
- `02 Working Drafts`
- `03 Approved Finals`
- `04 Reference Assets`

Created inside `01 Carousel Masters`:

- `Set 1 - Education White Card`
- `Set 2 - Editorial Science Layer`
- `Set 3 - Luminous Product Hero`
- `Set 4 - Real-Life Ritual Lifestyle`
- `Set 5 - Warm Trust Portrait`
- `Shared Components`

## Operating Decision

Ignore the existing Canva brand kit completely for the initial rollout.

Treat the Canva carousel lane as a clean system built from repo rules and controlled masters only.

Source files for this lane:

- `Canva Carousel Setup.md`
- `Canva Carousel Master Library.md`
- `Canva Carousel Build Queue.md`

## Canva Folder Rules

`01 Carousel Masters`

- keep only approved reusable carousel masters here
- create one master per template family, not one per post
- never use this folder for live editing once a draft is in motion

`02 Working Drafts`

- duplicate from a master into this folder before making post-specific edits
- name files by date and topic

`03 Approved Finals`

- move only approved publication-ready versions here
- one final design per post unless variant testing is intentional

`04 Reference Assets`

- keep approved product cutouts, portraits, textures, and brand-safe background plates here
- do not store random inspiration images here

## Naming Rules

Use names that match the repo production flow.

Recommended pattern:

- master templates: `MJ Carousel - Set X - [Family] - Master`
- working files: `MJ Carousel - YYYY-MM-DD - [Topic] - v01`
- approved finals: `MJ Carousel - YYYY-MM-DD - [Topic] - Final`

## Brand Translation For Canva

### Visual Mood

Keep the Canva system inside the existing Mitozz visual world:

- airy
- clinical but not cold
- premium but not intimidating
- calm, luminous, editorial

Working theme:

- `Steel Light`

Mood sentence:

- `Soft science, clear skin, quiet confidence.`

### Color Palette

Use these as the core Canva brand colors:

- Cloud White: `#F7FAFC`
- Mist Blue: `#DCE8EE`
- Steel Blue: `#6F8794`
- Mineral Navy: `#22323B`
- Apricot Glow: `#F48A5A`
- Soft Peach Tint: `#F7E5DC`
- Frost Silver: `#EEF2F4`
- Warm Sand: `#E9DDD3`

Usage balance:

- 60% white / pale neutral space
- 20% mist blue atmosphere
- 10% steel blue structure
- 8% apricot highlight
- 2% mineral navy anchor

Do not introduce:

- royal blue
- pure black
- neon orange
- heavy dark backgrounds

### Typography

Primary Japanese system:

- `Hiragino Sans`
- weights: `W3`, `W4`, `W6`

Editorial accent:

- `Hiragino Mincho ProN`
- use only for short accent moments, not dense educational copy

If Canva font availability differs, keep the same hierarchy:

- primary Japanese sans for all educational reading
- restrained serif accent only for premium emphasis

## Carousel Master Template Rules

The default Mitozz carousel system in Canva should map to the repo default:

- default template family: `Set 1 + Set 2`
- default blueprint: `5-slide`

That means the first Canva masters to build should be:

1. `Set 1 Cover Master`
2. `Set 2 Body Master`
3. `Set 2 Comparison / Framework Master`
4. `Set 1 Close Master`

### Slide Jobs

Recommended 5-slide job split:

1. hook
2. context
3. explanation
4. practical takeaway
5. soft close or CTA

Each slide should carry one idea only.

### Layout Rules

- build for `1080 x 1350`
- keep generous outer margins
- use pale backgrounds by default
- use thin dividers, soft washes, and rounded cards
- avoid dense sticker-like decoration
- avoid more than one focal element per slide

### Cover Rules

- one headline only
- short, save-worthy promise
- large type
- pale background
- one simple support visual only

### Body Slide Rules

- short copy blocks
- strong hierarchy
- no paragraph walls
- use chips, dividers, or mini-panels instead of clutter

### Closing Slide Rules

- keep product or CTA presence calm
- no hard-sell design language
- one action only

## Template Family Mapping

Use this when deciding which Canva master to duplicate:

- `Set 1`: white educational card, primary brand signature
- `Set 2`: editorial science support slides for frameworks and comparisons
- `Set 3`: product-led hero or end-card
- `Set 4`: lifestyle or routine realism
- `Set 5`: trust, authority, or expert reassurance

For most carousels, start from `Set 1 + Set 2`.

## What Canva Should Own

Canva is a strong fit for:

- reusable carousel master templates
- copy swaps on stable layouts
- simple manual editing and collaboration
- quick duplication of a proven carousel system

Canva should not replace the repo as source of truth for:

- brand rules
- template mapping logic
- production naming logic
- prompt history

## Next Recommended Build Order

1. Build the Priority 1 batch from `Canva Carousel Build Queue.md`.
2. Use `Canva Carousel Master Library.md` as the naming and structural source of truth for all `45` masters.
3. Duplicate any live post from `01 Carousel Masters` into `02 Working Drafts` before editing.
4. Move only approved designs into `03 Approved Finals`.
