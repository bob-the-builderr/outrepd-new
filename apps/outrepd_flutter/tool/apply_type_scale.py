"""Snaps every hand-written TextStyle onto the type scale.

The app grew 210 font sizes across 25 distinct values. This rewrites each
TextStyle that names a fontSize into the matching step of `context.type`,
keeping whatever else the call site said (colour, height, decoration) and
dropping the size, weight and letter-spacing the step now owns.

Run from the Flutter project root:  python tool/apply_type_scale.py
"""

import io
import os
import re

# Size bands, widest first. A band's step owns size, weight and tracking.
# `micro` is absent on purpose: it carries 1.6 of letter spacing, which is
# right for a short upper-cased overline and wrong for the sentence a 11.5px
# caption usually is. Everything small lands on `label`; overlines go on by
# hand where one is actually meant.
BANDS = [
    (40.0, 'display'),
    (28.0, 'statValue'),
    (20.0, 'title'),
    (16.0, 'heading'),
    (14.0, 'body'),
    (0.0, 'label'),
]

# The scale itself, and the theme, which builds styles with no context to hand.
SKIP = {'lib/type_scale.dart', 'lib/theme.dart'}

# The step provides these; a call site repeating them is noise.
OWNED = {'fontSize', 'fontWeight', 'letterSpacing'}


def step_for(size):
    for floor, name in BANDS:
        if size >= floor:
            return name
    return 'micro'


def split_args(body):
    """Top-level comma split — nested calls and lists stay intact."""
    out, depth, current = [], 0, ''
    for ch in body:
        if ch in '([{':
            depth += 1
        elif ch in ')]}':
            depth -= 1
        if ch == ',' and depth == 0:
            out.append(current)
            current = ''
        else:
            current += ch
    if current.strip():
        out.append(current)
    return out


def rewrite(path):
    src = io.open(path, encoding='utf-8').read()
    out = []
    i = 0
    changed = 0

    while True:
        m = re.compile(r'(const\s+)?TextStyle\(').search(src, i)
        if not m:
            out.append(src[i:])
            break

        # Walk to the matching close paren.
        start = m.end()
        depth = 1
        j = start
        while j < len(src) and depth:
            if src[j] == '(':
                depth += 1
            elif src[j] == ')':
                depth -= 1
            j += 1
        body = src[start:j - 1]

        size = re.search(r'\bfontSize:\s*([0-9.]+)', body)
        if not size:
            out.append(src[i:j])
            i = j
            continue

        step = step_for(float(size.group(1)))
        kept = [a.strip() for a in split_args(body)
                if a.strip() and a.strip().split(':')[0].strip() not in OWNED]

        if kept:
            joined = ', '.join(kept)
            # Keep it on one line when it comfortably fits; the formatter
            # would only unpick a guess at wrapping anyway.
            replacement = 'context.type.%s.copyWith(%s)' % (step, joined)
        else:
            replacement = 'context.type.%s' % step

        out.append(src[i:m.start()])
        out.append(replacement)
        i = j
        changed += 1

    if not changed:
        return 0

    result = ''.join(out)
    if "import '../type_scale.dart';" not in result and "import 'type_scale.dart';" not in result:
        depth_prefix = '../' if '/screens/' in path.replace('\\', '/') else ''
        anchor = "import '%stheme.dart';" % depth_prefix
        if anchor in result:
            result = result.replace(
                anchor, "import '%stype_scale.dart';\n%s" % (depth_prefix, anchor), 1)
    io.open(path, 'w', encoding='utf-8', newline='\n').write(result)
    return changed


total = 0
for root, _dirs, files in os.walk('lib'):
    if 'l10n' in root:
        continue
    for name in files:
        if not name.endswith('.dart'):
            continue
        path = os.path.join(root, name)
        if path.replace(os.sep, '/') in SKIP:
            continue
        n = rewrite(path)
        if n:
            total += n
            print('%-42s %3d' % (path.replace('\\', '/'), n))

print('---')
print('%d styles snapped to the scale' % total)
