# Mitozz Japan - Claude Project Instructions

## Project Overview

This is the production workspace for Mitozz Japan, a premium, science-led, mitochondria-first wellness brand built around epicatechin. The primary channel is Instagram organic content (feed, stories, reels) with supporting Shopify blog SEO and retainer reporting workflows.

The client is Jay Revels, a 50-year-old American living in Tokyo, Japan. The Shopify store is at https://mitozzjp.myshopify.com/.

## Skill System

This project uses Claude skills stored in `.claude/skills/`. Each skill has a `SKILL.md` as its primary entrypoint, with optional `references/` and `scripts/` subdirectories.

### Production Pipeline Skills (use in this order)

1. **mitozz-instagram-strategist** - Account-level direction, priorities, and next actions
2. **mitozz-content-calendar** - Monthly Instagram content calendar planning
3. **mitozz-creatives-director** - Creative briefs from calendar rows (all viewer-facing decisions)
4. **mitozz-prompt-engineer** - Encode creative packages into Nano Banana JSON prompts
5. **nano-banana-instagram** - Execute Nano Banana MCP for image generation
6. **mitozz-compositor-executor** - Final-build assembly for production assets
7. **mitozz-posting-copy-optimizer** - Publication-ready Japanese captions and hashtags

### Support Skills

- **mitozz-icon-sourcing** - Better Icons semantic icon selection
- **mitozz-stock-image-sourcing** - Unsplash stock photos (explicit user request only)
- **drive-delivery** - Upload approved assets to Google Drive
- **jay-invoice-sheets** - Monthly salary and expense Google Sheets
- **retainer-reporting** - Retainer action logs and monthly summaries
- **shopify-blog-seo** - Blog SEO packages for Shopify

## Key Directories

- `brand/references/business-context/` - All brand, strategy, audience, and visual reference files
- `brand/references/business-context/content-planning/` - Content calendars (CSV)
- `brand/references/business-context/creative-packages/` - Creative briefs and posting copy packs
- `brand/references/business-context/visual/` - Design system, template mappings, reference packs
- `brand/references/business-context/reporting/` - Delivery receipts, action logs, metrics, invoicing
- `prompts/instagram/` - JSON prompt files for Nano Banana generation
- `output/instagram/` - Generated creative assets
- `workflows/` - Execution checklists and production guides
- `tools/` - PowerShell and Python automation utilities

## Non-Negotiable Brand Rules

- Premium, science-led, mitochondria-first positioning
- Education-first organic growth: awareness and trust before conversion
- Calm, premium, modern, medically responsible tone
- Japan general-food-safe compliant messaging
- No direct medical, anti-aging, fatigue-recovery, or guaranteed-result claims
- Steel Light visual system: soft steel-blue, minimal layout, airy spacing, one message per frame

## Core Personas

1. Sleep-Deprived High Performer
2. Healthy Aging Planner
3. Research-First Wellness Optimizer

## Content Pillars

1. Mitochondria, Explained Simply
2. Epicatechin and the Science Story
3. Better Function, Not Hype
4. Trust, Safety, and Premium Proof

## Skill Routing

When the user asks what to do next or for strategic direction, start with `mitozz-instagram-strategist`.
When the user asks for a calendar, use `mitozz-content-calendar`.
When the user asks for a creative brief for a specific date or post, use `mitozz-creatives-director`.
When the user wants to build prompt JSON, use `mitozz-prompt-engineer`.
When the user wants to generate images, use `nano-banana-instagram`.
When the user wants final assembly, use `mitozz-compositor-executor`.
When the user wants posting captions, use `mitozz-posting-copy-optimizer`.
When the user wants to deliver to Drive, use `drive-delivery`.
When the user wants to log retainer work or draft a summary, use `retainer-reporting`.
When the user provides a blog draft for SEO, use `shopify-blog-seo`.

## Communication Style

When creating responses to the client using WhatsApp, maintain an authoritative, confident, yet friendly and approachable tone. Deliver concise, actionable, execution-ready responses aligned with Mitozz's goals.

## Important Notes

- All customer-facing copy must be in natural Japanese unless explicitly asked otherwise
- Use attached files as the single source of truth - do not make assumptions
- Recommend only proven best practices and practical solutions
- Prioritize clarity, efficiency, and real-world execution over theory
- When logging retainer work, use the significance rule defined in the retainer-reporting skill
