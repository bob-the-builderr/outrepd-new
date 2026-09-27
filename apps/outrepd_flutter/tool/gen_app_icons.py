"""Draws every app icon from the logo in assets/images/logo-wordmark.png.

The mark is the top of that image (the two lifters and the arrow, without the
word), set on the app's dark background. Writes the iOS app icon set, the
Android launcher icons (plain and adaptive), and the web icons and favicon.

Needs Pillow. Run from the Flutter project root:  python tool/gen_app_icons.py
"""

import json
import os

from PIL import Image

BACKGROUND = (18, 17, 16)  # palette background, lib/theme.dart
BACKGROUND_HEX = '#121110'


def mark():
    """The symbol alone, cropped tight."""
    logo = Image.open('assets/images/logo-wordmark.png').convert('RGBA')
    # The word sits below y=500; everything above it is the symbol.
    top = logo.crop((0, 0, logo.width, 500))
    return top.crop(top.getbbox())


def place(symbol, size, width_share, background):
    """[symbol] centred on a square [size] wide, [width_share] of it wide."""
    canvas = Image.new('RGBA', (size, size), background)
    w = round(size * width_share)
    h = round(symbol.height * w / symbol.width)
    art = symbol.resize((w, h), Image.LANCZOS)
    # A touch below centre: the arrow's point is thin, the lifters are heavy.
    canvas.alpha_composite(art, ((size - w) // 2, (size - h) // 2 + size // 50))
    return canvas


def solid(image):
    """No alpha channel. The App Store refuses an icon with one."""
    return image.convert('RGB')


def white(symbol):
    """The mark in one colour, for Android's themed icons."""
    out = Image.new('RGBA', symbol.size, (255, 255, 255, 0))
    out.putalpha(symbol.getchannel('A'))
    return out


def ios(symbol):
    folder = 'ios/Runner/Assets.xcassets/AppIcon.appiconset'
    with open(os.path.join(folder, 'Contents.json')) as f:
        images = json.load(f)['images']
    for entry in images:
        points = float(entry['size'].split('x')[0])
        px = round(points * int(entry['scale'][0]))
        icon = solid(place(symbol, px, 0.84, BACKGROUND + (255,)))
        icon.save(os.path.join(folder, entry['filename']))


def android(symbol):
    res = 'android/app/src/main/res'
    densities = {'mdpi': 1, 'hdpi': 1.5, 'xhdpi': 2, 'xxhdpi': 3, 'xxxhdpi': 4}
    for name, k in densities.items():
        folder = os.path.join(res, f'mipmap-{name}')
        # Launchers from before Android 8 show this square as it is.
        solid(place(symbol, round(48 * k), 0.8, BACKGROUND + (255,))).save(
            os.path.join(folder, 'ic_launcher.png'))
        # Adaptive layers are 108dp and the launcher may crop to a 66dp
        # circle, so the mark has to fit inside that: 58dp wide clears it.
        layer = round(108 * k)
        fg = place(symbol, layer, 58 / 108, (0, 0, 0, 0))
        fg.save(os.path.join(folder, 'ic_launcher_foreground.png'))
        place(white(symbol), layer, 58 / 108, (0, 0, 0, 0)).save(
            os.path.join(folder, 'ic_launcher_monochrome.png'))

    os.makedirs(os.path.join(res, 'mipmap-anydpi-v26'), exist_ok=True)
    with open(os.path.join(res, 'mipmap-anydpi-v26', 'ic_launcher.xml'), 'w') as f:
        f.write(
            '<?xml version="1.0" encoding="utf-8"?>\n'
            '<adaptive-icon xmlns:android="http://schemas.android.com/apk/res/android">\n'
            '    <background android:drawable="@color/ic_launcher_background"/>\n'
            '    <foreground android:drawable="@mipmap/ic_launcher_foreground"/>\n'
            '    <monochrome android:drawable="@mipmap/ic_launcher_monochrome"/>\n'
            '</adaptive-icon>\n')
    with open(os.path.join(res, 'values', 'ic_launcher_background.xml'), 'w') as f:
        f.write(
            '<?xml version="1.0" encoding="utf-8"?>\n'
            '<resources>\n'
            f'    <color name="ic_launcher_background">{BACKGROUND_HEX}</color>\n'
            '</resources>\n')


def web(symbol):
    bg = BACKGROUND + (255,)
    for px in (192, 512):
        solid(place(symbol, px, 0.84, bg)).save(f'web/icons/Icon-{px}.png')
        # Maskable icons may be cut to a circle 80% wide.
        solid(place(symbol, px, 0.66, bg)).save(
            f'web/icons/Icon-maskable-{px}.png')
    solid(place(symbol, 48, 0.9, bg)).save('web/favicon.png')


def main():
    symbol = mark()
    ios(symbol)
    android(symbol)
    web(symbol)


if __name__ == '__main__':
    main()
