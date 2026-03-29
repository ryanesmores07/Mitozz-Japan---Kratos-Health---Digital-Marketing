#!/usr/bin/env python3
from __future__ import annotations

import argparse
from pathlib import Path

from PIL import Image, ImageChops, ImageFilter, ImageOps


def build_mask(image: Image.Image) -> Image.Image:
    rgba = image.convert("RGBA")
    bg = Image.new("RGBA", rgba.size, rgba.getpixel((0, 0)))
    diff = ImageChops.difference(rgba, bg).convert("L")
    diff = ImageOps.autocontrast(diff)
    diff = diff.point(lambda p: 255 if p > 22 else 0)
    diff = diff.filter(ImageFilter.GaussianBlur(1.2))
    diff = diff.point(lambda p: int(max(0, min(255, (p - 18) * 1.35))))
    return diff


def crop_to_subject(image: Image.Image, mask: Image.Image) -> tuple[Image.Image, Image.Image]:
    bbox = mask.getbbox()
    if not bbox:
        raise RuntimeError("Could not isolate bottle from reference image.")
    return image.crop(bbox), mask.crop(bbox)


def add_shadow(mask: Image.Image, size: tuple[int, int], offset: tuple[int, int]) -> Image.Image:
    shadow = Image.new("L", size, 0)
    shadow_mask = mask.resize(size, Image.Resampling.LANCZOS).filter(ImageFilter.GaussianBlur(10))
    x_off, y_off = offset
    shadow.paste(shadow_mask, (x_off, y_off))
    shadow = shadow.filter(ImageFilter.GaussianBlur(10))
    shadow = shadow.point(lambda p: int(p * 0.32))
    return shadow


def main() -> None:
    parser = argparse.ArgumentParser()
    parser.add_argument("--scene", required=True)
    parser.add_argument("--bottle", required=True)
    parser.add_argument("--output", required=True)
    parser.add_argument("--x", type=int, required=True)
    parser.add_argument("--y", type=int, required=True)
    parser.add_argument("--width", type=int, required=True)
    parser.add_argument("--height", type=int, required=True)
    parser.add_argument("--shadow-x", type=int, default=8)
    parser.add_argument("--shadow-y", type=int, default=18)
    args = parser.parse_args()

    scene = Image.open(args.scene).convert("RGBA")
    bottle_src = Image.open(args.bottle).convert("RGBA")

    mask = build_mask(bottle_src)
    bottle_crop, mask_crop = crop_to_subject(bottle_src, mask)

    bottle_resized = bottle_crop.resize((args.width, args.height), Image.Resampling.LANCZOS)
    mask_resized = mask_crop.resize((args.width, args.height), Image.Resampling.LANCZOS)
    bottle_resized.putalpha(mask_resized)

    out = scene.copy()

    shadow = add_shadow(mask_crop, (args.width, args.height), (0, 0))
    shadow_rgba = Image.new("RGBA", (args.width, args.height), (0, 0, 0, 0))
    shadow_rgba.putalpha(shadow)
    out.alpha_composite(shadow_rgba, (args.x + args.shadow_x, args.y + args.shadow_y))
    out.alpha_composite(bottle_resized, (args.x, args.y))

    Path(args.output).parent.mkdir(parents=True, exist_ok=True)
    out.save(args.output)


if __name__ == "__main__":
    main()
