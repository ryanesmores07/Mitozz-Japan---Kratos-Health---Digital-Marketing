# Mitozz Prompt Engineer Examples

These examples show how creative-direction output should be turned into final Nano Banana prompt JSON with both document references and image references.

## Feed Educational Carousel Example

```json
{
  "asset_type": "instagram-feed",
  "campaign_name": "March Organic Education",
  "topic": "What are mitochondria?",
  "objective": "Educate",
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
      "path": "brand/references/business-context/visual/reference-pack/style-anchors/anchor-education-layout-01.jpg",
      "role": "style-anchor",
      "influence": ["whitespace", "editorial education layout", "palette"],
      "match_strength": "medium"
    },
    {
      "path": "brand/references/business-context/visual/reference-pack/working-examples/feed-education-whitespace-thumb.jpg",
      "role": "working-example",
      "influence": ["whitespace", "text-first balance"],
      "match_strength": "medium"
    }
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
  "platform": "instagram",
  "aspect_ratio": "4:5",
  "image_references": [
    {
      "path": "brand/references/business-context/visual/reference-pack/style-anchors/anchor-product-glow-01.jpg",
      "role": "style-anchor",
      "influence": ["lighting", "palette", "product framing"],
      "match_strength": "medium"
    },
    {
      "path": "brand/references/business-context/visual/reference-pack/working-examples/feed-product-glow-thumb.jpg",
      "role": "working-example",
      "influence": ["product framing", "soft glow treatment"],
      "match_strength": "medium"
    }
  ],
  "notes": "Match premium glow and restraint. Rotate angle and reflection pattern."
}
```

## Story Example

```json
{
  "asset_type": "instagram-story",
  "campaign_name": "March Organic Education",
  "topic": "Story reinforcement",
  "objective": "Reinforce",
  "platform": "instagram",
  "aspect_ratio": "9:16",
  "image_references": [
    {
      "path": "brand/references/business-context/visual/reference-pack/style-anchors/anchor-editorial-whitespace-01.jpg",
      "role": "style-anchor",
      "influence": ["palette", "vertical breathing room"],
      "match_strength": "medium"
    },
    {
      "path": "brand/references/business-context/visual/reference-pack/working-examples/story-text-first-thumb.jpg",
      "role": "working-example",
      "influence": ["vertical breathing room", "text-first hierarchy"],
      "match_strength": "medium"
    }
  ],
  "notes": "Keep the mood aligned while varying exact frame layout and focal placement."
}
```
