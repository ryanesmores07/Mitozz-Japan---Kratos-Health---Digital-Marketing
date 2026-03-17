# Prompt Examples

Use these as compact Nano Banana examples that separate image references from document references.

## Feed Example

```json
{
  "asset_type": "instagram-feed",
  "image_references": [
    {
      "path": "brand/references/business-context/visual/reference-pack/style-anchors/anchor-product-glow-01.jpg",
      "role": "style-anchor",
      "influence": ["palette", "lighting", "product framing"],
      "match_strength": "medium"
    },
    {
      "path": "brand/references/business-context/visual/reference-pack/working-examples/feed-product-glow-thumb.jpg",
      "role": "working-example",
      "influence": ["product framing", "soft glow treatment"],
      "match_strength": "medium"
    }
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
      "influence": ["text-first hierarchy", "simple vertical composition"],
      "match_strength": "medium"
    }
  ],
  "reference_files": [
    "brand/references/business-context/visual/Brand Visual Direction.md",
    "brand/references/business-context/content-planning/Mitozz Instagram Content Calendar - 2026 - March.csv"
  ],
  "notes": "Keep the Steel Light mood consistent while rotating exact frame layout and focal placement."
}
```
