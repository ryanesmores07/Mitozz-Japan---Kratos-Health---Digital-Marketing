# Creative packages (mitozz-creatives-director output)

This folder holds **creative package** files produced by the `mitozz-creatives-director` skill.

- **Naming:** `creative-package-YYYY-MM-DD.md` (one file per date; one file can contain feed and story packages for that date).
- **Consumer:** `mitozz-prompt-engineer` reads from here to create JSON prompt files in `prompts/instagram/feed/` and `prompts/instagram/stories/`.

Pipeline: content calendar → creatives director (writes here) → prompt engineer (reads here) → nano-banana-instagram (executes prompts).
Creative packages live here.

Recommended starting points:

- Use `START-HERE-MARCH-23.md` when beginning the first locked production run for the approved March 23 assets.
- Use `creative-package-YYYY-MM-DD.md` for normal feed and story assets.
- Use `reel-creative-package-template.md` when the calendar row format is `Reel`.
- Use `workflows/04-freelancer-reel-handoff-template.md` to build the freelancer-ready reel edit packet after source frames are approved.
- Save filled reel handoff packets here as `reel-freelancer-handoff-YYYY-MM-DD.md`.
- Use `workflows/05-image-to-video-prompt-template.md` only when an approved still image must become a motion source clip before the freelancer handoff.
- Use `production-batch-YYYY-MM-DD-to-YYYY-MM-DD.md` when you want one control file that maps a calendar window to template sets, approved references, and execution status.
- Use `post-calendar-layer-YYYY-MM-DD-to-YYYY-MM-DD.md` when you want a lean handoff file that resolves the downstream production layer without adding more columns to the calendar.
- Use `story-posting-actions-YYYY-MM-DD-to-YYYY-MM-DD.md` when you want exact sticker, link, and CTA instructions for story posting without having to decide manually.
