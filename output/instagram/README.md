# Instagram Output Structure

This folder holds generated and approved Instagram production assets used across feed, reels, and stories.

## Folder Rules

- `feed/`: approved feed assets and feed project folders
- `reels/`: reel source-frame projects
- `stories/`: story-set projects
- `templates/`: reusable template explorations, approved template winners, and human-browsable current template aliases

Inside each project folder, use this structure when applicable:

- `current/`: the approved assets to use for delivery, editing, or Drive upload
- `rejected/`: rejected variants and rejection notes
- `archive/`: older approved versions, exploratory keeps, or source byproducts worth keeping for traceability

This is the canonical live structure going forward.
Do not flatten approved winner files back into the project root when a `current/` folder exists.

For reel projects, prefer this optional archive split when helpful:

- `archive/source-motion/`: approved or kept motion-reference videos used to guide edit direction or future reel production
- `archive/source-frames/`: older source-frame sets or superseded approved stills worth retaining

## Naming Rules

- Keep project folders date-first: `YYYY-MM-DD-theme-name`
- Keep approved files human-readable and order-stable
- For reels, prefer shot-based names like `shot-01-opening-hook.png`
- For reel motion references, prefer role-based names like `source-motion-reference-v01.mp4`
- For stories, prefer ordered names like `frame-01.png`
- Do not leave approved finals mixed beside rejected or archived files at the project root if a `current/` folder exists

Practical rule:

- handoff docs should point at `current/` for live assets
- delivery tooling should resolve `current/` first
- the project root should mainly hold the structure folders, not duplicate winner files

## Delivery Rule

The Google Drive delivery workflow prefers `current/` when present. If you want a file set to be uploaded or handed off, it should live inside `current/`.
