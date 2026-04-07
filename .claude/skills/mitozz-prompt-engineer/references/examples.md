# Mitozz Prompt Engineer Examples

These examples show how creative-direction output should be turned into final Nano Banana prompt JSON with both document references and image references.

Use `style-anchors/` as the default visual source. Add approved `source-intake/` bottle photos as `product-source` references when pack fidelity matters. Add `working-examples/` only when an asset was explicitly approved into that folder.

## Feed Educational Carousel Example

```json
{
  "asset_type": "instagram-feed",
  "campaign_name": "March Organic Education",
  "topic": "What are mitochondria?",
  "objective": "Educate",
  "asset_archetype": "education-card",
  "platform": "instagram",
  "aspect_ratio": "4:5",
  "audience": "Research-First Wellness Optimizer",
  "visual_intent": [
    "premium wellness editorial",
    "calm educational clarity",
    "cool steel-blue atmosphere with airy white space",
    "warm apricot used only as a restrained signal"
  ],
  "composition": [
    "text-first educational carousel",
    "cloud-white base with mist-blue atmosphere",
    "strong negative space"
  ],
  "image_references": [
    {
      "path": "brand/references/business-context/visual/reference-pack/style-anchors/anchor-education-layout-01.png",
      "role": "style-anchor",
      "influence": ["whitespace", "editorial education layout", "palette"],
      "match_strength": "medium"
    },
    {
      "path": "brand/references/business-context/visual/reference-pack/style-anchors/anchor-cool-palette-01.png",
      "role": "style-anchor",
      "influence": ["palette", "lighting", "restraint"],
      "match_strength": "medium"
    }
  ],
  "reference_strategy": "Use the first anchor for whitespace and editorial restraint, and the second anchor for tonality and calm lighting.",
  "variation_guardrails": [
    "vary crop and camera distance",
    "avoid repeating exact text placement"
  ],
  "reference_files": [
    "brand/references/business-context/visual/Brand Visual Direction.md",
    "brand/references/business-context/content-planning/Mitozz Instagram Content Calendar - 2026 - March.csv"
  ],
  "notes": "Match mood and layout restraint. Do not copy exact text placement or crop."
}
```

## Product Hero Example

```json
{
  "asset_type": "instagram-feed",
  "campaign_name": "March Organic Education",
  "topic": "Product hero",
  "objective": "Trust build",
  "asset_archetype": "product-hero",
  "platform": "instagram",
  "aspect_ratio": "4:5",
  "image_references": [
    {
      "path": "brand/references/business-context/visual/reference-pack/style-anchors/anchor-product-glow-01.png",
      "role": "style-anchor",
      "influence": ["lighting", "palette", "product framing"],
      "match_strength": "medium"
    },
    {
      "path": "brand/references/business-context/visual/reference-pack/style-anchors/anchor-cool-palette-01.png",
      "role": "style-anchor",
      "influence": ["palette", "restraint"],
      "match_strength": "medium"
    },
    {
      "path": "brand/references/business-context/visual/reference-pack/source-intake/mitozz-bottle.jpg",
      "role": "product-source",
      "influence": ["pack fidelity", "label placement", "cap finish"],
      "match_strength": "medium"
    }
  ],
  "reference_strategy": "Let the anchors drive lighting and tone, and use the approved bottle photo only for product-truth details.",
  "variation_guardrails": [
    "rotate angle and reflection pattern",
    "change crop and focal placement",
    "do not inherit the source photo background"
  ],
  "notes": "Match premium glow and restraint while preserving bottle silhouette and label accuracy."
}
```

## Story Example

```json
{
  "asset_type": "instagram-story",
  "campaign_name": "March Organic Education",
  "topic": "Story reinforcement",
  "objective": "Reinforce",
  "asset_archetype": "story-reinforcement",
  "platform": "instagram",
  "aspect_ratio": "9:16",
  "image_references": [
    {
      "path": "brand/references/business-context/visual/reference-pack/style-anchors/anchor-editorial-whitespace-01.png",
      "role": "style-anchor",
      "influence": ["palette", "vertical breathing room"],
      "match_strength": "medium"
    },
    {
      "path": "brand/references/business-context/visual/reference-pack/style-anchors/anchor-cool-palette-01.png",
      "role": "style-anchor",
      "influence": ["palette", "soft atmosphere"],
      "match_strength": "medium"
    }
  ],
  "reference_strategy": "Use one anchor for breathing room and one anchor for the steel-blue atmosphere.",
  "variation_guardrails": [
    "change exact frame layout",
    "shift focal placement"
  ],
  "notes": "Keep the mood aligned while varying exact frame layout and focal placement."
}
```

## Reel Shot Example

```json
{
  "asset_type": "instagram-feed",
  "campaign_name": "March Organic Education",
  "topic": "Rethink daily condition design",
  "objective": "Educate",
  "asset_archetype": "reel-source-frame",
  "platform": "instagram",
  "aspect_ratio": "9:16",
  "audience": "Sleep-Deprived High Performer",
  "motion_role": "opening-hook",
  "shot_id": "shot-01",
  "shot_position": 1,
  "continuity_tokens": [
    "female Japanese professional in early 30s",
    "soft steel-blue morning light",
    "quiet premium apartment workspace",
    "calm editorial styling",
    "no baked-in text"
  ],
  "visual_intent": [
    "premium wellness editorial",
    "subtle tension before the reset",
    "clean negative space for later kinetic typography"
  ],
  "brand_guardrails": [
    "avoid exaggerated stress acting",
    "avoid trendy influencer styling",
    "preserve premium calm even in a busy-morning scene"
  ],
  "composition": [
    "vertical 9:16 framing",
    "subject slightly off-center",
    "clear top-third and lower-third text-safe zones",
    "single readable focal action"
  ],
  "image_references": [
    {
      "path": "brand/references/business-context/visual/reference-pack/style-anchors/anchor-editorial-whitespace-01.png",
      "role": "style-anchor",
      "influence": ["whitespace", "editorial restraint", "palette"],
      "match_strength": "medium"
    },
    {
      "path": "brand/references/business-context/visual/reference-pack/style-anchors/anchor-cool-palette-01.png",
      "role": "style-anchor",
      "influence": ["lighting", "soft steel-blue atmosphere"],
      "match_strength": "medium"
    }
  ],
  "reference_strategy": "Use the first anchor for vertical breathing room and the second for light quality and tonality.",
  "variation_guardrails": [
    "do not reuse an exact pose from the references",
    "keep background simpler than the anchors",
    "preserve continuity with later shots through wardrobe, palette, and lighting direction"
  ],
  "text_overlay": {
    "allowed": false,
    "max_words": 0,
    "tone": "premium, clear, restrained",
    "font_reference": "Noto Sans JP or closest available sans-serif for Japanese",
    "headline_ja": "",
    "slides_ja": []
  },
  "negative_prompts": [
    "cheap stock photo energy",
    "overacted stress expression",
    "busy cluttered desk",
    "harsh fitness-ad aesthetic"
  ],
  "reference_files": [
    "brand/references/business-context/visual/Brand Visual Direction.md"
  ],
  "notes": "Shot 01 of a coordinated reel set. Keep continuity tokens stable across all subsequent shots. If motion is needed later, write that separately with workflows/05-image-to-video-prompt-template.md."
}
```
