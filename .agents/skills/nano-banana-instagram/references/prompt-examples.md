# Prompt Examples

Use these as compact Nano Banana examples that separate image references from document references.

Treat `style-anchors/` as the default source of visual guidance. Add approved bottle photos from `source-intake/` as `product-source` references when product fidelity matters. Only use `working-examples/` when an asset was explicitly approved into that folder.

## Feed Example

```json
{
  "asset_type": "instagram-feed",
  "asset_archetype": "product-hero",
  "image_references": [
    {
      "path": "brand/references/business-context/visual/reference-pack/style-anchors/anchor-product-glow-01.png",
      "role": "style-anchor",
      "influence": ["palette", "lighting", "product framing"],
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
  "reference_strategy": "Use anchors for art direction and the approved bottle photo for product-truth details only.",
  "variation_guardrails": [
    "change crop and angle",
    "avoid repeating the same reflection pattern",
    "do not inherit the source photo background"
  ],
  "reference_files": [
    "brand/references/business-context/visual/Brand Visual Direction.md",
    "brand/references/business-context/content-planning/"
  ],
  "notes": "Match palette, lighting, whitespace, and restraint while preserving bottle silhouette and label fidelity."
}
```

## Story Example

```json
{
  "asset_type": "instagram-story",
  "asset_archetype": "story-reinforcement",
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

## Reel Source-Frame Example

```json
{
  "asset_type": "instagram-feed",
  "asset_archetype": "reel-source-frame",
  "motion_role": "product-reveal",
  "shot_id": "shot-03",
  "shot_position": 3,
  "continuity_tokens": [
    "same female Japanese professional in early 30s",
    "soft steel-blue morning light",
    "quiet premium apartment workspace",
    "Mitozz bottle with the real front label facing camera cleanly",
    "matte black bottle body with black ribbed cap, visible neck ring, and centered label blocks kept readable",
    "no baked-in text"
  ],
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
      "influence": ["pack fidelity", "label placement", "bottle silhouette"],
      "match_strength": "medium"
    }
  ],
  "reference_strategy": "Use the anchors for light and tonality, and the approved bottle photo only for pack-truth details.",
  "variation_guardrails": [
    "preserve bottle orientation for continuity",
    "keep background minimal for clean animation",
    "avoid exact crop duplication from references"
  ],
  "reference_files": [
    "brand/references/business-context/visual/Brand Visual Direction.md",
    "brand/references/business-context/visual/Mitozz Locked Bottle Workflow.md",
    "brand/references/business-context/visual/Mitozz Bottle Size Spec.md"
  ],
  "notes": "One coordinated source frame in a reel shot set. Keep subject, light, and product fidelity aligned with adjacent shots. If motion is needed later, create it separately from the approved still."
}
```
