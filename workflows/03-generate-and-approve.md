# 03. Generate And Approve

Use this checklist when executing prompts and selecting final assets.

For reel batches, run `workflows/03A-reel-preflight-and-hard-locks.md` before generation.

## Generation Loop

- Do not generate until the prompt has explicit hard-fail conditions for the asset's biggest risks.
- If the asset has known high-cost failure modes such as text contamination, pack mismatch, or Story batch drift, encode those as rejection rules in the prompt before running generation.
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

## Preflight Gate

Before any paid generation, verify the prompt already contains the right lock type for the asset:

- `no-text lock` when source images must stay text-free
- `pack-truth lock` when the bottle, cap, label, or tablets appear
- `batch-uniformity lock` when a Story or carousel set must read as one system
- `continuity lock` when multiple reel shots must feel like one scene family

If any of those locks are missing, stop and tighten the prompt first.

For reel source-frame batches, also run:

- `python tools/validate-reel-prompt-batch.py "<your reel prompt glob here>"`
- `powershell -NoProfile -ExecutionPolicy Bypass -File tools/validate-reel-prompt-batch.ps1 "<your reel prompt glob here>"`

Do not generate if the validator returns `FAILED`.

## Reel Execution Loop

If the asset is a reel, treat the workflow as four linked stages:

1. Source asset creation and selection
2. Freelancer handoff assembly
3. First-draft review
4. Final cut approval

### 1. Source Asset Creation And Selection

- Generate `2-3` variants per needed image prompt in the first batch.
- Keep continuity tokens identical across related reel assets unless the creative package explicitly changes them.
- Keep product-source references attached to every shot where the bottle appears.
- Preserve text-safe negative space unless the plan explicitly calls for baked-in text.
- Prioritize clean subject readability and simple compositions that edit well.
- If you already have usable footage, select and label the exact clip ranges before handoff.
- If a still image must become a motion clip, write the motion prompt with `workflows/05-image-to-video-prompt-template.md` before generating the clip.

Approve every source asset before the freelancer begins.

Hard rejection rules for reel source assets:

- reject any source frame with readable text, logos, UI, or unintended wordmarks unless baked-in text was explicitly requested
- reject any frame that does not clearly serve its assigned beat
- reject any bottle-led shot with wrong bottle color, wrong cap finish, weak label fidelity, or invented label structure
- reject any shot that looks like a generic ad or stock still instead of an edit-ready reel beat
- reject any shot that breaks continuity with adjacent frames in environment, light direction, subject identity, or styling

If using Sora.chatgpt.com or another image-to-video tool internally:

- start from an approved still or approved source clip
- keep motion subtle unless the creative package explicitly calls for more energy
- preserve subject identity, wardrobe, palette, environment, bottle fidelity, and light direction
- suppress extra objects, sudden environment changes, heavy camera moves, and ad-like motion
- treat the output as an internal source clip that will later be handed to the freelancer

### 2. Freelancer Handoff Assembly

Build one clear packet using `workflows/04-freelancer-reel-handoff-template.md`.

The packet should include:

- the approved reel goal
- exact Japanese text blocks
- source asset manifest
- edit blueprint by beat
- design rules
- motion and transition rules
- music and audio direction
- export specs

The freelancer should not have to guess:

- what the reel is trying to say
- which asset belongs in which beat
- how premium or calm the edit should feel
- how strong the CTA should be

### 3. First-Draft Review

Review the freelancer draft for:

- hook strength in the first `1-2 seconds`
- pacing
- clarity of the message
- premium brand fit
- text readability
- transition smoothness
- pack fidelity when the bottle appears
- final CTA hold

Ask for targeted revisions only. Do not reopen strategy unless the brief itself was wrong.

### 4. Final Cut Approval

Before signoff, review the final reel for:

- clear story progression
- calm but engaging motion
- strong mobile readability
- premium trustworthy tone
- clean export
- alignment with the approved handoff packet

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

- beat-to-beat clarity
- source-asset usage accuracy
- opening-hook strength
- end-frame usefulness for CTA
- edit fit versus the approved handoff packet

For Stories and carousels, also score:

- batch uniformity
- card-layout consistency
- typography consistency
- CTA-system consistency

## Story Approval Rule

Never approve Story frames one by one in isolation.

Approve Stories only at the set level.

Reject the set if:

- card architecture changes between frames
- border logic changes between frames
- background treatment intensity drifts too much
- text weight, darkness, scale, or spacing drifts too much
- the CTA frame introduces a new visual system instead of evolving the same one

## Promote To Working Examples Only If

- the output clearly matches the visual direction
- the output feels premium and calm
- the output does not repeat the current pack too closely
- the output strengthens the system for future generations

Promotion stays human-approved, not automatic.

## Output

- final selected asset for publishing
- optional approved asset copied into `working-examples/` only after explicit approval
- for reels: approved source asset set, one freelancer handoff packet, first draft notes, and one final edited cut

## Replacement Rule

When a regenerated asset is approved:

- remove the rejected asset from the active output location
- replace it with the approved asset instead of leaving both in the live path
- if traceability matters, move the rejected asset or rejected version folder into a sibling `rejected/` archive rather than keeping it beside active files
- keep the active output folder clean so it contains approved assets only

Use version folders only while reviewing.
After approval, promote the approved asset into the active location and archive the rejected one.
