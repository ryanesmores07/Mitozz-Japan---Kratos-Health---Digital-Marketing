# Google Drive API Setup

## Goal

This skill uses Google OAuth for a desktop app to upload approved assets into the correct Drive folders.

## Local OAuth Files

Store the OAuth client JSON locally at:

- `brand/references/business-context/reporting/google-drive-oauth-client.local.json`

After authorization, the workspace will also save:

- `brand/references/business-context/reporting/google-drive-oauth-token.local.json`

These files are local-only and ignored by Git.

## Required Setup

1. Create or choose a Google Cloud project with the Drive API enabled.
2. Create an OAuth client ID for a Desktop app.
3. Save the OAuth client JSON at the local client path above.
4. Run the uploader with `-InitializeOAuth` to get the authorization URL.
5. Sign in with the Google account that has access to the destination folders.
6. Complete the OAuth callback step so the local token file is created.

## Why Account Access Matters

The signed-in Google account must have access to the destination Drive folders or uploads will fail with permission errors.

## Destination Roots

- Story Drive root: `1S_HZfF5Wi9xlrdjPBE1SUzgWs6tI2Ymf`
- Feed Drive root: `14WWdQUIQm4Afv_tlm_Xbmhoegv2DYr9H`
- Captions Drive root: `1BtCmQHl2ovnLASs8DiXM_DOE-CReKccu`

## Safe First Workflow

1. Run the upload script with `-DryRun`.
2. Confirm the local files and remote destination folder are correct.
3. Run the script with `-InitializeOAuth` and complete the one-time sign-in flow.
4. Run again without `-DryRun`.
5. Check the delivery receipt created in the workspace.

`-DryRun` works without credentials. Actual uploads require the local OAuth client file and a completed local token setup.
