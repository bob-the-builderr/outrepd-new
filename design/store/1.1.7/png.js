// Tiny PNG reader (8-bit RGB/RGBA, non-interlaced) -> {w,h,px(x,y)}
const fs = require('fs'), zlib = require('zlib');
module.exports = function read(file) {
  const b = fs.readFileSync(file); let o = 8, w, h, ct, idat = [];
  while (o < b.length) { const n = b.readUInt32BE(o), t = b.toString('ascii', o + 4, o + 8), d = b.subarray(o + 8, o + 8 + n);
    if (t === 'IHDR') { w = d.readUInt32BE(0); h = d.readUInt32BE(4); ct = d[9]; } if (t === 'IDAT') idat.push(d); o += 12 + n; }
  const bpp = ct === 6 ? 4 : 3, raw = zlib.inflateSync(Buffer.concat(idat)), st = w * bpp, out = Buffer.alloc(h * st);
  for (let y = 0; y < h; y++) { const f = raw[y * (st + 1)], s = y * (st + 1) + 1;
    for (let i = 0; i < st; i++) { const a = i >= bpp ? out[y * st + i - bpp] : 0, u = y ? out[(y - 1) * st + i] : 0, c = y && i >= bpp ? out[(y - 1) * st + i - bpp] : 0; let v = raw[s + i];
      if (f === 1) v += a; else if (f === 2) v += u; else if (f === 3) v += (a + u) >> 1; else if (f === 4) { const p = a + u - c, pa = Math.abs(p - a), pb = Math.abs(p - u), pc = Math.abs(p - c); v += pa <= pb && pa <= pc ? a : pb <= pc ? u : c; }
      out[y * st + i] = v & 255; } }
  return { w, h, px: (x, y) => [out[y * st + x * bpp], out[y * st + x * bpp + 1], out[y * st + x * bpp + 2]] };
};
