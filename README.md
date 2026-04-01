Mitozz Japan
============

This workspace is organized for creating and maintaining reusable JSON prompts for Nano Banana, focused on Instagram organic marketing for Mitozz Japan.

It can also support adjacent frontend work when a campaign needs a landing page, article page, Shopify surface, or other branded UI extension.

Current model standard:

- Nano Banana 2 = `gemini-3.1-flash-image-preview`
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
- design system = final layout engine for text-led assets

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

This project is wired into Codex using eight project-local skills under `.agents/skills/`:

- `mitozz-content-calendar`: plans the monthly Mitozz Japan Instagram calendar
- `mitozz-creatives-director`: turns calendar rows into decisive creative packages and reel edit direction
- `mitozz-prompt-engineer`: converts creative packages into Nano Banana JSON prompts for source assets
- `nano-banana-instagram`: executes prompt files and generates the internal source assets
- `imagen`: generates or edits general-purpose project images when you want image creation without using Nano Banana
- `jay-invoice-sheets`: inspects, clones, and publishes Jay monthly salary and expense Google Sheets from the existing Drive references
- `retainer-reporting`: logs meaningful retainer work and turns monthly action logs into Jay-ready summaries
- `drive-delivery`: uploads approved production assets to the mapped Google Drive folders and writes delivery receipts

The repository treats `.agents/skills/` as the single source of truth for skill discovery and maintenance.

In addition to the project-local skills, this workspace can also make use of the external Codex skill at `C:\Users\esmoresernieryanocam\.codex\skills\frontend-skill\SKILL.md` as an optional art-direction layer when the task needs stronger composition, hierarchy, imagery, or motion thinking.

Use that frontend skill for:

- landing pages tied to Instagram campaigns
- Shopify or article surfaces that need stronger art direction
- branded microsites, demos, or UI prototypes
- frontend polish where hierarchy, imagery, restraint, and motion matter
- campaign-critical Instagram assets that need a stronger visual thesis before prompt writing
- reels, covers, thumbnails, and story sequences that feel compositionally weak in first-pass direction

Do not use it for:

- normal prompt JSON authoring
- routine creative-package writing
- Nano Banana generation tasks
- asset filing, approval, or delivery work
- replacing the Mitozz-specific creative decision flow by default

## Typical Flow

1. Use `mitozz-content-calendar` to create or revise the monthly calendar under `brand/references/business-context/content-planning/`.
2. Use `tools/prepare-content-calendar-month.ps1` when you want to scaffold the month locally and publish it once rows are present.
3. Publish that CSV to the shared Google Drive calendar folder with `tools/publish-content-calendar-to-drive.ps1` so Drive stays current while the repo keeps the working copy.
4. Use the post-calendar flow in `workflows/03-post-calendar-production-flow.md` to resolve the production layer from the approved row.
5. Use `mitozz-creatives-director` to turn selected calendar rows into creative packages under `brand/references/business-context/creative-packages/`.
6. If the asset is visually high-stakes or the first-pass direction feels weak, apply the frontend-skill lens to strengthen the visual thesis, hierarchy, composition, and motion logic before prompt writing.
7. Resolve the asset's `template_set` and `slide_blueprint` from the central mapping rules.
8. Use `mitozz-prompt-engineer` to create or update prompt JSON in `prompts/instagram/feed/` or `prompts/instagram/stories/`.
9. For text-led carousels or Stories, use `design-system/instagram/` so HTML/CSS controls typography, spacing, and final layout while Nano Banana generates image plates only.
10. Use `nano-banana-instagram` to execute Nano Banana MCP using those prompt files when AI generation is still needed.
11. Review the outputs, approve winners, and promote only the best assets into the visual reference pack when appropriate.
12. When delivery to Google Drive is needed, use `drive-delivery` to upload only the approved assets and create a delivery receipt.
13. When Instagram insights, screenshots, or exports are available, normalize them into the current monthly metrics snapshot under `brand/references/business-context/reporting/instagram-metrics/` and use that snapshot as the performance reference for future planning and creative decisions.
14. When meaningful Jay retainer work is completed, use `retainer-reporting` to add it to the current monthly action log before closing the task, even if the user did not explicitly ask for logging in that turn.
15. When a user prompt, request, review ask, or direction change materially shapes project work, capture that request context inside the same monthly log entry so month-end reporting reflects not only what was done, but what triggered it.

If a campaign expands into a real webpage or interface, or if an Instagram asset needs the frontend-skill lens, insert one extra step between creative direction and implementation:

1. write a visual thesis
2. write a content plan: hero, support, detail, final CTA
3. write an interaction thesis with 2 to 3 motion ideas
4. apply the frontend skill before building the page

For text-led Instagram assets, the same design-first logic now applies in a lighter form:

1. define the visual thesis and copy structure
2. decide whether the asset should be code-composited
3. if yes, build or reuse the HTML/CSS template in `design-system/instagram/`
4. generate only the required image slot assets
5. render the final export from the compositor instead of asking AI to redraw the whole card

When you want image generation in this workspace without going through the Nano Banana pipeline, use `imagen` instead. It saves selected finals into `output/imagegen/` by default.

For Jay's monthly salary and expense sheet workflow, use `jay-invoice-sheets` to inspect the existing invoice Google Sheets in Drive, copy the reference layout into a new month, and optionally write normalized invoice data into a helper tab.

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

The launcher defaults `NANOBANANA_MODEL` to `flash`, which the runtime patch aligns to:

- `gemini-3.1-flash-image-preview`

The launcher wraps:

- `uvx nanobanana-mcp-server`

The workspace launcher also patches the MCP runtime to keep the Flash tier aligned to:

- `gemini-3.1-flash-image-preview`

This gives the workspace a stable local entrypoint even if the MCP client configuration differs between tools.

## Calendar Operating Rules

The production calendar now uses one shared table for feed and story rows with a Japanese-first review layer.

- Client-facing planning fields stay in Japanese: `投稿テーマ`, `切り口`, `補足メモ`
- Workflow fields stay stable for downstream skills: `Section`, `Format`, `Objective`, `Primary Persona`, `Workflow Status`
- Add `Content Type` as the human-friendly scan column: `Main Feed` for feed rows and `Story Support` for story rows
- Keep feed and story rows in one CSV with one header row
- The default calendar workflow is now:
  - local CSV in `content-planning/` for the repo copy and downstream skill input
  - matching Google Sheet in Drive for client-facing review and easy link sharing
- Use `tools/prepare-content-calendar-month.ps1` to create the correctly named local month file and automatically publish it when the CSV has data rows
- Publish or refresh the Drive sheet with `tools/publish-content-calendar-to-drive.ps1`
- When needed for a local Excel snapshot, generate a matching `.xlsx` beside the CSV with `tools/export-csv-to-xlsx.ps1`

## Prompt Naming

Use date-based filenames so the execution skill can reliably match prompts from calendar-driven requests:

- Feed: `ig-feed-YYYY-MM-DD-theme-v01.json`
- Story: `ig-story-YYYY-MM-DD-theme-v01.json`

Examples:

- `ig-feed-2026-03-23-mitochondria-basics-v01.json`
- `ig-story-2026-03-23-mitochondria-basics-reinforcement-v01.json`
