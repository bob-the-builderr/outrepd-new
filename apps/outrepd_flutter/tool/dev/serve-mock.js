// Serves a mockup folder, and saves what the page posts to /save?name=x.png
// (a PNG data URL as the body) into that folder. node serve-mock.js <dir> <port>
const http = require('http'), fs = require('fs'), path = require('path');
const root = path.resolve(process.argv[2]), port = +process.argv[3];
const types = { '.html': 'text/html; charset=utf-8', '.js': 'text/javascript', '.png': 'image/png', '.jpg': 'image/jpeg' };
http.createServer((req, res) => {
  const url = new URL(req.url, 'http://x');
  if (req.method === 'POST' && url.pathname === '/save') {
    const chunks = []; req.on('data', (c) => chunks.push(c));
    req.on('end', () => {
      const name = path.basename(url.searchParams.get('name') || 'out.png');
      const b64 = Buffer.concat(chunks).toString().replace(/^data:image\/png;base64,/, '');
      fs.writeFileSync(path.join(root, name), Buffer.from(b64, 'base64')); res.end('ok');
    });
    return;
  }
  const file = path.join(root, decodeURIComponent(url.pathname === '/' ? '/index.html' : url.pathname));
  if (!file.startsWith(root)) { res.writeHead(403); return res.end(); }
  fs.readFile(file, (err, data) => {
    if (err) { res.writeHead(404); return res.end('not found'); }
    res.writeHead(200, { 'Content-Type': types[path.extname(file)] || 'application/octet-stream', 'Cache-Control': 'no-store' }); res.end(data);
  });
}).listen(port, () => console.log('serving ' + root + ' on http://localhost:' + port));
