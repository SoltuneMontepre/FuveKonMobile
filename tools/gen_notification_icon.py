"""Generate Android white-on-transparent notification icons from splash logo."""

from __future__ import annotations

import os
from pathlib import Path

from PIL import Image

ROOT = Path(__file__).resolve().parents[1]
SRC = ROOT / "android/app/src/main/res/drawable/splash_logo.png"
RES = ROOT / "android/app/src/main/res"

SIZES = {
    "drawable-mdpi": 24,
    "drawable-hdpi": 36,
    "drawable-xhdpi": 48,
    "drawable-xxhdpi": 72,
    "drawable-xxxhdpi": 96,
}


def to_white_silhouette(img: Image.Image) -> Image.Image:
    rgba = img.convert("RGBA")
    pixels = rgba.load()
    w, h = rgba.size
    out = Image.new("RGBA", (w, h), (0, 0, 0, 0))
    out_px = out.load()
    for y in range(h):
        for x in range(w):
            r, g, b, _a = pixels[x, y]
            lum = 0.299 * r + 0.587 * g + 0.114 * b
            if lum < 40:
                out_px[x, y] = (255, 255, 255, 0)
            else:
                alpha = int(min(255, max(0, (lum - 40) / 215 * 255)))
                out_px[x, y] = (255, 255, 255, alpha)
    return out


def main() -> None:
    silhouette = to_white_silhouette(Image.open(SRC))

    master = silhouette.resize((96, 96), Image.Resampling.LANCZOS)
    master_path = RES / "drawable" / "ic_notification.png"
    master.save(master_path, "PNG")
    print(f"saved {master_path}")

    for folder, size in SIZES.items():
        dest_dir = RES / folder
        dest_dir.mkdir(parents=True, exist_ok=True)
        resized = silhouette.resize((size, size), Image.Resampling.LANCZOS)
        path = dest_dir / "ic_notification.png"
        resized.save(path, "PNG")
        print(f"saved {path} ({size}x{size})")


if __name__ == "__main__":
    main()
