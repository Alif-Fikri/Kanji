#!/usr/bin/env python3
"""Generate every Play Store image from the raw captures.

Inputs
    store_assets/play_store_icon_512.png     already-generated app icon
    store_assets/screenshots/raw/*.png       device captures, status bar cropped

Outputs
    store_assets/feature_graphic_1024x500.png
    store_assets/screenshots/android-phone/promo_*.png   1080x1920

Run from the project root:  python3 scripts/generate_store_assets.py
"""

import pathlib
import sys

from PIL import Image, ImageDraw, ImageFilter, ImageFont

ROOT = pathlib.Path(__file__).resolve().parent.parent
STORE = ROOT / "store_assets"
RAW = STORE / "screenshots" / "raw"
ICON = STORE / "play_store_icon_512.png"
FONT_DIR = ROOT / "assets" / "fonts"

FONT_DISPLAY = str(FONT_DIR / "ZenOldMincho-Bold.ttf")
FONT_BODY = str(FONT_DIR / "NotoSansJP-Medium.ttf")

KINARI = (0xFD, 0xF6, 0xEC)
SUMI = (0x1A, 0x1A, 0x1A)
VERMILLION = (0xB3, 0x3A, 0x3A)
GOLD = (0xA8, 0x84, 0x2C)

SLIDES = [
    ("home", "Three widgets,", "one home screen"),
    ("gallery", "Templates, colours,", "your own style"),
    ("quote", "A Japanese quote", "every single day"),
    ("placed", "Live and updating,", "right where you look"),
]

TARGET = (1080, 1920)


def font(path, size):
    try:
        return ImageFont.truetype(path, size)
    except OSError:
        return ImageFont.load_default()


def diagonal_gradient(size):
    w, h = size
    small = Image.new("RGB", (2, 256))
    d = ImageDraw.Draw(small)
    for y in range(256):
        t = y / 255
        colour = tuple(
            int(KINARI[i] + (VERMILLION[i] * 0.55 - KINARI[i]) * t) for i in range(3)
        )
        d.line([(0, y), (1, y)], fill=colour)
    grad = small.resize((max(w, h) * 2, max(w, h) * 2), Image.BICUBIC)
    return grad.rotate(-30, resample=Image.BICUBIC).crop(
        (max(w, h) // 2, max(w, h) // 2, max(w, h) // 2 + w, max(w, h) // 2 + h)
    )


def rounded(img, radius):
    mask = Image.new("L", img.size, 0)
    ImageDraw.Draw(mask).rounded_rectangle(
        [0, 0, img.width - 1, img.height - 1], radius=radius, fill=255
    )
    out = img.convert("RGBA")
    out.putalpha(mask)
    return out


def drop_shadow(canvas, box, radius, blur, alpha, offset):
    shadow = Image.new("RGBA", canvas.size, (0, 0, 0, 0))
    ImageDraw.Draw(shadow).rounded_rectangle(
        [box[0] + offset[0], box[1] + offset[1], box[2] + offset[0], box[3] + offset[1]],
        radius=radius,
        fill=(0, 0, 0, alpha),
    )
    canvas.alpha_composite(shadow.filter(ImageFilter.GaussianBlur(blur)))


def centered(draw, y, text, fnt, fill, width, shadow=True):
    box = draw.textbbox((0, 0), text, font=fnt)
    x = (width - (box[2] - box[0])) // 2 - box[0]
    if shadow:
        draw.text((x + 2, y + 3), text, font=fnt, fill=(0, 0, 0, 90))
    draw.text((x, y), text, font=fnt, fill=fill)
    return box[3] - box[1]


def make_feature_graphic():
    w, h = 1024, 500
    canvas = diagonal_gradient((w, h)).convert("RGBA")

    size = 260
    icon = rounded(
        Image.open(ICON).convert("RGB").resize((size, size), Image.LANCZOS),
        int(size * 0.22),
    )
    ix, iy = 96, (h - size) // 2
    drop_shadow(canvas, (ix, iy, ix + size, iy + size), int(size * 0.22), 18, 140, (0, 14))
    canvas.alpha_composite(icon, (ix, iy))

    d = ImageDraw.Draw(canvas)
    tx = ix + size + 60
    f_title = font(FONT_DISPLAY, 100)
    f_sub = font(FONT_BODY, 32)
    d.text((tx + 3, 155), "KOYOMI", font=f_title, fill=(0, 0, 0, 90))
    d.text((tx, 152), "KOYOMI", font=f_title, fill=(255, 255, 255))
    d.text((tx, 268), "暦 — Japanese home screen widgets", font=f_sub, fill=(255, 240, 225))

    canvas.convert("RGB").save(STORE / "feature_graphic_1024x500.png")
    print("  feature_graphic_1024x500.png  (RGB, no alpha)")


def make_promo(raw_name, line1, line2, out_path):
    w, h = TARGET
    canvas = diagonal_gradient((w, h)).convert("RGBA")

    d = ImageDraw.Draw(canvas)
    f1 = font(FONT_DISPLAY, 66)
    f2 = font(FONT_BODY, 42)
    y = 100
    y += centered(d, y, line1, f1, (255, 255, 255), w) + 34
    centered(d, y, line2, f2, (0xFF, 0xE8, 0xD6), w)

    shot = Image.open(RAW / f"{raw_name}.png").convert("RGB")
    top = 310
    avail_h = h - top - 100
    avail_w = int(w * 0.82)
    scale = min(avail_w / shot.width, avail_h / shot.height)
    shot = shot.resize((int(shot.width * scale), int(shot.height * scale)), Image.LANCZOS)

    radius = 54
    sx = (w - shot.width) // 2
    sy = top
    drop_shadow(canvas, (sx, sy, sx + shot.width, sy + shot.height), radius, 36, 160, (0, 22))
    canvas.alpha_composite(rounded(shot, radius), (sx, sy))

    border = Image.new("RGBA", canvas.size, (0, 0, 0, 0))
    ImageDraw.Draw(border).rounded_rectangle(
        [sx, sy, sx + shot.width - 1, sy + shot.height - 1],
        radius=radius,
        outline=(255, 255, 255, 70),
        width=3,
    )
    canvas.alpha_composite(border)

    out_path.parent.mkdir(parents=True, exist_ok=True)
    canvas.convert("RGB").save(out_path)


def main():
    missing = [n for n, _, _ in SLIDES if not (RAW / f"{n}.png").exists()]
    if missing:
        print(f"Missing raw captures: {', '.join(missing)}", file=sys.stderr)
        print(f"Put them in {RAW.relative_to(ROOT)}/ first.", file=sys.stderr)
        return 1

    STORE.mkdir(parents=True, exist_ok=True)
    print("Feature graphic:")
    make_feature_graphic()

    print("Screenshots:")
    folder = STORE / "screenshots" / "android-phone"
    for i, (raw_name, line1, line2) in enumerate(SLIDES, start=1):
        make_promo(raw_name, line1, line2, folder / f"promo_{i}_{raw_name}.png")
    print(f"  android-phone: {len(SLIDES)} slides at {TARGET[0]}x{TARGET[1]}")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
