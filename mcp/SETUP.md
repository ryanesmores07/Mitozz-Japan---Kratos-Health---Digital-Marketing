# Codex MCP Setup

This workspace uses Codex MCP, not Cursor MCP, as the active integration path.

## What Lives In Repo

- `tools/run-nanobanana-mcp.ps1`
- `tools/patch-nanobanana-runtime.ps1`
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
4. Ensure Codex global config has this entry in `~/.codex/config.toml`:

```toml
[mcp_servers.nanobanana]
command = "powershell"
args = ["-NoProfile", "-ExecutionPolicy", "Bypass", "-File", "C:\\Users\\YOUR_USER\\path\\to\\repo\\tools\\run-nanobanana-mcp.ps1"]
```

5. Restart Codex after changing the global config.

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

If you keep the same repo structure, it should look like:

```toml
[mcp_servers.nanobanana]
command = "pwsh"
args = ["-NoProfile", "-ExecutionPolicy", "Bypass", "-File", "/Users/YOUR_USER/path/to/repo/tools/run-nanobanana-mcp.ps1"]
```

4. Restart Codex.

## Model Standard

This project standard is:

- Nano Banana Pro 2
- `gemini-3.1-flash-image-preview`
- default tier: `flash`

The launcher enforces the runtime alignment automatically.

## Verification

After restart, Codex should be able to see the `nanobanana` MCP server.

Expected signs:

- MCP resources are available from `nanobanana`
- server startup resolves to `gemini-3.1-flash-image-preview`

## Notes

- `mcp/nanobanana.cursor.local.json` is local-only and ignored by Git.
- `mcp/uv-cache/`, `mcp/uv-python/`, and `mcp/xdg-data/` are also local-only.
- Pulling the repo onto another machine does not transfer secrets or Codex global config.
