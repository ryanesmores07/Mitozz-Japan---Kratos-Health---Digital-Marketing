---
name: mitozz-posting-copy-optimizer
description: Create publication-ready Japanese Instagram captions, hashtag sets, and posting notes for the approved Mitozz Japan asset of a specific date. Use when a feed or reel needs finalized posting copy, discovery-aware keyword phrasing, SEO/search-aware caption structure, a high-fit hashtag set, or a maintained posting-copy pack aligned to the approved creative package and final asset.
---

# Mitozz Posting Copy Optimizer

Use this skill after the asset direction is approved and before the asset is treated as fully production-ready, delivered, or scheduled.

This skill is focused only on posting copy for the approved asset on that date.

It does not redesign the visual.
It does not rewrite the concept.
It turns the approved asset into ready-to-publish posting language.

If the completed work materially advances production readiness or closes a workflow gap, add a concise entry to the current monthly retainer action log under `brand/references/business-context/reporting/monthly-action-logs/`.

## Role

This skill owns:

- `caption_ja`
- `hashtag_set`
- optional `first_comment_ja`
- posting notes tied to the approved asset
- posting-copy pack maintenance

This skill does not own:

- the core message angle
- the visual concept
- on-canvas copy changes

Those stay with `mitozz-creatives-director`.

## Inputs To Read

Read only what is needed:

1. the approved calendar row
2. the approved creative package for that date
3. the approved asset output path or delivered production lineage
4. the current posting-copy pack if one already exists for the date window
5. relevant approved-post library entries only if needed to avoid repetition

## Source Of Truth

Use this priority order:

1. approved creative package
2. approved final asset
3. calendar row
4. existing posting-copy pack conventions

Do not let the caption drift away from the approved asset.

## Required Output

For each feed or reel, prepare:

- `Topic`
- `Caption`
- `Hashtags`
- `Story support` notes when relevant

Optional:

- `Suggested first comment`

## Caption Rules

Write in natural Japanese that feels:

- premium
- calm
- specific
- easy to read in Instagram
- compliant for Japan general-food-safe communication

Do:

- align tightly with the approved post angle
- front-load the main searchable topic words naturally in the opening lines
- preserve the same reading lens as the visual asset
- aim for saves, trust, clarity, and repeat familiarity before hard conversion
- end with a soft CTA that matches the post goal

Do not:

- invent a new angle
- add medical or guaranteed-result claims
- write like a noisy supplement ad
- overstuff the caption with keywords
- let hashtags carry the meaning instead of the caption

## Search / Discovery Optimization

Treat "SEO" here as Instagram discovery and search optimization, not web SEO.

Optimize by:

- using the core Japanese topic nouns early
- matching the audience's likely everyday phrasing, not only technical jargon
- reinforcing the exact concept shown on the cover and body slides
- keeping the caption semantically aligned with the saved post

Examples of useful keyword behavior:

- `睡眠`
- `食事`
- `運動`
- `ミトコンドリア`
- `毎日の土台`
- `信頼`
- `品質`
- `サプリ選び`

Use only the words that actually belong to that asset.

## Hashtag Rules

Default to `3-5` highly relevant hashtags only.

Weight them toward:

1. brand
2. core topic
3. user intent
4. asset context

Good mix:

- one brand tag
- one core-topic tag
- one supporting concept tag
- one intent or lens tag
- one context tag when truly useful

Avoid:

- large generic discovery stacks
- spammy trend tags
- English filler tags unless the asset genuinely needs them
- weak tags that do not match the caption or creative package

## Workflow

1. identify the exact approved asset and date
2. read the creative package and the calendar row
3. extract the locked message angle, CTA, and persona
4. write the caption from that approved angle
5. generate a short relevance-weighted hashtag set
6. update the active posting-copy pack if one exists for that date window
7. if no pack exists, create one in `brand/references/business-context/creative-packages/`
8. do not mark the asset fully production-ready until this is done

## Coordination Rules

- `mitozz-creatives-director` decides the message angle
- `mitozz-posting-copy-optimizer` turns that angle into publish-ready caption language
- `mitozz-compositor-executor` should not be the one improvising caption language
- `mitozz-instagram-strategist` can call for posting-copy work when deciding what ships next

## Output Pattern

Use this structure in posting-copy packs:

```md
## `YYYY-MM-DD` Feed Carousel

Topic:

`...`

Caption:

```text
...
```

Hashtags:

`#... #... #...`
```

Keep the pack lean and posting-ready.
