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
