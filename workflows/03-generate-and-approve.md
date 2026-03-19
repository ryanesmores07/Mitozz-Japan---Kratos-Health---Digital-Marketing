# 03. Generate And Approve

Use this checklist when executing prompts and selecting final assets.

## Generation Loop

- Generate 3 variants per asset in the first batch.
- Keep the same `image_references` across the batch.
- Keep approved `product-source` references in the batch whenever product accuracy matters.
- Vary composition only through:
  - crop
  - camera distance
  - angle
  - focal treatment
  - foreground or glow treatment
- Pick 1 winner.
- Refine once if needed.

## Reel Execution Loop

If the asset is a reel, treat the workflow as four linked stages:

1. Source-frame generation
2. Shot approval
3. Sora animation
4. Final assembly approval

### 1. Source-Frame Generation

- Generate `2-3` variants per shot prompt in the first batch, not just one batch for the whole reel.
- Keep continuity tokens identical across all shots unless the creative package explicitly changes them.
- Keep product-source references attached to every shot where the bottle appears.
- Preserve text-safe negative space unless the plan explicitly calls for baked-in text.
- Prioritize clean subject readability and simple compositions that will animate well.
- Save approved source frames as `.jpg` by default for smaller production files.

### 2. Shot Approval

Pick one approved source frame per shot.

Check each selected shot for:

- continuity with the previous and next shot
- subject identity consistency
- bottle orientation and pack fidelity
- light direction consistency
- environment consistency
- enough negative space for editing overlays
- strong readability at mobile size

Do not move into Sora until the full shot set works together as one reel.

### 3. Sora Animation

For each approved shot:

- use the matching `sora_handoff.prompt`
- keep the corresponding `sora_handoff.negative_prompt`
- animate only the motion described in the creative package
- avoid adding new objects, new people, new wardrobe, or new environments
- keep camera motion subtle unless the brief explicitly calls for more energy
- export clips at the planned duration so the edit stays simple

When animating a coordinated shot set:

- preserve continuity tokens across shots
- avoid making every shot equally active
- let one shot carry the hook, one carry the reframe, and one carry the brand or CTA beat

### 4. Final Assembly Approval

Before signoff, review the full reel cut for:

- pacing
- transition smoothness
- brand fit
- copy timing
- premium tone
- hook strength in the first `1-2 seconds`
- clear final CTA hold

## Free Test Run Path

Use this path when you want to rehearse the workflow without paying for Nano Banana or the OpenAI API.

- Run `tools/chatgpt-image-test-run.ps1` with the existing prompt JSON.
- The script creates a ChatGPT-ready dry-run bundle under `output/instagram/test-runs/`.
- Attach the resolved image references manually in ChatGPT image generation and paste one variant prompt at a time.
- Keep the same approval rubric and winner-selection loop as the paid workflow.
- Treat this as a workflow rehearsal, not a pixel-identical replacement for Nano Banana.

## Approval Rubric

Score each candidate from 1 to 5 on:

- brand fit
- composition clarity
- text readability
- reference adherence
- novelty versus repetition

For reels, also score:

- shot-to-shot continuity
- animation naturalness
- opening-hook strength
- end-frame usefulness for CTA

## Promote To Working Examples Only If

- the output clearly matches the visual direction
- the output feels premium and calm
- the output does not repeat the current pack too closely
- the output strengthens the system for future generations

Promotion stays human-approved, not automatic.

## Output

- final selected asset for publishing
- optional approved asset copied into `working-examples/` only after explicit approval
- for reels: approved source-shot set, approved animated clips, and one final edited cut
