# Mitozz Approved Post Library

## Purpose

This file pair is the memory layer for approved Mitozz Instagram production.

Use it to track every approved or production-ready feed post and Story set so we can:

- reuse strong systems intentionally
- avoid accidental repetition
- know which parts are safe to repeat
- know which parts should be switched up next time
- remember whether an asset used full AI, a compositor path, a real-photo workflow, or Nano Banana source imagery

Canonical data file:

- [Mitozz Approved Post Library.csv](Mitozz%20Approved%20Post%20Library.csv)

## Why This Exists

Big-brand behavior is usually not "invent a new design language every post."

The stronger pattern is:

- repeat a small number of recognizable families
- rotate crop, pacing, image treatment, and hook angle
- keep a memory of what has already been used so reuse stays strategic instead of lazy

`working-examples/` is visual proof.
This post library is operating memory.

## What To Log

Log every approved or production-ready feed post and Story set with:

- date
- channel
- asset id
- topic
- template set
- slide blueprint
- asset archetype
- source strategy
- reuse role
- what is safe to reuse
- what should change next time
- prompt path
- output path

Do not log raw first passes, rejected variants, or exploratory references here.

## Source Strategy Values

Use one of these descriptions:

- `full-ai generated asset`
- `design-first compositor + existing image plate`
- `design-first compositor + abstract system graphics`
- `design-first compositor + Nano Banana source image`
- `real-photo composition workflow`
- `Nano Banana stock-style source image`
- `Nano Banana reel source-frame set`

Keep the wording simple and consistent.

## Reuse Rule

Safe to reuse:

- template family
- structural role
- prompt logic
- typography system
- source-image strategy
- support motif category

Do not reuse literally:

- exact crop
- exact portrait framing
- exact headline line breaks
- exact support graphic placement
- exact slide pacing when the same audience would notice repetition

## Switch-Up Rule

Every row should note what to switch up next time.

Good switch-up examples:

- change the cover crop, keep the same template family
- keep the trust portrait mode, change the age range or framing distance
- keep the white-card story system, change the support cue and text rhythm
- keep the same question-led structure, change the emotional temperature

## Working-Example Rule

An approved post can live in the library without becoming a `working-example`.

Use this split:

- post library = all approved feed and Story outputs we may want to remember
- `working-examples/` = only the few outputs that are safe to reuse visually as active references

## Stock-Image Rule

If a feed or Story needs stock-style human, lifestyle, object, or environment imagery and no real shoot or owned source is required:

- do not default to outside stock
- have the prompt engineer create a dedicated Nano Banana source-image prompt
- generate the source image through Nano Banana MCP
- keep text-led layouts design-first whenever possible
- record the final source strategy in the post library after approval

In practice:

- Nano Banana should create the image plate or background
- HTML/CSS or the locked production layout should still own text, spacing, and line breaks for text-led assets

## Update Timing

Update the library when:

- a feed post becomes approved or production-ready
- a Story set becomes approved or production-ready
- a live asset gets materially replaced by a newer approved version

If an asset is superseded, update its row instead of creating duplicate confusion.
