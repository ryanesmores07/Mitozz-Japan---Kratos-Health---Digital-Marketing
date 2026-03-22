# Mitozz Post-Calendar Layer 01

## Window

`2026-03-23` to `2026-03-31`

Use this file after calendar approval and before prompt execution.

This is the lean production handoff layer for the current March batch.

## Purpose

This file resolves the minimum downstream decisions that should not live in the calendar itself:

- `Template Set`
- `Slide Blueprint`
- `asset_archetype`
- `story_type` when the asset is a story
- `posting_action` when the asset is a story
- `approved_references`
- `next_action`

## Resolved Production Layer

| Date | Asset | Topic | Template Set | Slide Blueprint | asset_archetype | story_type | posting_action | approved_references | next_action |
| --- | --- | --- | --- | --- | --- | --- | --- | --- |
| 2026-03-23 | Feed | ミトコンドリアとは？毎日の土台をやさしく理解する | `Set 1 + Set 2` | `5-slide` | `education-card` | `-` | `-` | `education-white-card.png`, `feed-education-white-card-01.png`, `anchor-education-layout-01.png`, `anchor-cool-palette-01.png` | `approved production set exists` |
| 2026-03-23 | Story | ミトコンドリア基礎投稿の補足 | `Set 1` | `story-3-frame` | `story-reinforcement` | `feed-reinforcement` | `feed-route` | `education-white-card.png`, `feed-education-white-card-01.png`, `anchor-cool-palette-01.png` | `approved production set exists` |
| 2026-03-25 | Feed | 頑張りに頼る前に毎日のコンディション設計を見直す | `Set 4 + Set 3` | `reel-4-shot` | `reel-source-frame` | `-` | `-` | `anchor-editorial-whitespace-01.png`, `anchor-cool-palette-01.png`, `anchor-product-glow-01.png`, `mitozz-bottle.jpg`, `Mitozz Bottle Size Spec.md` | `approved 9:16 source set exists in 2026-03-25-daily-condition-v02; edit blueprint exists` |
| 2026-03-25 | Story | 忙しい日に重ねやすい共感ストーリー | `Set 4` | `story-3-frame` | `story-reinforcement` | `daily-context` | `poll` | `set-4-lifestyle-v02-no-bottle.png`, `anchor-editorial-whitespace-01.png`, `anchor-cool-palette-01.png` | `prompt and production set exist` |
| 2026-03-26 | Story | 刺激より整えるアプローチに共感できる？ | `Set 4` | `story-3-frame` | `story-reinforcement` | `interactive` | `poll` | `set-4-lifestyle-v02-no-bottle.png`, `anchor-editorial-whitespace-01.png`, `anchor-cool-palette-01.png` | `prompt and production set exist` |
| 2026-03-27 | Feed | エピカテキンとは？Mitozzの中心成分をわかりやすく整理する | `Set 1 + Set 2` | `6-slide` | `education-card` | `-` | `-` | `education-white-card.png`, `feed-education-white-card-01.png`, `anchor-education-layout-01.png`, `anchor-cool-palette-01.png` | `approved production set exists in v03` |
| 2026-03-27 | Story | エピカテキン導入Q&A | `Set 1` | `story-3-frame` | `story-reinforcement` | `interactive` | `question-box` | `feed-education-white-card-01.png`, `anchor-cool-palette-01.png`, `anchor-editorial-whitespace-01.png` | `approved story set exists in ig-story-2026-03-27-epicatechin-qa-v01` |
| 2026-03-30 | Feed | なぜ今信頼できるサプリ選びが大切なのか | `Set 5 + Set 1` | `3-slide` | `trust-carousel` | `-` | `-` | `set-5-trust-portrait-v01.png`, `feed-education-white-card-01.png`, `anchor-portrait-trust-01.png`, `anchor-body-copy-01.png` | `create prompt and generate` |
| 2026-03-30 | Story | ブランドを信頼する時に何を見る？ | `Set 5 + Set 1` | `story-3-frame` | `story-reinforcement` | `interactive` | `poll` | `set-5-trust-portrait-v01.png`, `feed-education-white-card-01.png`, `anchor-portrait-trust-01.png` | `create poll or question-story prompt` |

## How To Use This File

1. Read the approved calendar row.
2. Read this resolved production layer.
3. If the asset is a story, check the posting instructions in [story-posting-actions-2026-03-23-to-2026-03-31.md](/Users/ernieryanesmores/Desktop/Workspace/Mitozz-Japan---Kratos-Health---Digital-Marketing/brand/references/business-context/creative-packages/story-posting-actions-2026-03-23-to-2026-03-31.md).
4. Build or refine the creative package from this resolved structure.
5. Create the prompt using only the references listed here unless the asset clearly needs one more approved reference.
6. Review outputs against the batch consistency rules before approval.

## Notes

- `story_type` lives here on purpose instead of in the planning calendar.
- `posting_action` lives here so posting-time execution does not depend on memory.
- `Set 1 + Set 2` is the default education mode unless product presence is genuinely needed.
- `Set 5 + Set 1` stories should stay lighter and more conversational than the matching feed asset.
- `Set 4` story rows should favor human context and interaction over text-only repetition.
- generated assets that are no longer on the active calendar should be treated as backup or Highlight material, not live production obligations
