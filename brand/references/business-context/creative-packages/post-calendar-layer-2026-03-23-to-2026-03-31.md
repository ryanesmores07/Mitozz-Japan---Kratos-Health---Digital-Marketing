# Mitozz Post-Calendar Layer

## Window

`2026-03-23` to `2026-03-31`

Use this file after calendar approval and before prompt execution.

This is the lean production handoff layer for the active March batch. It resolves only the downstream decisions that should not live in the calendar itself.

## Resolved Production Layer

| Date | Asset | Topic | Template Set | Slide Blueprint | asset_archetype | story_type | posting_action | approved_references | next_action |
| --- | --- | --- | --- | --- | --- | --- | --- | --- | --- |
| 2026-03-23 | Feed | Mitochondria basics education carousel | `Set 1 + Set 2` | `5-slide` | `education-card` | `-` | `-` | `education-white-card.png`, `feed-education-white-card-01.png`, `anchor-education-layout-01.png`, `anchor-cool-palette-01.png` | `approved production set exists` |
| 2026-03-23 | Story | Mitochondria basics reinforcement story | `Set 1` | `story-3-frame` | `story-reinforcement` | `feed-reinforcement` | `feed-route` | `education-white-card.png`, `feed-education-white-card-01.png`, `anchor-cool-palette-01.png` | `approved production set exists` |
| 2026-03-25 | Feed | Daily condition reel source set | `Set 4 + Set 3` | `reel-4-shot` | `reel-source-frame` | `-` | `-` | `anchor-editorial-whitespace-01.png`, `anchor-cool-palette-01.png`, `anchor-product-glow-01.png`, `mitozz-bottle.jpg`, `Mitozz Bottle Size Spec.md` | `approved 9:16 source set exists in output/instagram/reels/2026-03-25-reel-daily-condition-v01/current/` |
| 2026-03-25 | Story | Busy day context story | `Set 4` | `story-3-frame` | `story-reinforcement` | `daily-context` | `poll` | `set-4-lifestyle-v02-no-bottle.png`, `anchor-editorial-whitespace-01.png`, `anchor-cool-palette-01.png` | `prompt and production set exist` |
| 2026-03-26 | Story | Stimulus vs balance poll story | `Set 4` | `story-3-frame` | `story-reinforcement` | `interactive` | `poll` | `set-4-lifestyle-v02-no-bottle.png`, `anchor-editorial-whitespace-01.png`, `anchor-cool-palette-01.png` | `prompt and production set exist` |
| 2026-03-27 | Feed | Epicatechin basics education carousel | `Set 1 + Set 2` | `6-slide` | `education-card` | `-` | `-` | `education-white-card.png`, `feed-education-white-card-01.png`, `anchor-education-layout-01.png`, `anchor-cool-palette-01.png` | `approved production set exists` |
| 2026-03-27 | Story | Epicatechin Q&A story | `Set 1` | `story-3-frame` | `story-reinforcement` | `interactive` | `question-box` | `feed-education-white-card-01.png`, `anchor-cool-palette-01.png`, `anchor-editorial-whitespace-01.png` | `approved story set exists` |
| 2026-03-30 | Feed | Trustworthy supplement choice carousel | `Set 5 + Set 1` | `3-slide` | `trust-carousel` | `-` | `-` | `set-5-trust-portrait-v01.png`, `feed-education-white-card-01.png`, `anchor-portrait-trust-01.png`, `anchor-body-copy-01.png` | `create prompt and generate` |
| 2026-03-30 | Story | Trust question story | `Set 5 + Set 1` | `story-3-frame` | `story-reinforcement` | `interactive` | `poll` | `set-5-trust-portrait-v01.png`, `feed-education-white-card-01.png`, `anchor-portrait-trust-01.png` | `create prompt and generate` |

## How To Use This File

1. Read the approved calendar row.
2. Read this resolved production layer.
3. If the asset is a story, check [story-posting-actions-2026-03-23-to-2026-03-31.md](story-posting-actions-2026-03-23-to-2026-03-31.md).
4. Build or refine the creative package from this resolved structure.
5. Create the prompt using only the references listed here unless the asset clearly needs one more approved reference.
6. Review outputs against the batch consistency rules before approval.

## Notes

- `story_type` lives here on purpose instead of in the planning calendar.
- `posting_action` lives here so posting-time execution does not depend on memory.
- `Set 1 + Set 2` remains the default education mode unless product presence is genuinely needed.
- `Set 5 + Set 1` stories should stay lighter and more conversational than the matching feed asset.
- generated assets that are no longer on the active calendar should be treated as backup or highlight material, not live production obligations.

