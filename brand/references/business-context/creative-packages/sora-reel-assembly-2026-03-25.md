# Sora Reel Assembly - 2026-03-25

## Reel Overview

- `project_name`: `March 25 Daily Condition Reel`
- `date`: `2026-03-25`
- `target_platform`: `instagram-reel`
- `target_runtime_seconds`: `11`
- `aspect_ratio`: `9:16`
- `delivery_goal`: `Introduce daily condition design with a calm, premium, relatable reel`
- `working_source_set`: `2026-03-25-daily-condition-v02`
- `editorial_blueprint`: [reel-edit-blueprint-2026-03-25.md](/Users/ernieryanesmores/Desktop/Workspace/Mitozz-Japan---Kratos-Health---Digital-Marketing/brand/references/business-context/creative-packages/reel-edit-blueprint-2026-03-25.md)

## Continuity System

- `subject identity`: `Same Japanese woman in early 30s, calm and polished`
- `wardrobe`: `Neutral soft-toned clothing`
- `environment`: `Quiet premium apartment workspace with minimal desk styling`
- `palette`: `Cloud white, mist blue, restrained steel blue, soft apricot accents only`
- `light direction`: `Soft morning window light from one consistent side`
- `lens distance`: `Natural editorial portrait to medium-close detail range`
- `product orientation`: `Mitozz bottle label facing camera cleanly on product shots`

## Shot Inputs

### Shot 01

- `shot_id`: `shot-01`
- `source_image_path`: `output/instagram/reels/2026-03-25-daily-condition-v02/source-frames/shot-01-opening-hook.png`
- `source_prompt_json`: `prompts/instagram/feed/ig-feed-reel-2026-03-25-daily-condition-shot-01-v02.json`
- `duration_seconds`: `2.5`
- `narrative_role`: `opening-hook`
- `camera_motion`: `Very subtle slow push-in`
- `subject_motion`: `Small breath, soft blink, tiny hand movement`
- `transition_in`: `Cold open from stillness`
- `transition_out`: `Clean straight cut`
- `sora_prompt`: `Animate this vertical source image into a calm premium reel opening. Keep the same subject identity, wardrobe, environment, and soft steel-blue morning light. Use only subtle natural motion: a small breath, a soft blink, and a gentle hand movement. Add a very slow push-in. Do not add new people, props, or dramatic movement. Preserve generous text-safe negative space.`
- `sora_negative_prompt`: `identity drift, warped hands, extra objects appearing, sudden lighting changes, fast camera moves, flashy ad transitions, unreadable text`

### Shot 02

- `shot_id`: `shot-02`
- `source_image_path`: `output/instagram/reels/2026-03-25-daily-condition-v02/source-frames/shot-02-reframe.png`
- `source_prompt_json`: `prompts/instagram/feed/ig-feed-reel-2026-03-25-daily-condition-shot-02-v02.json`
- `duration_seconds`: `2.5`
- `narrative_role`: `reframe`
- `camera_motion`: `Gentle lateral drift`
- `subject_motion`: `Minimal hand movement and tiny ambient motion`
- `transition_in`: `Straight cut from shot 01`
- `transition_out`: `Soft hold before reveal`
- `sora_prompt`: `Animate this image into a premium vertical lifestyle detail shot that feels calm and intentional. Keep the same environment, palette, and morning light continuity as the previous shot. Use only subtle natural motion in the hand, curtain, or ambient scene. Do not invent new objects or aggressive movement. Keep the composition clean for later text overlay.`
- `sora_negative_prompt`: `messy desk, abrupt motion, background drift, identity changes, hard light changes, flashy transitions, unreadable text`

### Shot 03

- `shot_id`: `shot-03`
- `source_image_path`: `output/instagram/reels/2026-03-25-daily-condition-v02/source-frames/shot-03-product-reveal.png`
- `source_prompt_json`: `prompts/instagram/feed/ig-feed-reel-2026-03-25-daily-condition-shot-03-v02.json`
- `duration_seconds`: `3.0`
- `narrative_role`: `product-reveal`
- `camera_motion`: `Micro push-in`
- `subject_motion`: `Very light hand movement settling the bottle`
- `transition_in`: `Cut from lifestyle reframe shot`
- `transition_out`: `Hold before end frame`
- `sora_prompt`: `Animate this image into a calm premium product reveal in vertical format. Preserve the exact bottle silhouette, cap finish, label placement, and overall room continuity. Use only subtle natural motion and restrained editorial camera movement. The hand may gently settle the bottle into place. Do not add extra products, extra hands, or dramatic reflections. Keep the frame stable and elegant.`
- `sora_negative_prompt`: `bottle distortion, label drift, extra fingers, warped hands, flashy reflections, fast motion, ad-style lighting, unreadable text`

### Shot 04

- `shot_id`: `shot-04`
- `source_image_path`: `output/instagram/reels/2026-03-25-daily-condition-v02/source-frames/shot-04-end-frame.png`
- `source_prompt_json`: `prompts/instagram/feed/ig-feed-reel-2026-03-25-daily-condition-shot-04-v02.json`
- `duration_seconds`: `3.0`
- `narrative_role`: `clean-end-frame`
- `camera_motion`: `Almost static with a tiny breathing drift`
- `subject_motion`: `Ambient light softness only`
- `transition_in`: `Gentle cut from shot 03`
- `transition_out`: `Final clean hold`
- `sora_prompt`: `Animate this source image into a calm premium end frame for a wellness reel. Keep the bottle orientation, environment, and light direction consistent with the previous product shot. Use only minimal ambient motion and a nearly still camera. Keep the frame visually clean and uncluttered for later editor-added text. Do not add new props, people, or movement.`
- `sora_negative_prompt`: `bottle drift, unstable framing, sudden motion, new objects, heavy reflections, loud ad energy, unreadable text`

## Sequence Notes

- `hook_shot`: `shot-01`
- `reframe_shot`: `shot-02`
- `product_or_brand_shot`: `shot-03`
- `end_frame_shot`: `shot-04`

## Overlay Plan

- `baked_in_text`: `no`
- `edit_added_text`: `yes`
- `subtitle_style`: `Noto Sans JP, restrained, high-contrast, generous line spacing`
- `text_safe_areas`: `Top third and lower third preserved across all shots`
- `cta_copy_ja`: `仕組みをやさしく読む`
- `text_timing_reference`: `Use the blueprint timing from reel-edit-blueprint-2026-03-25.md`

## Music And Pace

- `music_direction`: `quiet modern ambient with a gentle pulse`
- `pace_notes`: `The first 2 seconds should hook softly, the middle should breathe, the end should hold cleanly`
- `moments_to_breathe`: `shot-03 to shot-04 transition and final hold`
- `moments_to_hit_harder`: `opening text beat and the reframe line`

## Final Review Checklist

- continuity feels stable across shots
- camera motion is calm and intentional
- no object drift or identity drift
- product fidelity is preserved
- first 1-2 seconds hook clearly
- end frame holds long enough for editor-added text
- overall tone still feels premium, calm, and science-led

## Final Export

- `export_name`: `mitozz-ig-reel-2026-03-25-daily-condition-v01.mp4`
- `export_location`: `output/instagram/reels/`
- `editor_notes`: `Use the approved v02 9:16 source frames. Keep transitions simple, no flashy motion graphics, and allow the final frame to hold for at least 1.2 seconds.`
