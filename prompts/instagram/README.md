# Instagram Prompt Folder

This folder is the working prompt library for active Mitozz Instagram production.

Keep it lean.

## Structure

- `feed/` holds active feed, carousel, and reel-shot source prompts
- `stories/` holds active story prompts
- `profile/` holds rare profile-specific reference prompts unless a profile refresh is actively underway
- `shared/` holds the reusable system template and shared locks

## Keep Rules

Keep a prompt here if at least one of these is true:

- it is part of the current production batch
- it is referenced by an active workflow or index doc
- it is a reusable template-set anchor
- it is the current approved version for a live asset
- it is the current reusable reference prompt for a low-frequency area such as profile work

Remove or archive a prompt if all of these are true:

- it is no longer on the active calendar
- it has no live output path tied to it
- it is not referenced by an active workflow or index doc
- it is not serving as a reusable template example

## Naming Rules

- feed: `ig-feed-YYYY-MM-DD-theme-v01.json`
- story: `ig-story-YYYY-MM-DD-theme-v01.json`
- reel shot source: `ig-feed-reel-YYYY-MM-DD-theme-shot-01-v01.json`
- profile: `ig-profile-YYYY-MM-DD-theme-v01.json`

## Working Rule

When a prompt is replaced, keep only the active winner in this folder unless the older file is still required as a documented template example.
