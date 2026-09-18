#!/usr/bin/env python3
"""Generate every Play Store image from the raw captures.

The backdrop mirrors the app's own WashiBackground (lib/core/widgets/
washi_background.dart): a seigaiha wave field, colour aura pools and an
ensō ring, in the app's real washi/vermillion palette — not a generic
diagonal-gradient promo template.

Inputs
    store_assets/play_store_icon_512.png     already-generated app icon
    store_assets/screenshots/raw/*.png       device captures, status bar cropped

Outputs
    store_assets/feature_graphic_1024x500.png
    store_assets/screenshots/android-phone/promo_*.png   1080x1920

Run from the project root:  python3 scripts/generate_store_assets.py
"""

import math
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

# The app's own palette (lib/core/theme/kanji_palette.dart).
SUMI = (0x1A, 0x1A, 0x1A)
SHU = (0xB3, 0x3A, 0x3A)
AI = (0x1F, 0x3A, 0x5F)
KINARI = (0xFD, 0xF6, 0xEC)
SAKURA = (0xD9, 0x8C, 0xA0)
INK_LINE = (0x7A, 0x5C, 0x46)

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


def washi_canvas(size):
    """The app's WashiBackground, redrawn at promo scale: base wash,
    seigaiha waves, colour auras, an ensō ring."""
    w, h = size
    canvas = Image.new("RGBA", size, KINARI + (255,))

    # Base wash — three-stop vertical gradient like the app's own base.
    top, mid, bottom = (0xFF, 0xFC, 0xF6), (0xFD, 0xF4, 0xE6), (0xF3, 0xE0, 0xCC)
    grad = Image.new("RGB", (1, h))
    for y in range(h):
        t = y / max(h - 1, 1)
        if t < 0.55:
            local = t / 0.55
            colour = tuple(int(top[i] + (mid[i] - top[i]) * local) for i in range(3))
        else:
            local = (t - 0.55) / 0.45
            colour = tuple(int(mid[i] + (bottom[i] - mid[i]) * local) for i in range(3))
        grad.putpixel((0, y), colour)
    canvas.alpha_composite(grad.resize((w, h)).convert("RGBA"))

    # Colour aura pools, same anchor points/relative sizes as the app.
    def aura(centre, radius, colour, alpha):
        layer = Image.new("RGBA", size, (0, 0, 0, 0))
        d = ImageDraw.Draw(layer)
        steps = 40
        for i in range(steps, 0, -1):
            frac = i / steps
            a = int(alpha * (1 - frac) ** 2)
            r = radius * frac
            d.ellipse(
                [centre[0] - r, centre[1] - r, centre[0] + r, centre[1] + r],
                fill=colour + (a,),
            )
        canvas.alpha_composite(layer)

    aura((w * 0.86, h * 0.07), w * 0.75, SHU, 70)
    aura((w * 0.05, h * 0.32), w * 0.68, AI, 46)
    aura((w * 0.7, h * 0.93), w * 0.85, SAKURA, 58)

    # Seigaiha wave field.
    wave_layer = Image.new("RGBA", size, (0, 0, 0, 0))
    wd = ImageDraw.Draw(wave_layer)
    radius = w * 0.052
    rings = 3
    step_x = radius
    step_y = radius * 0.58
    rows = int(h / step_y) + 2
    cols = int(w / step_x) + 3
    for row in range(rows):
        y = row * step_y
        depth = min(y / h, 1.0)
        alpha = int(14 + depth * 30)
        offset_x = 0 if row % 2 == 0 else step_x / 2
        for col in range(-1, cols):
            cx = col * step_x + offset_x
            for ring in range(1, rings + 1):
                r = radius * ring / rings
                wd.arc(
                    [cx - r, y - r, cx + r, y + r],
                    180,
                    360,
                    fill=INK_LINE + (alpha,),
                    width=2,
                )
    canvas.alpha_composite(wave_layer)

    # Ensō ring, upper right, brushed feel via blur.
    enso = Image.new("RGBA", size, (0, 0, 0, 0))
    ed = ImageDraw.Draw(enso)
    ecx, ecy = w * 0.82, h * 0.2
    er = w * 0.34
    ed.arc(
        [ecx - er, ecy - er, ecx + er, ecy + er],
        -145,
        135,
        fill=SUMI + (26,),
        width=int(w * 0.016),
    )
    canvas.alpha_composite(enso.filter(ImageFilter.GaussianBlur(1)))

    return canvas


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


def centered(draw, y, text, fnt, fill, width, shadow_colour=None):
    box = draw.textbbox((0, 0), text, font=fnt)
    x = (width - (box[2] - box[0])) // 2 - box[0]
    if shadow_colour:
        draw.text((x + 2, y + 3), text, font=fnt, fill=shadow_colour)
    draw.text((x, y), text, font=fnt, fill=fill)
    return box[3] - box[1]


def make_feature_graphic():
    w, h = 1024, 500
    canvas = washi_canvas((w, h))

    size = 250
    icon = rounded(
        Image.open(ICON).convert("RGB").resize((size, size), Image.LANCZOS),
        int(size * 0.22),
    )
    ix, iy = 88, (h - size) // 2
    drop_shadow(canvas, (ix, iy, ix + size, iy + size), int(size * 0.22), 16, 60, (0, 10))
    canvas.alpha_composite(icon, (ix, iy))

    d = ImageDraw.Draw(canvas)
    tx = ix + size + 58
    f_kanji = font(FONT_DISPLAY, 46)
    f_title = font(FONT_DISPLAY, 84)
    f_sub = font(FONT_BODY, 28)
    d.text((tx, 96), "暦", font=f_kanji, fill=SHU + (255,))
    d.text((tx, 150), "KOYOMI", font=f_title, fill=SUMI + (255,))
    d.text((tx, 262), "Japanese home screen widgets", font=f_sub, fill=(0x5A, 0x4E, 0x40, 255))

    line_y = 310
    d.line([(tx, line_y), (tx + 360, line_y)], fill=SHU + (140,), width=2)

    canvas.convert("RGB").save(STORE / "feature_graphic_1024x500.png")
    print("  feature_graphic_1024x500.png  (RGB, no alpha)")


def make_promo(raw_name, line1, line2, out_path):
    w, h = TARGET
    canvas = washi_canvas(TARGET)

    d = ImageDraw.Draw(canvas)
    f_kanji = font(FONT_DISPLAY, 40)
    f1 = font(FONT_DISPLAY, 60)
    f2 = font(FONT_BODY, 36)

    y = 78
    y += centered(d, y, "暦", f_kanji, SHU + (255,), w) + 16
    y += centered(d, y, line1, f1, SUMI + (255,), w) + 26
    centered(d, y, line2, f2, (0x5A, 0x4E, 0x40, 255), w)

    shot = Image.open(RAW / f"{raw_name}.png").convert("RGB")
    top = 330
    avail_h = h - top - 100
    avail_w = int(w * 0.82)
    scale = min(avail_w / shot.width, avail_h / shot.height)
    shot = shot.resize((int(shot.width * scale), int(shot.height * scale)), Image.LANCZOS)

    radius = 46
    sx = (w - shot.width) // 2
    sy = top
    drop_shadow(canvas, (sx, sy, sx + shot.width, sy + shot.height), radius, 30, 70, (0, 18))
    canvas.alpha_composite(rounded(shot, radius), (sx, sy))

    border = Image.new("RGBA", canvas.size, (0, 0, 0, 0))
    ImageDraw.Draw(border).rounded_rectangle(
        [sx, sy, sx + shot.width - 1, sy + shot.height - 1],
        radius=radius,
        outline=(255, 255, 255, 120),
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
