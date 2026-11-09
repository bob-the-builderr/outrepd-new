// A node copy of tool/build_install.py (no Python on this machine). Run from
// apps/outrepd_flutter. Must stay byte-for-byte what the Python writes.
const fs = require('fs');
const PARTS = ['subscriptions.sql', 'schema.sql', 'ladder.sql', 'social.sql',
  'duel.sql', 'notify.sql', 'push.sql', 'live.sql', 'seasons.sql',
  'testers.sql', 'adventure.sql', 'challenge.sql', 'account.sql',
  'lockdown.sql'];
const src = fs.readFileSync('tool/build_install.py', 'utf8').replace(/\r\n/g, '\n');
const HEADER = src.split('HEADER = """')[1].split('"""')[0];
const RULE = '-- ' + '='.repeat(72);
const out = [HEADER];
for (const part of PARTS) {
  const body = fs.readFileSync('supabase/' + part, 'utf8').replace(/\r\n/g, '\n');
  out.push(`\n${RULE}\n-- ${part}\n${RULE}\n\n${body.trim()}`);
}
const text = out.join('\n') + '\n';
fs.writeFileSync('supabase/install.sql', text);
console.log('install.sql', text.split('\n').length - 1, 'lines');
