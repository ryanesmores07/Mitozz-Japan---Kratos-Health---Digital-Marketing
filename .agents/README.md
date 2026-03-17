# Codex Agent Skills

This repository includes Codex-native skills under `.agents/skills`.

Codex scans `.agents/skills` from the current working directory upward and uses each skill folder's `SKILL.md` as the primary entrypoint.

Optional Codex skill helpers can also live beside `SKILL.md`, including:

- `references/`
- `scripts/`
- `assets/`
- `agents/openai.yaml`

This repository treats `.agents/skills` as the single source of truth for repository skills.
