# Mitozz Set 1 Master Template Spec

## Purpose

This is the production master for `Set 1: Education White Card`.

Use it to keep future `Set 1` feed assets visually consistent without redesigning the template each time.

This is intentionally lean.
It locks only the decisions that should not drift:

- canvas structure
- spacing behavior
- typography hierarchy
- visual restraint
- support-image behavior

## Master Reference

Approved master set:

- cover: [slide-01-cover.png](../../../../output/instagram/feed/2026-03-23-feed-mitochondria-basics-v01/slide-01-cover.png)
- slide 2: [slide-02-core-message.png](../../../../output/instagram/feed/2026-03-23-feed-mitochondria-basics-v01/slide-02-core-message.png)
- slide 3: [slide-03-relevance.png](../../../../output/instagram/feed/2026-03-23-feed-mitochondria-basics-v01/slide-03-relevance.png)
- slide 4: [slide-04-first-step.png](../../../../output/instagram/feed/2026-03-23-feed-mitochondria-basics-v01/slide-04-first-step.png)
- slide 5: [slide-05-daily-care.png](../../../../output/instagram/feed/2026-03-23-feed-mitochondria-basics-v01/slide-05-daily-care.png)
- CTA: [slide-06-cta-save.png](../../../../output/instagram/feed/2026-03-23-feed-mitochondria-basics-v01/slide-06-cta-save.png)

Supporting references:

- [set-1-education-white-card.png](../../../../output/instagram/templates/current/set-1-education-white-card.png)
- [feed-education-white-card-01.png](reference-pack/working-examples/feed-education-white-card-01.png)

## Canvas Rule

- feed ratio = `4:5`
- use a full-canvas rounded white card
- the canvas should read as the card itself, not a card floating inside a background
- edge atmosphere should be minimal and soft
- use only a faint pale blue perimeter wash when needed
- match the March 23 master card size, corner radius, and perimeter wash thickness
- treat the March 23 border size as the locked default for future `Set 1` assets

Reject:

- thick outer gradient borders
- obvious floating-card compositions
- large empty gradient frames around the card
- border or perimeter glow thicker than the March 23 master

## Locked Design Values

Use these as the default production values for every `Set 1` feed asset unless a specific slide role requires a minor composition shift.

Canvas:

- export size = `928 x 1152`
- working ratio = `4:5`
- full-card canvas = yes
- no separate background outside the card

Card:

- card fill = `96% to 97%` of the full canvas width
- corner radius feel = large, soft, premium, approximately `4% to 5%` of canvas width
- perimeter wash = very thin, approximately `1% to 1.5%` visual thickness from edge inward
- perimeter color feel = pale mist blue with soft cloud-white fade
- border visibility = implied by wash only, never a hard stroke

Typography:

- family = `Hiragino Sans`
- cover headline weight = `W6`
- cover supporting line weight = `W4`
- inner slide weight = `W4`
- CTA slide weight = `W4`
- text color = dark charcoal, approximately `#2F3338` to `#3A3F45`
- text opacity = visually full, stable across the batch
- do not use pure black

Type scale:

- cover headline size feel = `7% to 8.5%` of canvas width
- cover supporting line size feel = `3.8% to 4.6%` of canvas width
- inner slide text size feel = `5.2% to 6.4%` of canvas width
- CTA main text size feel = `4.8% to 5.8%` of canvas width
- CTA micro-cue size feel = `2.4% to 3%` of canvas width

Spacing:

- top safe area = `10% to 12%` of canvas height
- side safe area = `9% to 11%` of canvas width
- text block should usually begin in the upper `18% to 24%` zone
- gap between headline and supporting line on covers = generous, soft, never cramped
- gap between text block and visual motif = at least `10% to 14%` of canvas height
- lower motif zone = lower `35% to 45%` of canvas height

Atmosphere:

- base white = warm cloud white, not sterile blue-white
- blue wash = pale mist blue only
- warmth accent = restrained apricot / champagne only
- support visual opacity = low to medium-low
- glow softness = diffused and quiet, never glossy or neon

## Spacing Rule

Set `1` should feel calm and expensive because of spacing, not decoration.

Lock these behaviors:

- keep generous top breathing room above text
- keep left and right margins visually even
- leave clear separation between headline block and supporting visual
- keep lower support visuals below the reading zone unless the slide is a cover
- preserve enough empty space that mobile reading feels easy at first glance

Practical rule:

- text should occupy the upper half to upper-middle zone
- support visuals should live in the lower half or lower third unless the cover needs a hero image
- do not crowd the edges

## Typography Rule

Use one family only:

- `Hiragino Sans`

Weights:

- cover headline = `W6`
- cover supporting line = `W4`
- inner slides = `W4`
- CTA slides = `W4`

Text behavior:

- prefer 2 to 4 short lines
- use line breaks to shape rhythm
- keep optical balance centered or slightly upper-left depending on the visual
- let spacing create emphasis instead of changing weights

Reject:

- mixed font families
- inconsistent weights for similar slide roles
- oversized CTA treatments
- fake button styling

Text color and intensity:

- use dark charcoal text consistently, not pure black
- keep text opacity visually stable across the whole set
- do not allow one slide to look heavier just because the text rendered darker

## Support Visual Rule

`Set 1` is text-first, but subtle imagery is encouraged when it helps attention and comprehension.

Allowed support visuals:

- luminous mitochondria or soft science image for covers
- faint wave lines
- warm-cool ribbon cues
- soft concentric rings
- minimal abstract science shapes

Support visuals must:

- stay secondary to the copy
- feel integrated into the white card
- preserve the calm premium tone
- never compete with the headline

Support-visual intensity:

- keep opacity restrained and consistent across the batch
- keep glow softness in the same visual family
- avoid one slide suddenly becoming brighter, sharper, or more decorative than the others

## Color And Atmosphere Rule

- base = cloud white
- atmosphere = mist blue
- warmth = restrained apricot or soft champagne accent only
- contrast = dark charcoal text, not pure black

Avoid:

- neon blue
- hard clinical cyan
- heavy gold
- dark backgrounds inside `Set 1`

## Carousel Structure Rule

Default `Set 1 + Set 2` education carousel:

- cover = stronger hero image allowed and must make the topic feel relevant quickly
- slide 2 = why this matters now
- slide 3 = core explanation
- slide 4 = practical interpretation or first-step thinking
- slide 5 = contextual, lived-in, or brand-relevance support slide when the carousel is long enough
- final CTA = same structure, more breathing room, no fake button, plus one subtle lower guidance cue

CTA guidance cue rule:

- guide the eye gently downward
- use one quiet micro-cue only, such as a small arrow or short save reminder
- keep it centered or near-center in the lower area
- do not use app-like UI, side arrows, heavy icons, or boxed buttons

What changes from slide to slide:

- support visual type
- crop
- internal wave placement
- visual emphasis
- contextual support when the topic benefits from it

What stays locked:

- ratio
- card treatment
- margins
- text hierarchy
- tonal restraint
- text color intensity
- support-visual opacity range
- edge-glow softness

## Approval Checklist

Approve only if:

- the asset is `4:5`
- the canvas reads as one rounded white card
- the edge glow is minimal
- the border size and perimeter wash match the March 23 master closely
- typography matches the role
- spacing feels stable across the set
- the slide feels like part of the March 23 master family

If any of those drift, regenerate before approval.

## Prompt Lock

Use this block as the default `Set 1` generation instruction. Add only the slide-specific copy and motif.

```text
Create a premium Japanese Instagram carousel slide for Mitozz in the locked Set 1 Education White Card system. Use a 4:5 portrait canvas at 928x1152. The canvas must behave as one full rounded white card, not a floating card on a separate background. Match the March 23 master exactly: full-card composition, large soft rounded corners, very thin mist-blue perimeter wash close to the edge, no thick outer border, no empty gradient frame, no hard stroke. Use Hiragino Sans only. Text must be dark charcoal, not pure black, with stable weight and opacity across the batch. Cover headline uses W6. Supporting line, inner slides, and CTA text use W4. Keep generous top breathing room, even side margins, and clear separation between text and supporting visual. Text lives in the upper half to upper-middle zone. Supporting motif lives in the lower half and stays secondary to the copy. Base feel is cloud white, mist blue, restrained apricot warmth, calm premium editorial softness, minimal but subtly interactive. Reject decorative drift: no heavy borders, no mixed font personalities, no fake buttons, no rogue CTA labels, no random darker text, no louder slide than the rest. If this slide is part of a batch, it must match the March 23 border thickness, card size, corner behavior, typography density, spacing rhythm, support-visual opacity, and edge-glow softness.
```

## Slide Role Add-Ons

Append one of these short role instructions after the prompt lock instead of rewriting the whole design system.

Cover:

- stronger hero visual allowed
- headline = `Bold`
- supporting line = `Medium`
- no CTA micro-cue
- no extra footer text

Inner explanation slide:

- text-first
- one subtle support motif only
- no CTA cues

Context slide:

- may use a slightly warmer or more human support motif
- must still remain inside the same white-card system
- no photo-style background outside the card

CTA slide:

- same white-card system
- main centered CTA text only
- one subtle lower micro-cue allowed
- never mimic app UI or button UI

