# Prompt Examples

Use these as compact Nano Banana examples that separate image references from document references.

Treat `style-anchors/` as the default source of visual guidance. Only use `working-examples/` when an asset was explicitly approved into that folder.

## Feed Example

```json
{
  "asset_type": "instagram-feed",
  "asset_archetype": "product-hero",
  "image_references": [
    {
      "path": "brand/references/business-context/visual/reference-pack/style-anchors/anchor-product-glow-01.jpg",
      "role": "style-anchor",
      "influence": ["palette", "lighting", "product framing"],
      "match_strength": "medium"
    },
    {
      "path": "brand/references/business-context/visual/reference-pack/style-anchors/anchor-cool-palette-01.jpg",
      "role": "style-anchor",
      "influence": ["palette", "restraint"],
      "match_strength": "medium"
    }
  ],
  "reference_strategy": "Use the product-glow anchor for lighting and framing and the cool-palette anchor for overall tone.",
  "variation_guardrails": [
    "change crop and angle",
    "avoid repeating the same reflection pattern"
  ],
  "reference_files": [
    "brand/references/business-context/visual/Brand Visual Direction.md",
    "brand/references/business-context/content-planning/"
  ],
  "notes": "Match palette, lighting, whitespace, and restraint. Do not copy exact crop or reflection pattern."
}
```

## Story Example

```json
{
  "asset_type": "instagram-story",
  "asset_archetype": "story-reinforcement",
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
      "influence": ["soft atmosphere", "restraint"],
      "match_strength": "medium"
    }
  ],
  "reference_strategy": "Use one anchor for breathing room and one anchor for steel-blue atmosphere.",
  "variation_guardrails": [
    "shift exact frame layout",
    "change focal placement"
  ],
  "reference_files": [
    "brand/references/business-context/visual/Brand Visual Direction.md",
    "brand/references/business-context/content-planning/Mitozz Instagram Content Calendar - 2026 - March.csv"
  ],
  "notes": "Keep the Steel Light mood consistent while rotating exact frame layout and focal placement."
}
```
