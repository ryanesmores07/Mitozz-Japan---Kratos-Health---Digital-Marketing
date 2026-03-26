# Mitozz Generation Lessons Log

## Purpose

This file captures repeated generation mistakes and the production correction so the workflow improves over time.

Use it as a short memory layer:

- what went wrong
- what rule was added
- what to do differently next time

Do not use this file for general brainstorming.
Use it only for repeatable production learning.

## Active Lessons

### 1. Border Lock Means Border Only

Issue:

- early follow-up sets became too visually similar to March 23 because the full look was being copied instead of only the border/card treatment

Rule:

- lock the March 23 border, corner behavior, and perimeter wash
- keep the internal visual concept free to change within the correct template set

Apply next time:

- preserve frame language
- vary motif, crop, scene logic, and support visuals

### 2. Do Not Accept First Pass By Default

Issue:

- several generated slides looked usable at first glance but drifted on border thickness, CTA behavior, or typography consistency

Rule:

- every batch must be reviewed against the locked master before approval

Apply next time:

- generate
- compare to master
- reject drift
- regenerate only the failing slides

### 3. Rogue CTA Drift

Issue:

- non-CTA slides, especially covers, can unexpectedly generate save labels, footer text, or other CTA-like elements

Rule:

- only CTA slides may carry CTA micro-cues
- covers and inner slides must reject all extra footer labels and save prompts

Apply next time:

- explicitly say `no extra text`, `no footer label`, and `no CTA cue` on non-CTA slides

### 4. Mixed Export Sizes Create Batch Friction

Issue:

- some generated slides came back at larger sizes while older approved slides were kept at `928x1152`

Rule:

- normalize final approved `Set 1` feed exports to `928x1152`

Apply next time:

- resize final approved slides into one consistent export size before approval

### 5. Story And Carousel Typography Drift Easily

Issue:

- text weight, darkness, and presence can drift between connected assets even when the structure is similar

Rule:

- connected batches must keep one typographic voice

Apply next time:

- compare all slides or frames side by side before approval
- if one looks lighter, darker, glossier, or heavier, regenerate it

### 6. Bottle Scale Needs A Locked Spec

Issue:

- bottle-led lifestyle frames can look unrealistic when the bottle is generated too large for the desk scene

Rule:

- use [Mitozz Bottle Size Spec.md](Mitozz%20Bottle%20Size%20Spec.md) instead of attaching the hand-held guide image directly
- keep bottle size believable relative to the hand, mug, and tabletop objects
- adapt bottle lighting and shadow softness to the surrounding scene before approval

Apply next time:

- if the bottle feels oversized, regenerate smaller
- if the bottle lighting feels detached from the scene, regenerate with explicit light-matching instructions

### 7. Bottle Size And Light Must Match The Scene

Issue:

- bottle-led lifestyle frames can still feel fake when the bottle is too large for the desk scene or when the bottle lighting does not fully adapt to the surrounding environment

Rule:

- bottle realism is not only pack fidelity
- scale, contact, and light integration must also pass before approval

Apply next time:

- compare bottle height to nearby desk objects like mugs, notebooks, and hands
- reduce bottle scale if it starts to dominate a lifestyle scene
- match highlight direction, shadow softness, and local contrast to the surrounding desk light
- reject any product frame that looks pasted in even if the label is technically closer to the real pack
