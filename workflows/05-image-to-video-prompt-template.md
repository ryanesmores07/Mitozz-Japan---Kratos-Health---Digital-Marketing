# 05. Image-To-Video Prompt Template

Use this template when a generated image or approved still frame needs to be turned into a short vertical video clip.

This template stays platform-agnostic, but it now includes a Sora 2-ready structure. For Sora 2, pair it with `workflows/05A-sora-2-prompting-guide.md`.

## Clip Overview

- `project_name`:
- `shot_id`:
- `source_image_path`:
- `target_platform`: `instagram-reel`
- `target_aspect_ratio`: `9:16`
- `target_duration_seconds`:
- `clip_role_in_reel`:
- `tool_surface`:
- `target_video_size`:
- `source_image_prepared_to_match_target_size`: `yes/no`

## What Must Stay Fixed

- `subject identity`:
- `product identity`:
- `wardrobe`:
- `environment`:
- `palette`:
- `light direction`:
- `camera distance`:
- `text_safe_area`:
- `continuity_phrase_to_repeat_across_related_clips`:

## Motion Goal

- `what_the_clip_should_feel_like`:
- `what_the_viewer_should_notice_first`:
- `primary_motion`:
- `secondary_motion`:
- `camera_behavior`:
- `transition_role`:

## Platform-Agnostic Motion Prompt

Write this as one clean paragraph or short block ready to paste:

- `prompt`:

Recommended structure:

`Animate this vertical frame into a calm premium wellness clip. Preserve the exact subject identity, styling, product fidelity, palette, and environment from the source image. Keep the motion subtle and natural. [describe subject motion]. [describe camera motion]. [describe lighting and palette anchors]. Preserve negative space for text overlays. Do not introduce new objects, people, wardrobe changes, background swaps, or dramatic lighting changes. Keep the overall feel premium, calm, trustworthy, and editorial.`

Recommended Sora 2 structure:

`[plain-language scene description anchored to the source image]`

`Cinematography:`
`Camera shot: [specific framing and angle]`
`Mood: [clear emotional tone]`
`Actions:`
`- [beat 1]`
`- [beat 2]`
`Lighting + palette: [specific light logic and 3-5 color anchors]`

## Negative Prompt

- `negative_prompt`:

Default suppressions:

- warped hands
- drifting face or product identity
- label distortion
- extra props
- extra people
- sudden background swaps
- hyperactive motion
- ad-like flashy effects
- unreadable text

## Clip-Specific Rules

- `must_not_change`:
- `allowed_micro_motion`:
- `disallowed_motion`:
- `hook_or_hold_note`:

## Sora 2 Request Notes

- `model`: `sora-2`
- `input_reference`: use the prepared source image
- `size`: must match the prepared source image size
- `seconds`: keep each clip short and shot-specific
- `edit_strategy_if_needed`: make one controlled change at a time

## Export Target

- `resolution`: `1080x1920`
- `format`:
- `fps`:
- `delivery_location`:
