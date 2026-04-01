# 03. Post-Calendar Production Flow

Use this workflow after the calendar is approved.

The goal is to keep the calendar strategic while letting production run consistently and quickly.

## Core Principle

Do not make the calendar carry every production decision.

Use this split instead:

- calendar = strategy
- mapping layer = template and structure
- creative package = art direction
- prompt = execution input
- handoff packet = freelancer-ready reel edit brief
- output = generated asset candidates or freelancer edit drafts

## What Stays In The Calendar

The calendar should stay responsible for:

- date
- format
- topic
- objective
- persona
- CTA
- supporting strategic notes

These are planning decisions.

## What Should Not Be Added To The Calendar By Default

Do not add these as routine calendar columns unless a planning use case truly needs them:

- `Template Set`
- `Slide Blueprint`
- exact layout notes
- image reference selections
- batch styling controls
- prompt-level generation instructions

These belong downstream.

## Recommended Handoff Sequence

1. Approve the calendar row.
2. Resolve the asset through the mapping rules.
3. Run [03B. Visual-Engine Preflight](03B-visual-engine-preflight.md) and lock the primary visual engine before layout work starts.
4. Build the creative package from the mapped result.
5. Create or update the prompt JSON when source images are needed.
6. Generate or collect the source assets.
7. Assemble the final asset through the compositor or chosen execution path.
8. If the asset is a reel, assemble the freelancer handoff packet.
9. Review against the batch consistency rules and the lessons log.
10. Regenerate only the failing outputs or revise only the unclear handoff sections.
11. If the same production issue appears more than once, update the standard, review gate, or skill docs before moving on to the next asset.
12. Promote only approved outputs into the working set.
13. Register approved feed posts and Story sets in `brand/references/business-context/visual/Mitozz Approved Post Library.csv`.
14. When Instagram insights or screenshots become available, normalize the useful numbers and interpretation into `brand/references/business-context/reporting/instagram-metrics/` so the next planning cycle can use real performance data.

## Minimal Post-Calendar Data Model

After the calendar, every asset should resolve into this smaller production layer:

- `Template Set`
- `Slide Blueprint`
- `asset_archetype`
- `story_type` when the asset is a story
- `approved_references`

This is enough to automate the rest without turning the calendar into a production spreadsheet.

## Visual-Engine Preflight

Before the creative package is finalized, run:

- [03B. Visual-Engine Preflight](03B-visual-engine-preflight.md)

This step must lock:

- `visual_engine`
- `anchor_set`
- `source_lane`
- `source_strategy`
- `fallback_source`
- `icon_strategy`
- `generated_visual_role`

These are not monthly planning fields.
They are execution-control fields that stop routine, trust, or lifestyle topics from accidentally becoming abstract text systems.

## Reel-Specific Production Layer

For reels, the post-calendar layer should resolve one extra internal packet after the creative package:

- `reel_type`
- `runtime_target`
- `source_asset_mode`
- `source_asset_manifest`
- `motion_clip_prompt` when a still will be animated internally
- `edit_blueprint`
- `approved_copy_blocks`
- `freelancer_handoff_status`

These are not planning fields. They exist to make execution consistent and easy to delegate.

## Recommended Reel Sequence

For this project, reels should now follow this operating path:

1. approve the calendar row
2. resolve template and structure from mapping rules
3. build the reel creative package
4. generate or gather all source images and source clips internally
5. assemble a freelancer-ready reel handoff packet
6. send one clean package to the freelancer
7. review the first draft against the approved messaging, pacing, and design rules
8. request only targeted revisions
9. approve the final cut and archive the packet for reuse

The freelancer should execute the edit, not reinterpret the brand strategy.

## Story-Specific Rule

For stories, add `story_type` after calendar approval instead of expanding the calendar itself.

Approved story types:

- `feed-reinforcement`
- `daily-context`
- `interactive`
- `proof-trust`
- `route-cta`

This keeps the story strategy operational without cluttering the planning sheet.

## Asset Memory Rule

Approved feed posts and Story sets should not live only in output folders.

After approval:

- log the asset in `brand/references/business-context/visual/Mitozz Approved Post Library.csv`
- note what was reused successfully
- note what should change next time
- record the `source_strategy` so we know whether the asset used full AI, a compositor path, a real-photo workflow, or a Nano Banana source image

If a live asset exposed a recurring execution issue such as:

- internal scaffolding leaking into production
- meaningless badge or side-strip labels
- forced Japanese line breaks
- visibly off-center module text

write that lesson back into the workflow or standards before starting the next asset.

## Performance Feedback Rule

When metrics become available after posting:

- do not leave them only in screenshot form
- convert them into the current monthly metrics snapshot under `brand/references/business-context/reporting/instagram-metrics/`
- preserve the strongest useful signals such as reach, non-follower share, profile visits, interactions, and top-performing format
- use that snapshot before revising the next calendar rows or briefing the next batch

This is the lightweight way to behave more like a brand system without overbuilding tooling.

## Stock-Image Rule

If a feed or Story needs stock-style human, object, lifestyle, or environment imagery:

- do not default to outside stock libraries
- do not skip the image decision and hope the layout can solve it later
- use Unsplash first when a premium real-photo stock plate is enough
- use Nano Banana when the image needs to be more custom than stock
- have the prompt engineer create a dedicated Nano Banana prompt only when the chosen `source_lane` is `Nano-Banana-source-image`
- keep text-led assets design-first when possible so Nano Banana only has to generate the image plate

## Best-Practice Rule

If a field helps humans plan the month, it can live in the calendar.

If a field only helps downstream execution, it should live in the post-calendar layer.

## Mitozz Recommendation

For this project, the best default workflow is:

1. keep the calendar lean
2. resolve templates from the central mapping rules
3. classify stories after the calendar is approved
4. build creative packages from that resolved structure
5. enforce consistency at the batch-review stage
6. record reusable mistakes so future batches improve automatically
7. when a correction becomes a pattern, codify it immediately instead of relying on memory

This is the cleanest path for speed, consistency, and future automation.
