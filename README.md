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

## Template Automation

The calendar stays strategy-focused. Template assignment is resolved automatically from existing calendar fields through:

- `brand/references/business-context/visual/template-mapping-rules.json`
- `brand/references/business-context/visual/Mitozz Template Library Index.md`
- `tools/resolve-template-mapping.py`
- `tools/resolve-template-mapping.ps1` for Windows / PowerShell use

This keeps the grid consistent while avoiding extra production columns in the planning calendar.

The recommended operating split is:

- calendar = strategy
- mapping layer = template and structure
- creative package = art direction
- prompt = execution input

See:

- `workflows/03-post-calendar-production-flow.md`

Quick examples:

- Mac / zsh: `python3 tools/resolve-template-mapping.py --csv "brand/references/business-context/content-planning/Mitozz Instagram Content Calendar - 2026 - March.csv" --row 1 --pretty`
- Windows / PowerShell: `pwsh -NoProfile -File tools/resolve-template-mapping.ps1 --csv "brand/references/business-context/content-planning/Mitozz Instagram Content Calendar - 2026 - March.csv" --row 1 --pretty`

## Encoding Rules

This workspace should be treated as UTF-8 by default.

- All calendars, creative packages, prompts, workflows, and skill docs should be saved as UTF-8
- Japanese content is expected in planning and copy fields, so avoid ANSI or Shift-JIS saves for shared project files
- `.editorconfig` defines UTF-8 as the workspace default
- `tools/normalize-workspace-utf8.ps1` can be used to normalize key workflow files back to UTF-8 if needed

## Skills And Workflow

This project is wired into Codex using four project-local skills under `.agents/skills/`:

- `mitozz-content-calendar`: plans the monthly Mitozz Japan Instagram calendar
- `mitozz-creatives-director`: turns calendar rows into decisive creative packages and reel edit direction
- `mitozz-prompt-engineer`: converts creative packages into Nano Banana JSON prompts for source assets
- `nano-banana-instagram`: executes prompt files and generates the internal source assets

The repository treats `.agents/skills/` as the single source of truth for skill discovery and maintenance.

## Typical Flow

1. Use `mitozz-content-calendar` to create or revise the monthly calendar under `brand/references/business-context/content-planning/`.
2. Use the post-calendar flow in `workflows/03-post-calendar-production-flow.md` to resolve the production layer from the approved row.
3. Use `mitozz-creatives-director` to turn selected calendar rows into creative packages under `brand/references/business-context/creative-packages/`.
4. Resolve the asset's `template_set` and `slide_blueprint` from the central mapping rules.
5. Use `mitozz-prompt-engineer` to create or update prompt JSON in `prompts/instagram/feed/` or `prompts/instagram/stories/`.
6. Use `nano-banana-instagram` to execute Nano Banana Pro MCP using those prompt files.
7. Review the outputs, approve winners, and promote only the best assets into the visual reference pack when appropriate.

For zero-follower or near-zero-follower periods, use:

- `brand/references/business-context/content-planning/Mitozz Launch Phase Posting Strategy.md`

This keeps Stories in a support role while Reels and save-worthy carousels do the heavier growth work.

For Reels, the flow is now:

1. Build the Reel creative package from `brand/references/business-context/creative-packages/reel-creative-package-template.md`.
2. Create source images or collect source clips internally.
3. If generated images are needed, create one coordinated prompt JSON per required source asset.
4. If a still frame must become a motion clip, create a platform-agnostic motion prompt with `workflows/05-image-to-video-prompt-template.md`.
5. Assemble a freelancer-ready edit packet with `workflows/04-freelancer-reel-handoff-template.md` and save the filled handoff file under `brand/references/business-context/creative-packages/` when needed.
6. Send the packet and source assets to the freelancer.
7. Review the draft, request targeted revisions, and approve the final Reel cut.

Runtime standard for reels:

- hard maximum: `60 seconds`
- default target: `8-15 seconds`
- shorter is preferred unless the concept clearly earns more time
- the first `1-2 seconds` must always carry the hook

For free rehearsal runs, use `tools/chatgpt-image-test-run.ps1` to turn an existing prompt JSON into a dry-run ChatGPT image-generation bundle without calling a paid API.

Use the checklists in `workflows/` to keep planning, creative packaging, generation, and approval lean and repeatable.

For reel source-frame batches, use the hard-lock preflight before generation:

- `workflows/03A-reel-preflight-and-hard-locks.md`
- `powershell -NoProfile -ExecutionPolicy Bypass -File tools/validate-reel-prompt-batch.ps1 "prompts/instagram/feed/ig-feed-reel-YYYY-MM-DD-theme-shot-*-v01.json"`
- optional fallback: `python tools/validate-reel-prompt-batch.py "prompts/instagram/feed/ig-feed-reel-YYYY-MM-DD-theme-shot-*-v01.json"`

## Local Nano Banana MCP

This workspace now includes a repo-local launcher for the published Nano Banana MCP server:

- launcher: `tools/run-nanobanana-mcp.ps1`
- project MCP config: `.codex/config.toml`
- Cursor example config: `mcp/nanobanana.cursor.example.json`

Recommended setup:

1. Set `GEMINI_API_KEY` in your local environment or IDE secret store.
2. Keep your local secret file at `mcp/nanobanana.cursor.local.json`.
3. Open the repo in Codex so the project-local `.codex/config.toml` can register the MCP server with the correct `cwd` and longer startup timeout.
4. Do not commit real API keys into repo config files.

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
