# Nano Banana Pro best practices

This document summarizes practices from the [awesome-nano-banana-pro-prompts](https://github.com/YouMind-OpenLab/awesome-nano-banana-pro-prompts) library (10,000+ curated prompts, 16 languages) and applies them to Mitozz Instagram execution.

## Source

- **Repo:** [YouMind-OpenLab/awesome-nano-banana-pro-prompts](https://github.com/YouMind-OpenLab/awesome-nano-banana-pro-prompts)
- **Use:** When building or passing prompts to Nano Banana Pro MCP, follow these patterns for consistent, high-quality results.

## Best practices (aligned with community prompts)

### 1. Specify aspect ratio explicitly

Nano Banana Pro responds well when the aspect ratio is stated clearly in the prompt.

- **Feed:** Always include `4:5` (e.g. “Aspect ratio: 4:5 vertical, Instagram feed.”).
- **Story:** Always include `9:16` (e.g. “Aspect ratio: 9:16 vertical, Instagram story.”).

Our prompt JSON already has `aspect_ratio`; when constructing the natural-language or structured prompt for the MCP, include this value explicitly.

### 2. Put exact on-image text in quotes

Community prompts that need accurate text (quote cards, titles, labels) put the **exact text to appear** in quotes inside the prompt. This improves faithful rendering.

- **Apply to our flow:** When sending the prompt to Nano Banana Pro, include the Japanese copy as quoted text, e.g.:
  - “Headline text: 「ミトコンドリアって、何？」”
  - “Slide 1: 「ミトコンドリアって、何？毎日のコンディションを考える、土台の話。」”
  - For carousel: “Slide 2: 「…」”, “Slide 3: 「…」”, etc.

So: pass `text_overlay.headline_ja` and each `text_overlay.slides_ja` entry as **quoted text** in the generation prompt, not only as metadata.

### 3. Use negative prompts

Featured prompts often include a dedicated **negative prompts** section (things to avoid), which reduces off-brand or low-quality outputs.

- Our JSON has `negative_prompts` (array). When calling the MCP, include these as “avoid: …” or equivalent so the model does not generate those elements.

### 4. Structured prompt sections

High-quality prompts in the repo use clear sections, e.g. Scene, Subject, Environment, Lighting, Camera, Negative prompts (or similar). Our JSON already provides:

- `visual_intent` → overall style and mood
- `composition` → layout and framing
- `brand_guardrails` → do’s and don’ts
- `negative_prompts` → avoid list

When building the prompt for the MCP, keep this structure readable (e.g. “Visual style: …”, “Composition: …”, “Avoid: …”) so the model gets precise control.

### 5. Japanese and multilingual

The library supports Japanese (JA) and 16+ languages. For Mitozz Japan:

- Use the **exact Japanese strings** from our prompt file (`headline_ja`, `slides_ja`); do not translate or rephrase.
- If the MCP or model supports a “language” or “locale” hint, set it to Japanese so typography and layout stay appropriate.

### 6. Quality and reproducibility

From the repo’s quality standards:

- **Clear and reproducible:** Our prompt files are versioned and structured so the same JSON produces consistent intent.
- **Structured:** We use a fixed schema (asset_type, aspect_ratio, visual_intent, composition, text_overlay, negative_prompts, etc.) so every execution has the same control levers.

## Summary for the execution agent

When calling Nano Banana Pro MCP with a Mitozz prompt JSON:

1. **Aspect ratio:** State the prompt’s `aspect_ratio` explicitly (4:5 or 9:16).
2. **Exact text:** Include `headline_ja` and each `slides_ja` entry as **quoted text** in the generation prompt so the image shows that text accurately.
3. **Structure:** Map `visual_intent`, `composition`, and `brand_guardrails` into clear prompt sections.
4. **Negative prompts:** Pass `negative_prompts` as things to avoid.
5. **No copy changes:** Do not alter or regenerate the Japanese copy; use it verbatim.

These practices align our skill with the [awesome-nano-banana-pro-prompts](https://github.com/YouMind-OpenLab/awesome-nano-banana-pro-prompts) library and improve text accuracy and brand consistency.
