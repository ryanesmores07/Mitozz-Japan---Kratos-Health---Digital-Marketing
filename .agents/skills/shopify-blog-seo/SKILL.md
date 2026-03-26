---
name: shopify-blog-seo
description: Analyze an attached or linked blog draft and produce a Shopify-ready SEO package. Use when the user provides a blog document, PDF, DOCX, pasted draft, or article text and wants SEO image filenames, SEO image alt text, English and Japanese excerpts, English and Japanese meta descriptions, a URL handle, and a Shopify Magic hero-image generation prompt.
---

# Shopify Blog SEO

Use this skill when the user wants a blog turned into a compact SEO and publishing package for Shopify.

Focus on extracting the real topic, search intent, audience promise, and hero-image concept from the source blog before writing any output.

## Inputs To Use

Read only what is needed:

1. The attached blog file or pasted blog text
2. Any user instructions about brand voice, target keywords, audience, or language preferences
3. [references/shopify-media-generation.md](references/shopify-media-generation.md) before writing the hero-image prompt

If the source is a PDF where layout matters, use the PDF workflow already available in the environment.
If the source is a DOCX or similar document, extract the text faithfully and preserve headings where useful.

## Core Job

Produce these six outputs:

1. SEO image file names
2. SEO image alt text
3. Excerpts in English and Japanese
4. Meta descriptions in English and Japanese
5. URL handle
6. Shopify Magic hero-image prompt

Do not drift into a full content rewrite unless the user explicitly asks for it.

## Working Method

1. Read the full source before drafting outputs.
2. Identify:
   - the main topic
   - the strongest keyword theme
   - the audience problem or intent
   - the clearest benefit or takeaway
   - any product, brand, or geographic context that should appear in metadata
3. Infer one primary search intent. Prefer clarity over keyword stuffing.
4. Create outputs that sound natural and readable first, then optimize for SEO.
5. Keep English and Japanese versions aligned in meaning, not word-for-word literal.

## Output Rules

### 1. SEO Image File Names

Provide `3-5` recommended file names for the blog hero image.

Rules:

- use lowercase only
- use hyphens, not spaces or underscores
- use `.jpg` unless the user asks for another format
- include the main keyword theme
- keep names descriptive but not bloated
- avoid duplicate near-variants that add no real value

Prefer patterns like:

- `primary-topic-benefit.jpg`
- `brand-topic-guide.jpg`
- `topic-for-audience.jpg`

### 2. SEO Image Alt Text

Provide `3-5` alt text options for the hero image.

Rules:

- describe the image for accessibility first
- keep the main keyword naturally present when it fits
- do not stuff keywords
- do not begin every option with the same phrase
- align the alt text with the proposed hero-image concept

### 3. Excerpts

Write:

- one English excerpt
- one Japanese excerpt

Rules:

- keep each excerpt concise and publishable
- summarize the article's value, not just its title
- make it suitable for blog listing cards or previews
- keep tone consistent with the source material

### 4. Meta Descriptions

Write:

- one English meta description
- one Japanese meta description

Rules:

- aim for search-snippet readability
- front-load the main topic when natural
- emphasize the reader benefit or what they will learn
- avoid robotic phrasing and avoid quotation marks unless necessary

### 5. URL Handle

Provide one recommended Shopify URL handle.

Rules:

- lowercase only
- hyphen-separated
- concise but specific
- derived from the article's strongest keyword theme
- omit date prefixes unless the user explicitly wants date-based URLs
- omit stopwords when they do not improve clarity

### 6. Shopify Magic Hero-Image Prompt

Write one prompt designed for Shopify's image generation workflow.

Rules:

- follow the guidance in [references/shopify-media-generation.md](references/shopify-media-generation.md)
- write in short natural-language keyword phrases separated by commas
- keep it simple and non-conversational
- target a blog hero image, not a product listing image
- describe:
  - scene or setting
  - subject
  - lighting
  - camera angle or framing
  - style or mood
- ground the subject in the environment when relevant so objects do not appear to float
- include size or scale cues when relevant
- avoid long instruction chains
- avoid text rendered inside the image unless the user explicitly asks for it

## Output Format

Use this exact section order:

### SEO Image File Names

- `filename-1.jpg`
- `filename-2.jpg`

### SEO Image Alt Text

- `alt text option 1`
- `alt text option 2`

### Excerpt

- English: `...`
- Japanese: `...`

### Meta Description

- English: `...`
- Japanese: `...`

### URL Handle

`recommended-url-handle`

### Shopify Hero Image Prompt

`prompt text`

## Decision Standards

- Prefer one strong primary keyword theme over multiple competing ones.
- Prefer human-readable SEO over maximal keyword density.
- If the blog covers multiple subtopics, write metadata around the clearest central promise.
- If the blog is weakly structured, infer a clean organizing theme instead of mirroring messy source wording.
- If the source language is only English, still provide natural Japanese output unless the user says otherwise.
- If the source language is only Japanese, still provide natural English output unless the user says otherwise.

## Safety And Quality Checks

Before answering, verify:

- the output clearly matches the source article
- the English and Japanese copy say the same core thing
- the URL handle matches the main search theme
- the image filenames and alt text align with the proposed hero visual
- the Shopify prompt is concise and formatted for Shopify Magic rather than a chat model
- no section is missing

If the attached file is unreadable or missing key content, say what is missing and stop instead of inventing the article.
