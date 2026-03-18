# 03. Generate And Approve

Use this checklist when executing prompts and selecting final assets.

## Generation Loop

- Generate 3 variants per asset in the first batch.
- Keep the same `image_references` across the batch.
- Vary composition only through:
  - crop
  - camera distance
  - angle
  - focal treatment
  - foreground or glow treatment
- Pick 1 winner.
- Refine once if needed.

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

## Promote To Working Examples Only If

- the output clearly matches the visual direction
- the output feels premium and calm
- the output does not repeat the current pack too closely
- the output strengthens the system for future generations

Promotion stays human-approved, not automatic.

## Output

- final selected asset for publishing
- optional approved asset copied into `working-examples/` only after explicit approval
