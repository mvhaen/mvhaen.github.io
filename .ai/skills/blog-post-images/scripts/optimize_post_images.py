#!/usr/bin/env python3
"""Optimize article images in a portable way.

This script favors cross-platform backends when available:
1. Pillow
2. ImageMagick
3. sips (macOS)
"""

from __future__ import annotations

import argparse
import platform
import shutil
import subprocess
import sys
import tempfile
from pathlib import Path


JPEG_EXTS = {".jpg", ".jpeg"}


def has_command(name: str) -> bool:
    return shutil.which(name) is not None


def detect_backend() -> str | None:
    try:
        import PIL  # noqa: F401

        return "pillow"
    except Exception:
        pass

    if has_command("magick"):
        return "magick"
    if has_command("convert"):
        return "convert"
    if platform.system() == "Darwin" and has_command("sips"):
        return "sips"
    return None


def sips_alpha(path: Path) -> bool | None:
    proc = subprocess.run(
        ["sips", "-g", "hasAlpha", str(path)],
        capture_output=True,
        text=True,
        check=False,
    )
    if proc.returncode != 0:
        return None
    for line in proc.stdout.splitlines():
        if "hasAlpha:" in line:
            value = line.split(":", 1)[1].strip().lower()
            if value == "yes":
                return True
            if value == "no":
                return False
    return None


def choose_target_format(path: Path, backend: str, target_format: str) -> str:
    if target_format != "auto":
        return "jpeg" if target_format == "jpg" else target_format

    ext = path.suffix.lower()
    if ext in JPEG_EXTS:
        return "jpeg"
    if ext == ".png":
        if backend == "sips":
            has_alpha = sips_alpha(path)
            if has_alpha is False:
                return "jpeg"
        return "png"
    return "jpeg"


def output_extension(fmt: str) -> str:
    if fmt == "jpeg":
        return ".jpg"
    return f".{fmt}"


def build_output_path(path: Path, fmt: str, output_dir: Path | None, replace: bool) -> Path:
    ext = output_extension(fmt)
    if output_dir:
        return output_dir / f"{path.stem}{ext}"
    if replace:
        return path.with_suffix(ext)
    raise ValueError("use --replace or --output-dir")


def ensure_parent(path: Path) -> None:
    path.parent.mkdir(parents=True, exist_ok=True)


def optimize_with_pillow(src: Path, dst: Path, fmt: str, quality: int, max_dimension: int) -> None:
    from PIL import Image, ImageOps

    image = Image.open(src)
    image = ImageOps.exif_transpose(image)
    image.thumbnail((max_dimension, max_dimension))

    save_kwargs: dict[str, object] = {}
    if fmt == "jpeg":
        if image.mode in ("RGBA", "LA") or (image.mode == "P" and "transparency" in image.info):
            background = Image.new("RGB", image.size, "white")
            alpha = image.convert("RGBA")
            background.paste(alpha, mask=alpha.getchannel("A"))
            image = background
        else:
            image = image.convert("RGB")
        save_kwargs.update({"quality": quality, "optimize": True, "progressive": True})
    elif fmt == "png":
        save_kwargs.update({"optimize": True})

    image.save(dst, format="JPEG" if fmt == "jpeg" else fmt.upper(), **save_kwargs)


def optimize_with_magick(src: Path, dst: Path, fmt: str, quality: int, max_dimension: int, command: str) -> None:
    resize = f"{max_dimension}x{max_dimension}>"
    cmd = [command, str(src), "-auto-orient", "-resize", resize]
    if fmt == "jpeg":
        cmd += ["-background", "white", "-alpha", "remove", "-alpha", "off", "-strip", "-quality", str(quality)]
    elif fmt == "png":
        cmd += ["-strip"]
    cmd.append(str(dst))
    subprocess.run(cmd, check=True)


def optimize_with_sips(src: Path, dst: Path, fmt: str, quality: int, max_dimension: int) -> None:
    cmd = ["sips", "-Z", str(max_dimension)]
    if fmt == "jpeg":
        cmd += ["-s", "format", "jpeg", "-s", "formatOptions", str(quality)]
    elif fmt == "png":
        cmd += ["-s", "format", "png"]
    cmd += [str(src), "--out", str(dst)]
    subprocess.run(cmd, check=True, capture_output=True, text=True)


def optimize_file(src: Path, dst: Path, backend: str, fmt: str, quality: int, max_dimension: int) -> None:
    ensure_parent(dst)
    if backend == "pillow":
        optimize_with_pillow(src, dst, fmt, quality, max_dimension)
        return
    if backend == "magick":
        optimize_with_magick(src, dst, fmt, quality, max_dimension, "magick")
        return
    if backend == "convert":
        optimize_with_magick(src, dst, fmt, quality, max_dimension, "convert")
        return
    if backend == "sips":
        optimize_with_sips(src, dst, fmt, quality, max_dimension)
        return
    raise RuntimeError(f"unsupported backend: {backend}")


def safe_replace(
    src: Path,
    final_path: Path,
    backend: str,
    fmt: str,
    quality: int,
    max_dimension: int,
    replace: bool,
) -> tuple[bool, int]:
    ensure_parent(final_path)
    before_size = src.stat().st_size
    with tempfile.TemporaryDirectory(prefix="optimize-post-images-") as tmpdir:
        temp_out = Path(tmpdir) / final_path.name
        optimize_file(src, temp_out, backend, fmt, quality, max_dimension)
        after_size = temp_out.stat().st_size

        if replace and after_size >= before_size:
            return False, after_size

        if final_path != src and src.exists():
            try:
                src.unlink()
            except FileNotFoundError:
                pass
        shutil.move(str(temp_out), str(final_path))
        return True, after_size


def main() -> int:
    parser = argparse.ArgumentParser(description="Optimize blog post images.")
    parser.add_argument("paths", nargs="+", help="input image paths")
    parser.add_argument("--replace", action="store_true", help="replace source files in place")
    parser.add_argument("--output-dir", help="write optimized files to this directory")
    parser.add_argument("--max-dimension", type=int, default=1600, help="maximum width or height")
    parser.add_argument("--quality", type=int, default=82, help="JPEG quality 1-100")
    parser.add_argument(
        "--target-format",
        choices=["auto", "jpeg", "jpg", "png"],
        default="auto",
        help="output format",
    )
    args = parser.parse_args()

    if not args.replace and not args.output_dir:
        parser.error("use --replace or --output-dir")

    backend = detect_backend()
    if backend is None:
        print(
            "No supported backend found. Install Pillow or ImageMagick, or run on macOS with sips.",
            file=sys.stderr,
        )
        return 2

    output_dir = Path(args.output_dir).resolve() if args.output_dir else None
    if output_dir:
        output_dir.mkdir(parents=True, exist_ok=True)

    print(f"backend={backend}")
    for raw_path in args.paths:
        src = Path(raw_path).resolve()
        if not src.exists():
            print(f"missing: {src}", file=sys.stderr)
            return 1

        fmt = choose_target_format(src, backend, args.target_format)
        dst = build_output_path(src, fmt, output_dir, args.replace)
        before_size = src.stat().st_size
        replaced, after_size = safe_replace(
            src,
            dst,
            backend,
            fmt,
            args.quality,
            args.max_dimension,
            args.replace,
        )
        if replaced:
            print(f"{src} -> {dst} ({before_size} -> {after_size} bytes)")
        else:
            print(f"{src} kept original ({before_size} bytes, candidate {after_size} bytes)")

    return 0


if __name__ == "__main__":
    raise SystemExit(main())
