import argparse
import json
import os
import sys
from pathlib import Path


def add_cached_site_packages(workspace_root: Path) -> None:
    archive_root = workspace_root / "mcp" / "uv-cache" / "archive-v0"
    candidates = sorted(
        archive_root.glob("*/Lib/site-packages/nanobanana_mcp_server/server.py"),
        key=lambda path: path.stat().st_mtime,
        reverse=True,
    )

    if not candidates:
        raise RuntimeError("No cached Nano Banana site-packages install was found.")

    site_packages = candidates[0].parents[1]
    extras = [
        site_packages,
        site_packages / "win32",
        site_packages / "win32" / "lib",
        site_packages / "pywin32_system32",
    ]

    for entry in reversed(extras):
        entry_str = str(entry)
        if entry.exists() and entry_str not in sys.path:
            sys.path.insert(0, entry_str)


def get_api_key(workspace_root: Path) -> str:
    existing = os.environ.get("GEMINI_API_KEY", "").strip()
    if existing:
        return existing

    config_path = workspace_root / "mcp" / "nanobanana.cursor.local.json"
    if not config_path.exists():
        raise RuntimeError("GEMINI_API_KEY is not set and local Nano Banana config is missing.")

    config = json.loads(config_path.read_text(encoding="utf-8-sig"))
    key = (
        config.get("mcpServers", {})
        .get("nanobanana", {})
        .get("env", {})
        .get("GEMINI_API_KEY", "")
        .strip()
    )
    if not key:
        raise RuntimeError("GEMINI_API_KEY is missing from the local Nano Banana config.")
    return key


def resolve_model_name(model_tier: str) -> str:
    normalized = (model_tier or "nb2").strip().lower()
    if normalized in {"nb2", "flash", "auto"}:
        return "gemini-3.1-flash-image-preview"
    if normalized == "pro":
        return "gemini-3-pro-image-preview"
    return normalized


def resolve_image_size(resolution: str | None) -> str:
    mapping = {
        "1k": "1K",
        "2k": "2K",
        "4k": "4K",
        "high": "1K",
    }
    return mapping.get((resolution or "1k").strip().lower(), "1K")


def build_contents(request: dict) -> list:
    contents: list = []
    system_instruction = (request.get("system_instruction") or "").strip()
    if system_instruction:
        contents.append(system_instruction)

    prompt = (request.get("prompt") or "").strip()
    if not prompt:
        raise RuntimeError("Request is missing a prompt.")

    negative_prompt = (request.get("negative_prompt") or "").strip()
    if negative_prompt:
        prompt = f"{prompt}\n\nAvoid: {negative_prompt}"

    contents.append(prompt)
    return contents


def extract_first_image_bytes(response) -> bytes:
    candidates = getattr(response, "candidates", None) or []
    for candidate in candidates:
        content = getattr(candidate, "content", None)
        if content is None:
            continue
        for part in getattr(content, "parts", []) or []:
            inline_data = getattr(part, "inline_data", None)
            if inline_data is not None and getattr(inline_data, "data", None):
                return inline_data.data
    raise RuntimeError("The Nano Banana response did not include any image bytes.")


def main() -> int:
    parser = argparse.ArgumentParser()
    parser.add_argument("--request", required=True)
    args = parser.parse_args()

    workspace_root = Path(__file__).resolve().parents[2]
    request_path = Path(args.request).resolve()
    if not request_path.exists():
        raise RuntimeError(f"Request file not found: {request_path}")

    add_cached_site_packages(workspace_root)

    from google import genai
    from google.genai import types as gx

    request = json.loads(request_path.read_text(encoding="utf-8"))
    output_path = Path(request.get("output_path", "")).resolve()
    if not output_path:
        raise RuntimeError("Request is missing output_path.")

    output_path.parent.mkdir(parents=True, exist_ok=True)

    model_name = resolve_model_name(request.get("model_tier", "nb2"))
    image_size = resolve_image_size(request.get("resolution"))
    aspect_ratio = (request.get("aspect_ratio") or "").strip() or None
    api_key = get_api_key(workspace_root)

    client = genai.Client(api_key=api_key)

    config_kwargs = {
        "response_modalities": ["TEXT", "IMAGE"],
        "image_config": gx.ImageConfig(image_size=image_size, aspect_ratio=aspect_ratio),
    }
    response = client.models.generate_content(
        model=model_name,
        contents=build_contents(request),
        config=gx.GenerateContentConfig(**config_kwargs),
    )

    image_bytes = extract_first_image_bytes(response)
    output_path.write_bytes(image_bytes)

    result = {
        "output_path": str(output_path),
        "model_name": model_name,
        "image_size": image_size,
        "aspect_ratio": aspect_ratio,
        "bytes": len(image_bytes),
    }
    print(json.dumps(result, ensure_ascii=False))
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
