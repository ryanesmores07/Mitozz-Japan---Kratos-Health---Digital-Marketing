# Mitozz Prompt Engineer Examples

These examples show how creative-direction output should be turned into final Nano Banana prompt JSON with both document references and image references.

Use `style-anchors/` as the default visual source. Add `working-examples/` only when an asset was explicitly approved into that folder.

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
      "path": "brand/references/business-context/visual/reference-pack/style-anchors/anchor-education-layout-01.jpg",
      "role": "style-anchor",
      "influence": ["whitespace", "editorial education layout", "palette"],
      "match_strength": "medium"
    },
    {
      "path": "brand/references/business-context/visual/reference-pack/style-anchors/anchor-cool-palette-01.jpg",
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
      "path": "brand/references/business-context/visual/reference-pack/style-anchors/anchor-product-glow-01.jpg",
      "role": "style-anchor",
      "influence": ["lighting", "palette", "product framing"],
      "match_strength": "medium"
    },
    {
      "path": "brand/references/business-context/visual/reference-pack/style-anchors/anchor-cool-palette-01.jpg",
      "role": "style-anchor",
      "influence": ["palette", "restraint"],
      "match_strength": "medium"
    }
  ],
  "reference_strategy": "Let the product-glow anchor drive lighting and framing, while the cool-palette anchor keeps the tone consistent.",
  "variation_guardrails": [
    "rotate angle and reflection pattern",
    "change crop and focal placement"
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
  "asset_archetype": "story-reinforcement",
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
      "path": "brand/references/business-context/visual/reference-pack/style-anchors/anchor-cool-palette-01.jpg",
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
