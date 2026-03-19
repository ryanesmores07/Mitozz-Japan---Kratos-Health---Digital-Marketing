Nano Banana Instagram Workspace
================================

This workspace is organized for creating and maintaining reusable JSON prompts for Nano Banana Pro, focused on Instagram organic marketing for Mitozz Japan.

Current model standard:

- Nano Banana Pro 2 = `gemini-3.1-flash-image-preview`
- Use Flash tier by default unless a task explicitly requires the Pro image tier

## Structure

- `brand/`: brand identity, strategy, creative packages, and visual references
- `.agents/skills/`: Codex-native repository skills
- `prompts/`: reusable JSON prompts organized by Instagram format
- `workflows/`: lean checklists for planning, packaging, generation, and approval
- `output/`: generated asset history and candidate working examples
- `tools/`: local helper scripts

## Skills And Workflow

This project is wired into Codex using four project-local skills under `.agents/skills/`:

- `mitozz-content-calendar`: plans the monthly Mitozz Japan Instagram calendar
- `mitozz-creatives-director`: turns calendar rows into decisive creative packages
- `mitozz-prompt-engineer`: converts creative packages into Nano Banana JSON prompts
- `nano-banana-instagram`: executes prompt files and generates the final assets

The repository treats `.agents/skills/` as the single source of truth for skill discovery and maintenance.

## Typical Flow

1. Use `mitozz-content-calendar` to create or revise the monthly calendar under `brand/references/business-context/content-planning/`.
2. Use `mitozz-creatives-director` to turn selected calendar rows into creative packages under `brand/references/business-context/creative-packages/`.
3. Use `mitozz-prompt-engineer` to create or update prompt JSON in `prompts/instagram/feed/` or `prompts/instagram/stories/`.
4. Use `nano-banana-instagram` to execute Nano Banana Pro MCP using those prompt files.
5. Review the outputs, approve winners, and promote only the best assets into the visual reference pack when appropriate.

For free rehearsal runs, use `tools/chatgpt-image-test-run.ps1` to turn an existing prompt JSON into a dry-run ChatGPT image-generation bundle without calling a paid API.

Use the checklists in `workflows/` to keep planning, creative packaging, generation, and approval lean and repeatable.

## Local Nano Banana MCP

This workspace now includes a repo-local launcher for the published Nano Banana MCP server:

- launcher: `tools/run-nanobanana-mcp.ps1`
- Cursor example config: `mcp/nanobanana.cursor.example.json`

Recommended setup:

1. Set `GEMINI_API_KEY` in your local environment or IDE secret store.
2. Point your MCP client at `tools/run-nanobanana-mcp.ps1`.
3. Do not commit real API keys into repo config files.

The launcher wraps:

- `uvx nanobanana-pro-mcp-server`

The workspace launcher also patches the MCP runtime to keep the Flash tier aligned to:

- `gemini-3.1-flash-image-preview`

This gives the workspace a stable local entrypoint even if the MCP client configuration differs between tools.

## Calendar Operating Rules

The production calendar now uses one shared table for feed and story rows with a Japanese-first review layer.

- Client-facing planning fields stay in Japanese: `投稿テーマ`, `切り口`, `補足メモ`
- Workflow fields stay stable for downstream skills: `Section`, `Format`, `Objective`, `Primary Persona`, `Workflow Status`
- Keep feed and story rows in one CSV with one header row
- When needed for Google Drive or client sharing, generate a matching `.xlsx` beside the CSV with `tools/export-csv-to-xlsx.ps1`

## Prompt Naming

Use date-based filenames so the execution skill can reliably match prompts from calendar-driven requests:

- Feed: `ig-feed-YYYY-MM-DD-theme-v01.json`
- Story: `ig-story-YYYY-MM-DD-theme-v01.json`

Examples:

- `ig-feed-2026-03-23-mitochondria-basics-v01.json`
- `ig-story-2026-03-23-mitochondria-basics-reinforcement-v01.json`
