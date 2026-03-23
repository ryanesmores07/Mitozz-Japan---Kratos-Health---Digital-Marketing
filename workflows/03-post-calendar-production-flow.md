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
3. Build the creative package from the mapped result.
4. Create or update the prompt JSON when source images are needed.
5. Generate or collect the source assets.
6. If the asset is a reel, assemble the freelancer handoff packet.
7. Review against the batch consistency rules and the lessons log.
8. Regenerate only the failing outputs or revise only the unclear handoff sections.
9. Promote only approved outputs into the working set.

## Minimal Post-Calendar Data Model

After the calendar, every asset should resolve into this smaller production layer:

- `Template Set`
- `Slide Blueprint`
- `asset_archetype`
- `story_type` when the asset is a story
- `approved_references`

This is enough to automate the rest without turning the calendar into a production spreadsheet.

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

This is the cleanest path for speed, consistency, and future automation.
