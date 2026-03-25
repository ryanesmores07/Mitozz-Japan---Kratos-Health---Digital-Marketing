---
name: drive-delivery
description: Upload approved reel, story, feed, or caption deliverables to the mapped Google Drive folders using the Google Drive API. Use when the user asks to manually deliver approved production assets to Drive, verify delivery targets, initialize Google OAuth, or create a delivery receipt.
---

# Drive Delivery

Use this skill to manually upload approved production assets to the correct Google Drive destination with a delivery receipt.

## Read These First

1. `references/google-drive-api-setup.md`
2. `brand/references/business-context/reporting/google-drive-destination-map.json`
3. `brand/references/business-context/reporting/README.md`

## Safety Rules

- Manual only. Do not auto-upload after generation unless the user explicitly asks.
- Upload only approved or current assets, never exploratory rejects by default.
- For stories, prefer the `current/` subfolder when the project root includes both `current/` and `rejected/`.
- For reels and feed projects, prefer the `current/` subfolder when present.
- Create a delivery receipt after each upload run unless the user explicitly asks not to.

## Default Destination Mapping

- `stories` -> Story Drive root
- `reels` -> Feed Drive root
- `feed` -> Feed Drive root
- `captions` -> Captions Drive root

## Auth Model

Use the Google Drive API through a local OAuth desktop client plus a saved refresh token:

- OAuth client: `brand/references/business-context/reporting/google-drive-oauth-client.local.json`
- OAuth token: `brand/references/business-context/reporting/google-drive-oauth-token.local.json`

The first live run requires a one-time browser authorization step.

## Preferred Command

Use the bundled script:

- `pwsh -NoProfile -ExecutionPolicy Bypass -File .agents/skills/drive-delivery/scripts/upload-approved-assets-to-drive.ps1`

Important parameters:

- `-AssetType stories|reels|feed|captions`
- `-SourcePath <local file or folder>`
- `-ProjectName <optional remote subfolder name>`
- `-DryRun` for a no-upload verification pass
- `-InitializeOAuth` to start or complete the one-time OAuth setup

## Expected Behavior

1. Resolve the correct Drive root from the destination map.
2. Resolve approved local files conservatively.
3. Create or reuse a project folder under the Drive root.
4. Upload files, replacing same-name files in that project folder when needed.
5. Write a delivery receipt under `brand/references/business-context/reporting/delivery-receipts/`.

## When Reporting Matters

If the upload represents a meaningful delivery milestone under the retainer, add a concise entry to the current monthly retainer action log.
