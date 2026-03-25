---
name: jay-invoice-sheets
description: Create or update Jay monthly salary and expense Google Sheets using the existing invoice files in the mapped Drive folder as the formatting reference. Use when the user asks to prepare, inspect, clone, or publish the monthly compensation or expense sheet for Jay.
---

# Jay Invoice Sheets

Use this skill to manage the monthly Google Sheet sent to Jay for salary and reimbursable expenses.

This workflow is designed to:

- inspect the current invoice sheets stored in the shared Google Drive folder
- reuse the latest or selected invoice sheet as the reference layout
- create the new month by copying that reference sheet in Drive
- optionally write a normalized Codex data tab into the copied spreadsheet

## Read These First

1. `brand/references/business-context/reporting/README.md`
2. `brand/references/business-context/reporting/google-drive-destination-map.json`
3. `brand/references/business-context/reporting/templates/jay-monthly-invoice-data-template.json`
4. `tools/publish-jay-invoice-sheet-to-drive.ps1`

## Auth Model

Use the same local Google OAuth files already used by the workspace Drive tools:

- `brand/references/business-context/reporting/google-drive-oauth-client.local.json`
- `brand/references/business-context/reporting/google-drive-oauth-token.local.json`

## Default Drive Target

The default Jay invoice folder is resolved from:

- `brand/references/business-context/reporting/google-drive-destination-map.json`

## Preferred Commands

Inspect the available reference spreadsheets:

- `pwsh -NoProfile -ExecutionPolicy Bypass -File tools/publish-jay-invoice-sheet-to-drive.ps1 -InspectReferences`

Create the new month by copying the latest reference sheet:

- `pwsh -NoProfile -ExecutionPolicy Bypass -File tools/publish-jay-invoice-sheet-to-drive.ps1 -Month YYYY-MM`

Create the new month and attach normalized salary and expense data from a local JSON file:

- `pwsh -NoProfile -ExecutionPolicy Bypass -File tools/publish-jay-invoice-sheet-to-drive.ps1 -Month YYYY-MM -InvoiceDataPath brand/references/business-context/reporting/current-jay-invoice.json`

Initialize OAuth if the local token is missing:

- `pwsh -NoProfile -ExecutionPolicy Bypass -File tools/publish-jay-invoice-sheet-to-drive.ps1 -InitializeOAuth`

## Safety Rules

- Treat the existing invoice sheets in Drive as the layout source of truth.
- Prefer copying a proven reference sheet over rebuilding formatting from scratch.
- Do not overwrite an existing monthly spreadsheet unless the user explicitly asks.
- Keep any Codex-written data in a clearly labeled helper tab unless the user asks for direct cell mapping into the reference layout.
- Use `-InspectReferences` or `-PreviewReferenceLayout` before changing mapping logic when the reference format is unclear.

## Expected Behavior

1. Resolve the Jay invoice Drive folder.
2. Authenticate with the existing local OAuth flow.
3. List or inspect existing invoice spreadsheets in that folder.
4. Choose a reference spreadsheet by explicit ID or most recent modified date.
5. Copy the reference spreadsheet for the requested month.
6. Optionally write normalized salary and expense data into a helper tab for the new month.
7. Return the spreadsheet ID and Drive link.

## Notes

- This first version focuses on reliable reference discovery and month creation.
- Direct mapping into the legacy invoice cells can be tightened after we inspect the real reference layout.
