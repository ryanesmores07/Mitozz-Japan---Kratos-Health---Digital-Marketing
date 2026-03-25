# Sora Clip Prompts - 2026-03-25 Daily Condition Reel

Use this file to turn the approved March 25 reel stills into short Sora 2 source clips.

Primary guide:
- [workflows/05A-sora-2-prompting-guide.md](C:/Users/esmoresernieryanocam/Desktop/Workspace/Nano banana/workflows/05A-sora-2-prompting-guide.md)

## Shared Sora 2 Setup

- `model`: `sora-2`
- `format`: `vertical reel source clip`
- `input_strategy`: use each approved still as `input_reference`
- `size_rule`: prepare each source image to exactly match the target video size before generation
- `editing_rule`: add Japanese text in edit, not inside Sora
- `brand_rule`: premium, calm, trustworthy, editorial

## Shared Continuity Block

Use this wording in every related prompt:

```text
Same Japanese woman in her early 30s, same quiet premium apartment workspace, same steel-blue morning light, same calm editorial lens feel, same restrained styling, same cloud-white, mist-blue, steel-blue palette, same realistic Mitozz bottle fidelity when present.
```

## Shot 01

- `source_image_path`: `output/instagram/reels/2026-03-25-daily-condition/current/shot-01-opening-hook.png`
- `target_seconds`: `2.5`
- `role`: `opening-hook`
- `camera_note`: `medium close-up, eye level, subtle push-in`
- `motion_note`: `soft blink, small exhale, tiny pause above the keyboard`
- `must_hold`: tired-but-composed restraint, generous text-safe negative space

```text
Animate this approved vertical frame into a calm editorial opening beat. Preserve the exact subject identity, wardrobe, environment, composition, and color balance from the source image. Same Japanese woman in her early 30s, same quiet premium apartment workspace, same steel-blue morning light, same calm editorial lens feel, same restrained styling, same cloud-white, mist-blue, steel-blue palette, same realistic Mitozz bottle fidelity when present. She pauses softly before starting work, gives one natural blink, and releases a small breath while her hand hovers briefly above the keyboard. Keep the motion restrained and natural. Preserve the clean negative space for later text overlay. Do not add new props, people, background changes, or dramatic expression shifts.

Cinematography:
Camera shot: medium close-up, eye level, subtle push-in
Mood: calm, slightly fatigued, thoughtful, premium
Actions:
- soft blink and small exhale
- tiny hand pause above the keyboard
Lighting + palette: soft side daylight with restrained contrast and stable cool morning tone
Palette anchors: cloud white, mist blue, steel blue, soft grey
```

## Shot 02

- `source_image_path`: `output/instagram/reels/2026-03-25-daily-condition/current/shot-02-reframe.png`
- `target_seconds`: `2.5`
- `role`: `reframe`
- `camera_note`: `close detail shot, slight top-down angle, gentle lateral drift`
- `motion_note`: `hand settles, curtain or daylight shifts slightly, ambient desk stillness`
- `must_hold`: quiet reset feeling, no product yet, breathable composition

```text
Animate this approved vertical frame into a calm routine-detail reframe clip. Preserve the exact subject identity, environment, desk styling, composition, and color balance from the source image. Same Japanese woman in her early 30s, same quiet premium apartment workspace, same steel-blue morning light, same calm editorial lens feel, same restrained styling, same cloud-white, mist-blue, steel-blue palette, same realistic Mitozz bottle fidelity when present. Let the hand settle gently near the notebook while the curtain light shifts slightly and the frame breathes with minimal ambient movement. Keep the motion subtle and edit-friendly. Preserve the negative space for later text overlay. Do not introduce the product, new props, new hands, or any dramatic camera move.

Cinematography:
Camera shot: close detail shot, slight top-down angle, gentle lateral drift
Mood: calm, reset-oriented, breathable, premium
Actions:
- hand settles softly into the desk rhythm
- slight ambient curtain or daylight movement
Lighting + palette: soft window light with cool morning fill and stable neutral highlights
Palette anchors: cloud white, mist blue, steel blue, walnut brown
```

## Shot 03

- `source_image_path`: `output/instagram/reels/2026-03-25-daily-condition/current/shot-03-product-reveal.png`
- `target_seconds`: `3.0`
- `role`: `product-reveal`
- `camera_note`: `product-forward medium detail shot, slight push-in`
- `motion_note`: `careful bottle placement or settling, minimal hand movement`
- `must_hold`: real bottle fidelity, realistic scale, text kept away from bottle later

```text
Animate this approved vertical frame into a quiet product-reveal clip. Preserve the exact product shape, label orientation, cap finish, scale, subject identity, environment, and composition from the source image. Same Japanese woman in her early 30s, same quiet premium apartment workspace, same steel-blue morning light, same calm editorial lens feel, same restrained styling, same cloud-white, mist-blue, steel-blue palette, same realistic Mitozz bottle fidelity when present. The bottle is placed carefully into the desk scene or settles gently into stillness with only minimal hand motion. Keep the product realistic and stable. Preserve clean negative space for later text overlay and do not crowd the frame. Do not warp the bottle, distort the label, add extra props, or turn the motion into a glossy advertisement.

Cinematography:
Camera shot: product-forward medium detail shot, slight push-in
Mood: calm, precise, premium, trustworthy
Actions:
- careful bottle placement or settling into position
- minimal hand movement, then stillness
Lighting + palette: soft window light with gentle product edge definition and restrained contrast
Palette anchors: cloud white, mist blue, steel blue, soft apricot
```

## Shot 04

- `source_image_path`: `output/instagram/reels/2026-03-25-daily-condition/current/shot-04-end-frame.png`
- `target_seconds`: `3.0`
- `role`: `soft-end-frame`
- `camera_note`: `stable product end frame, near-static hold with tiny ambient drift`
- `motion_note`: `almost still, only slight daylight drift`
- `must_hold`: clean CTA-safe composition, elegant final hold

```text
Animate this approved vertical frame into a calm held ending clip. Preserve the exact bottle fidelity, environment, composition, and color balance from the source image. Same Japanese woman in her early 30s, same quiet premium apartment workspace, same steel-blue morning light, same calm editorial lens feel, same restrained styling, same cloud-white, mist-blue, steel-blue palette, same realistic Mitozz bottle fidelity when present. Let the composition remain almost still, with only a very slight ambient daylight drift so the frame feels alive but settled. Keep the bottle perfectly stable and realistic. Preserve the clean negative space for the final CTA overlay. Do not add new movement, new props, text, or flashy commercial energy.

Cinematography:
Camera shot: stable product end frame, near-static hold
Mood: calm, resolved, elegant, premium
Actions:
- almost static hold
- very slight ambient daylight drift
Lighting + palette: soft morning daylight with stable highlights and quiet product presence
Palette anchors: cloud white, mist blue, steel blue, soft grey
```

## Approval Notes

- approve only if all clips feel like the same morning world
- reject any bottle warping or label drift
- reject any sudden hand artifacts
- reject any extra objects or background changes
- reject any motion that feels ad-like, loud, or trendy
