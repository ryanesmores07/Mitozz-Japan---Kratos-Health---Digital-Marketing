# Codex MCP Setup

This workspace uses Codex MCP, not Cursor MCP, as the active integration path.

## What Lives In Repo

- `tools/run-nanobanana-mcp.ps1`
- `tools/patch-nanobanana-runtime.ps1`
- `.codex/config.toml`
- `mcp/nanobanana.cursor.example.json` as a legacy/example reference only

## What Does Not Live In Repo

- your real Gemini API key
- your local Codex global config
- local uv caches or Python runtime folders

These are intentionally excluded by `.gitignore`.

## Desktop / Windows Setup

1. Create or keep your local secret file:
   - `mcp/nanobanana.cursor.local.json`
2. Put your real `GEMINI_API_KEY` in that local file.
3. Keep `NANOBANANA_MODEL` set to `flash`.
   In this workspace, the `flash` tier is patched to `gemini-3.1-flash-lite-preview`.
   If omitted, the repo launcher now defaults it to `flash` automatically.
4. Open the repo in Codex. This workspace now includes a project-local MCP config at:
   - `.codex/config.toml`
5. Ensure `pwsh` is installed and available on PATH.
6. If you prefer a global fallback, the equivalent entry in `~/.codex/config.toml` is:

```toml
[mcp_servers.nanobanana]
command = "pwsh"
args = ["-NoProfile", "-ExecutionPolicy", "Bypass", "-File", "tools/run-nanobanana-mcp.ps1"]
cwd = "C:\\Users\\YOUR_USER\\path\\to\\repo"
startup_timeout_sec = 45
tool_timeout_sec = 120
```

7. Restart Codex after changing config or pulling repo updates.

## Mac Setup

After pulling the repo on Mac:

1. Create a local secret file for that machine.
   Recommended path:
   - `mcp/nanobanana.cursor.local.json`

2. Use this shape:

```json
{
  "mcpServers": {
    "nanobanana": {
      "env": {
        "GEMINI_API_KEY": "YOUR_REAL_KEY",
        "NANOBANANA_MODEL": "flash"
      }
    }
  }
}
```

3. Add a Codex MCP entry to `~/.codex/config.toml` on the Mac.
   If `NANOBANANA_MODEL` is omitted from the local JSON, the repo launcher will still default to `flash`.

If you keep the same repo structure, it should look like:

```toml
[mcp_servers.nanobanana]
command = "pwsh"
args = ["-NoProfile", "-ExecutionPolicy", "Bypass", "-File", "tools/run-nanobanana-mcp.ps1"]
cwd = "/Users/YOUR_USER/path/to/repo"
startup_timeout_sec = 45
tool_timeout_sec = 120
```

4. If you open the repo directly in Codex, the project-local `.codex/config.toml` should already cover this setup.
5. Restart Codex after changing config or pulling repo updates.

## Model Standard

This project standard is:

- Nano Banana
- `gemini-3.1-flash-lite-preview`
- default tier: `flash`

The launcher enforces the runtime alignment automatically.

## Verification

After restart, Codex should be able to see the `nanobanana` MCP server.

Expected signs:

- MCP resources are available from `nanobanana`
- server startup resolves to `gemini-3.1-flash-lite-preview`

## Notes

- `mcp/nanobanana.cursor.local.json` is local-only and ignored by Git.
- `mcp/uv-cache/`, `mcp/uv-python/`, and `mcp/xdg-data/` are also local-only.
- Pulling the repo onto another machine does not transfer secrets or Codex global config.
- Official Codex MCP docs support `command`, `args`, `env`, `cwd`, `startup_timeout_sec`, and `tool_timeout_sec` for STDIO servers. We use `cwd` plus a longer startup timeout here because the Nano Banana server may need more than the default 10 seconds to handshake on first start.
