import argparse
import asyncio
import json
import os
import sys
from pathlib import Path


def get_workspace_root() -> Path:
    return Path(__file__).resolve().parents[2]


def configure_stdout() -> None:
    if hasattr(sys.stdout, "reconfigure"):
        sys.stdout.reconfigure(encoding="utf-8", errors="replace")


def get_dependency_site_packages(workspace_root: Path) -> Path:
    archive_root = workspace_root / "mcp" / "uv-cache" / "archive-v0"
    candidates = sorted(
        archive_root.glob("*/Lib/site-packages/fastmcp/__init__.py"),
        key=lambda path: path.stat().st_mtime,
        reverse=True,
    )
    if not candidates:
        raise RuntimeError("No cached MCP dependency site-packages directory was found.")
    return candidates[0].parents[1]


def prepend_paths(paths: list[Path]) -> None:
    for path in reversed(paths):
        path_str = str(path)
        if path.exists() and path_str not in sys.path:
            sys.path.insert(0, path_str)


def load_local_config(workspace_root: Path) -> dict:
    config_path = workspace_root / "mcp" / "nanobanana.cursor.local.json"
    if not config_path.exists():
        raise RuntimeError(f"Local Nano Banana config is missing: {config_path}")
    return json.loads(config_path.read_text(encoding="utf-8-sig"))


def get_api_key(workspace_root: Path) -> str:
    env_value = os.environ.get("GEMINI_API_KEY", "").strip()
    if env_value:
        return env_value

    config = load_local_config(workspace_root)
    api_key = (
        config.get("mcpServers", {})
        .get("nanobanana", {})
        .get("env", {})
        .get("GEMINI_API_KEY", "")
        .strip()
    )
    if not api_key:
        raise RuntimeError("GEMINI_API_KEY is not configured for Nano Banana.")
    return api_key


def build_server_env(workspace_root: Path, site_packages: Path) -> dict[str, str]:
    repo_root = workspace_root / "tools" / "nanobanana-mcp-server"
    python_path_entries = [
        repo_root,
        site_packages,
        site_packages / "win32",
        site_packages / "win32" / "lib",
        site_packages / "pywin32_system32",
    ]

    env = dict(os.environ)
    env["GEMINI_API_KEY"] = get_api_key(workspace_root)
    env["NANOBANANA_MODEL"] = "nb2"
    env["FASTMCP_SHOW_SERVER_BANNER"] = "false"
    env["FASTMCP_LOG_ENABLED"] = "false"
    env["FASTMCP_LOG_LEVEL"] = "ERROR"
    env["FASTMCP_DEPRECATION_WARNINGS"] = "false"
    env["LOG_LEVEL"] = "ERROR"

    joined_paths = [str(path) for path in python_path_entries if path.exists()]
    if env.get("PYTHONPATH"):
        joined_paths.append(env["PYTHONPATH"])
    env["PYTHONPATH"] = os.pathsep.join(joined_paths)
    return env


def build_server_params(workspace_root: Path, env: dict[str, str]):
    from mcp.client.stdio import StdioServerParameters

    python_path = workspace_root / "mcp" / "uv-python" / "cpython-3.14.3-windows-x86_64-none" / "python.exe"
    repo_root = workspace_root / "tools" / "nanobanana-mcp-server"
    return StdioServerParameters(
        command=str(python_path),
        args=["-m", "nanobanana_mcp_server.server"],
        cwd=str(repo_root),
        env=env,
    )


def load_arguments(args: argparse.Namespace) -> dict | None:
    if args.arguments_json:
        return json.loads(args.arguments_json)
    if args.arguments_path:
        return json.loads(Path(args.arguments_path).read_text(encoding="utf-8"))
    return None


def simplify_call_result(result) -> dict:
    content = []
    for item in getattr(result, "content", []) or []:
        item_type = getattr(item, "type", None)
        payload = {"type": item_type}
        if item_type == "text":
            payload["text"] = getattr(item, "text", "")
        elif item_type == "image":
            payload["format"] = getattr(item, "mimeType", None) or getattr(item, "format", None)
        content.append(payload)

    return {
        "is_error": getattr(result, "isError", False),
        "structured_content": getattr(result, "structuredContent", None),
        "content": content,
    }


async def run() -> int:
    parser = argparse.ArgumentParser()
    parser.add_argument("--tool", required=True)
    parser.add_argument("--arguments-path")
    parser.add_argument("--arguments-json")
    args = parser.parse_args()
    configure_stdout()

    workspace_root = get_workspace_root()
    site_packages = get_dependency_site_packages(workspace_root)
    prepend_paths(
        [
            site_packages,
            site_packages / "win32",
            site_packages / "win32" / "lib",
            site_packages / "pywin32_system32",
        ]
    )

    from mcp.client.session import ClientSession
    from mcp.client.stdio import stdio_client

    server_env = build_server_env(workspace_root, site_packages)
    server_params = build_server_params(workspace_root, server_env)
    tool_args = load_arguments(args)

    async with stdio_client(server_params, errlog=sys.stderr) as (read_stream, write_stream):
        async with ClientSession(read_stream, write_stream) as session:
            await session.initialize()

            if args.tool == "list_tools":
                result = await session.list_tools()
                tools = []
                for tool in getattr(result, "tools", []) or []:
                    tools.append(
                        {
                            "name": getattr(tool, "name", ""),
                            "description": getattr(tool, "description", ""),
                        }
                    )
                print(json.dumps({"tools": tools}, ensure_ascii=False))
                return 0

            result = await session.call_tool(args.tool, tool_args or {})
            print(json.dumps(simplify_call_result(result), ensure_ascii=False))
            return 0


if __name__ == "__main__":
    raise SystemExit(asyncio.run(run()))
