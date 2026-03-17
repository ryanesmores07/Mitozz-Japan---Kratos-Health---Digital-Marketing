Nano Banana Instagram Workspace
================================

This workspace is organized for creating and maintaining **reusable JSON prompts** for Nano Banana Pro, focused on **Instagram organic marketing** (Feed posts and Stories).

## Structure

- `brand/`: Brand identity and visual references that keep images consistent.
- `.agents/skills/`: Codex-native repository skills.
- `prompts/`: Reusable JSON prompts and their schemas, organized by Instagram format.
- `workflows/`: Short checklists describing how you use prompts and Nano Banana Pro.

## Skills and Workflow

This project is wired into Codex using four project-local skills under `.agents/skills/`:

- `mitozz-content-calendar`: plans and drafts the **monthly Mitozz Japan Instagram content calendar** (feed, reels, stories) based on audience research, brand strategy, and prior calendars.
- `mitozz-creatives-director`: turns calendar rows into **creative direction packages** with positioning, Japanese copy, captions, layout ideas, and Nano Banana-ready visual guidance.
- `mitozz-prompt-engineer`: converts the creatives director output into **consistent Nano Banana Pro JSON prompt files** under `prompts/instagram/feed/` and `prompts/instagram/stories/`.
- `nano-banana-instagram`: takes finalized prompt files and uses **Nano Banana Pro MCP** to generate the actual Instagram creatives.

Both skills follow Anthropic-style patterns:

- concise `SKILL.md` entrypoints with clear “what + when” descriptions,
- links to one-level-deep reference material (e.g. `references/prompt-examples.md`),
- workflows that assume the agent already knows general best practices.

The repository now treats `.agents/skills/` as the single source of truth for skill discovery and maintenance.

## Typical Flow

1. Use `mitozz-content-calendar` to create or revise a monthly calendar under `brand/references/business-context/content-planning/`.
2. Use `mitozz-creatives-director` to turn specific dates or date ranges into creative packages with Japanese messaging, design direction, and Nano Banana handoff guidance.
3. Use `mitozz-prompt-engineer` to create or update the final prompt JSON under `prompts/instagram/feed/` or `prompts/instagram/stories/`.
4. Use `nano-banana-instagram` to execute Nano Banana Pro MCP using those prompt files.
5. Reuse the saved prompts for future iterations, keeping naming aligned with `prompts/schema/naming-conventions.md`.

## Prompt Naming

Use date-based filenames so the execution skill can reliably match prompts from calendar-driven requests:

- Feed: `ig-feed-YYYY-MM-DD-theme-v01.json`
- Story: `ig-story-YYYY-MM-DD-theme-v01.json`

Examples:

- `ig-feed-2026-03-23-mitochondria-basics-v01.json`
- `ig-story-2026-03-23-mitochondria-basics-reinforcement-v01.json`
