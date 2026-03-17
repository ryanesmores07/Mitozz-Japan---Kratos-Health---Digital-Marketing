# Creative packages (mitozz-creatives-director output)

This folder holds **creative package** files produced by the `mitozz-creatives-director` skill.

- **Naming:** `creative-package-YYYY-MM-DD.md` (one file per date; one file can contain feed and story packages for that date).
- **Consumer:** `mitozz-prompt-engineer` reads from here to create JSON prompt files in `prompts/instagram/feed/` and `prompts/instagram/stories/`.

Pipeline: content calendar → creatives director (writes here) → prompt engineer (reads here) → nano-banana-instagram (executes prompts).
