# 05A. Sora 2 Prompting Guide

Use this when we turn approved stills into motion clips with Sora 2.

Primary source:
- OpenAI Cookbook: [Sora 2 Prompting Guide](https://developers.openai.com/cookbook/examples/sora/sora2_prompting_guide)

This is a working guide for this workspace based on that official guide plus our Mitozz reel standards.

## What Sora 2 Responds To Best

- one clear shot at a time
- simple, literal motion directions
- specific camera framing instead of vague style words
- specific lighting logic and palette anchors
- image input when we want tight first-frame control
- repeated continuity wording across related clips

## Core Rules

1. Use the approved still as `input_reference` whenever the frame is already locked.
2. Make the input image match the target video size before sending it to Sora 2.
3. Keep each clip short and focused on one beat. For reels like ours, aim for one prompt per shot instead of one prompt for the whole reel.
4. Describe motion as subtle physical changes, not abstract vibes.
5. Name the camera shot clearly, such as `medium close-up, eye level` or `close detail shot, slight top-down angle`.
6. State the light behavior and list 3 to 5 palette anchors for continuity.
7. Reuse the same identity and environment wording across all shots in the same reel.
8. If a result is close but off, edit one variable at a time instead of rewriting the whole prompt.

## Prompt Structure

Use this structure for most Mitozz image-to-video shots:

```text
[Plain-language scene description anchored to the source image.]

Cinematography:
Camera shot: [specific framing and angle]
Mood: [clear emotional tone]
Actions:
- [main motion beat]
- [secondary micro-motion]
Lighting + palette: [specific light logic]
Palette anchors: [color 1], [color 2], [color 3]
```

## Mitozz House Rules For Sora 2

- preserve exact subject identity from the still
- preserve bottle fidelity, cap shape, label orientation, and realistic scale
- keep motion subtle, premium, and edit-friendly
- keep negative space for text overlays
- do not add new props, people, wardrobe changes, or background swaps
- do not turn the clip into a flashy ad
- do not add baked-in text
- do not overanimate hands, hair, or product edges

## Default Motion Language For Our Brand

Good motion verbs for Mitozz:
- pauses
- exhales softly
- blinks once
- settles a hand on the desk
- curtain shifts slightly
- daylight drifts gently
- bottle is placed carefully
- camera drifts subtly
- micro push-in

Avoid:
- dramatic gestures
- fast camera moves
- hard zooms
- whip pans
- heavy parallax
- glossy commercial flourishes
- hype energy

## Reusable Continuity Block

Repeat this language across connected reel shots and only change the shot-specific action:

```text
Same Japanese woman in her early 30s, same quiet premium apartment workspace, same steel-blue morning light, same calm editorial lens feel, same restrained styling, same cloud-white, mist-blue, steel-blue palette, same realistic Mitozz bottle fidelity when present.
```

## Sora 2 Request Checklist

- `model`: `sora-2`
- `input_reference`: prepared image file
- `size`: exactly matches the prepared image
- `seconds`: short shot length based on the edit plan

Working rule for this workspace:
- treat `size` and `seconds` as request fields, and use the prompt for scene and motion direction

This rule is inferred from the official cookbook examples, which consistently set technical output controls in the request body and use the prompt for visual behavior.

## Editing And Iteration

- if the camera is wrong, change only the camera note
- if color drifts, keep the shot and update only lighting and palette anchors
- if identity drifts, strengthen the repeated continuity block and simplify motion
- if the result feels messy, freeze the camera and reduce actions
- once a clip is working, keep that wording stable for neighboring shots

## Reel Workflow

1. Approve the still frame first.
2. Prepare a Sora-ready copy of that image at the exact target video size.
3. Write one prompt per shot.
4. Generate short clips.
5. Approve clips before edit assembly.
6. Hand approved clips into the reel edit packet as normal video assets.

## Fast Prompt Starter

```text
Animate this approved vertical frame into a calm premium editorial clip. Preserve the exact subject identity, styling, product fidelity, environment, and composition from the source image. Keep the motion subtle and natural and preserve clean negative space for later text overlays.

Cinematography:
Camera shot: [specific framing and angle]
Mood: calm, premium, thoughtful, trustworthy
Actions:
- [main motion beat]
- [secondary ambient motion]
Lighting + palette: soft window light with restrained contrast and stable color
Palette anchors: cloud white, mist blue, steel blue
```
