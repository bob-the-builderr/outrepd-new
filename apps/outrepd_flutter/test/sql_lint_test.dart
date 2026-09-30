/// The SQL checks that can be made without a database.
///
/// There is no Postgres on this machine, so the server's functions are written
/// blind and first run on the real project. That is a slow loop — every
/// mistake costs a round trip through somebody else's dashboard — so the
/// mistakes that *can* be caught here are caught here.
///
/// It started with one: `place_after` took `tier_idx` as an argument and
/// returned a column of the same name, which Postgres refuses outright. The
/// whole install failed on it. Nothing in Dart would have noticed, and nothing
/// else in this project reads SQL at all.
library;

import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

/// One `create function` in a file.
class _Function {
  _Function(this.name, this.params, this.returns, this.line, this.headerEnd);

  final String name;
  final List<String> params;
  final List<String> returns;
  final int line;

  /// Where the signature stops, as an offset into the comment-stripped text.
  /// The body starts at the first `$$` after it.
  final int headerEnd;
}

/// The same SQL with `-- …` comments blanked out, newlines kept so line
/// numbers still point at the right place.
///
/// Parsing without this reads prose as code: a comment inside a
/// `returns table (…)` list turns into an output column called "--", and the
/// real names after it go missing — which is exactly how the check below
/// first shipped looking like it passed.
String _withoutComments(String sql) => sql
    .replaceAll('\r\n', '\n')
    .split('\n')
    .map((line) {
      final at = line.indexOf('--');
      return at < 0 ? line : line.substring(0, at);
    })
    .join('\n');

List<_Function> _functionsIn(String sql) {
  final out = <_Function>[];
  final text = _withoutComments(sql);

  final pattern = RegExp(
    r'create\s+or\s+replace\s+function\s+(\w+)\s*\(([^)]*)\)\s*'
    r'returns\s+(?:table\s*\(([^)]*)\))?',
    caseSensitive: false,
    dotAll: true,
  );

  for (final match in pattern.allMatches(text)) {
    final line = '\n'.allMatches(text.substring(0, match.start)).length + 1;

    List<String> names(String? group) {
      if (group == null || group.trim().isEmpty) return const [];
      return [
        for (final part in group.split(','))
          if (part.trim().isNotEmpty)
            // "name type default x" → name
            part.trim().split(RegExp(r'\s+')).first.toLowerCase(),
      ];
    }

    out.add(
      _Function(
        match.group(1)!,
        names(match.group(2)),
        names(match.group(3)),
        line,
        match.end,
      ),
    );
  }
  return out;
}

/// Column names of every `create table` in a file.
Map<String, Set<String>> _tablesIn(String sql) {
  final out = <String, Set<String>>{};
  final text = sql.replaceAll('\r\n', '\n');

  final pattern = RegExp(
    r'create\s+table\s+(?:if\s+not\s+exists\s+)?(\w+)\s*\(',
    caseSensitive: false,
  );

  for (final match in pattern.allMatches(text)) {
    // Read to the closing paren of the table body, counting nesting so a
    // `check (...)` inside a column does not end it early.
    var depth = 1;
    var i = match.end;
    while (i < text.length && depth > 0) {
      if (text[i] == '(') depth++;
      if (text[i] == ')') depth--;
      i++;
    }
    final columns = <String>{};
    for (final raw in text.substring(match.end, i - 1).split('\n')) {
      final line = raw.trim();
      if (line.isEmpty || line.startsWith('--')) continue;
      final name = RegExp(r'^(\w+)\s+\w').firstMatch(line)?.group(1);
      // Table-level constraints start with a keyword, not a column name.
      if (name == null) continue;
      if (const {
        'primary',
        'check',
        'unique',
        'foreign',
        'constraint',
      }.contains(name.toLowerCase())) {
        continue;
      }
      columns.add(name.toLowerCase());
    }
    out[match.group(1)!.toLowerCase()] = columns;
  }
  return out;
}

void main() {
  final files = Directory('supabase')
      .listSync()
      .whereType<File>()
      .where((f) => f.path.endsWith('.sql') && !f.path.endsWith('install.sql'))
      .toList();

  test('there is SQL to check', () {
    expect(files, isNotEmpty);
  });

  test('no function names an input the same as an output', () {
    // `ERROR: 42P13: parameter name "tier_idx" used more than once` — and the
    // whole install stops there, so one of these fails everything after it.
    final clashes = <String>[];

    for (final file in files) {
      for (final fn in _functionsIn(file.readAsStringSync())) {
        for (final param in fn.params) {
          if (fn.returns.contains(param)) {
            clashes.add(
              '${file.path}:${fn.line} ${fn.name}() takes "$param" '
              'and also returns a column called "$param"',
            );
          }
        }
      }
    }

    expect(clashes, isEmpty, reason: clashes.join('\n'));
  });

  test('an update never reads a column a RETURNS TABLE also names', () {
    // `RETURNS TABLE (... wins int ...)` gives plpgsql a variable called
    // `wins` for the whole body. An `update profiles set wins = wins + 1`
    // then has two things that identifier could mean, and Postgres refuses
    // the call at runtime: 42702, "column reference is ambiguous". It is
    // invisible until somebody actually plays a duel, which is how it got to
    // the live database once already.
    //
    // Qualifying the read — `profiles.wins` — settles it. Assignment targets
    // are left alone: the name left of `=` in a SET list can only ever be
    // the column.
    final tables = <String, Set<String>>{};
    for (final file in files) {
      tables.addAll(_tablesIn(file.readAsStringSync()));
    }

    final risky = <String>[];
    for (final file in files) {
      final text = _withoutComments(file.readAsStringSync());
      for (final fn in _functionsIn(file.readAsStringSync())) {
        if (fn.returns.isEmpty) continue;
        // From this function's own `$$` to its close, so a body is never
        // read against the signature of the function above it.
        final opens = text.indexOf(r'$$', fn.headerEnd);
        if (opens < 0) continue;
        final closes = text.indexOf(r'$$', opens + 2);
        final scope = text.substring(opens, closes < 0 ? text.length : closes);

        for (final update in RegExp(
          r'update\s+(\w+)\s+set\b([\s\S]*?)\bwhere\b',
          caseSensitive: false,
        ).allMatches(scope)) {
          final columns = tables[update.group(1)!.toLowerCase()] ?? const {};
          final sets = update.group(2)!;
          for (final name in fn.returns) {
            if (!columns.contains(name)) continue;
            // Every mention that is not `something.name` and not the target
            // of an assignment.
            for (final hit in RegExp(
              '(?<![.\\w])$name(?![\\w])',
            ).allMatches(sets)) {
              final after = sets.substring(hit.end).trimLeft();
              if (after.startsWith('=')) continue; // assignment target
              risky.add(
                '${file.path} ${fn.name}() reads "$name" unqualified '
                'while updating ${update.group(1)}, which has a column of '
                'that name and a RETURNS TABLE entry to match',
              );
              break;
            }
          }
        }
      }
    }

    expect(risky, isEmpty, reason: risky.join('\n'));
  });

  test(r'every function body is quoted with $$ at both ends', () {
    // A single `$` where `$$` belongs is `syntax error at or near "$"`, and
    // the whole install stops there. It happened once: a script rewriting a
    // function ran the new text through a replace that reads `$$` as an
    // escaped `$`, and install.sql was built from the damaged part.
    final broken = <String>[];
    for (final file in [...files, File('supabase/install.sql')]) {
      final text = _withoutComments(file.readAsStringSync());
      final lines = text.split('\n');
      for (var i = 0; i < lines.length; i++) {
        if (RegExp(r'^\s*as\s+\$\s*$', caseSensitive: false)
                .hasMatch(lines[i]) ||
            RegExp(r'^\s*\$\s*;\s*$').hasMatch(lines[i])) {
          broken.add('${file.path}:${i + 1} ${lines[i].trim()}');
        }
      }
      if (r'$$'.allMatches(text).length.isOdd) {
        broken.add('${file.path} opens a \$\$ it never closes');
      }
    }

    expect(broken, isEmpty, reason: broken.join('\n'));
  });

  test('every function declares a search path', () {
    // A `security definer` function without one runs with whatever search
    // path the caller set, which is how a client points a trusted function at
    // its own tables.
    final missing = <String>[];

    for (final file in files) {
      final text = file.readAsStringSync();
      for (final match in RegExp(
        r'create\s+or\s+replace\s+function\s+(\w+)[\s\S]{0,900}?\$\$',
        caseSensitive: false,
      ).allMatches(text)) {
        final body = match.group(0)!;
        if (body.toLowerCase().contains('security definer') &&
            !body.toLowerCase().contains('set search_path')) {
          missing.add(
            '${file.path} ${match.group(1)} is security definer '
            'with no search_path',
          );
        }
      }
    }

    expect(missing, isEmpty, reason: missing.join('\n'));
  });

  test('the installer is up to date with its parts', () {
    // install.sql is generated, and a stale one is worse than none: it
    // installs something nobody has read.
    //
    // Only the parts it is made of. `ladder_test.sql` is the harness that
    // checks the result and is run on its own, so it is deliberately not in
    // there.
    const installed = [
      'subscriptions.sql',
      'schema.sql',
      'ladder.sql',
      'duel.sql',
      'social.sql',
      'notify.sql',
      'push.sql',
      'account.sql',
    ];
    final installer = File('supabase/install.sql');
    if (!installer.existsSync()) return;

    final text = installer.readAsStringSync();
    for (final file in files) {
      if (!installed.any(file.path.endsWith)) continue;
      final body = file.readAsStringSync().trim();
      if (body.isEmpty) continue;
      // The last line of each part is enough to catch a regeneration that
      // never happened.
      final tail = body.split('\n').last.trim();
      if (tail.isEmpty || tail.startsWith('--')) continue;
      expect(
        text,
        contains(tail),
        reason:
            '${file.path} has changed since install.sql was generated — '
            'regenerate it before pasting',
      );
    }
  });

  test('policies can be applied twice', () {
    // The installer is pasted again after every change, so anything that is
    // not idempotent turns a small fix into a manual cleanup.
    for (final file in files) {
      final text = file.readAsStringSync();
      for (final match in RegExp(r'create policy "([^"]+)"').allMatches(text)) {
        final name = match.group(1)!;
        expect(
          text,
          contains('drop policy if exists "$name"'),
          reason: 'policy "$name" in ${file.path} is not re-runnable',
        );
      }
    }
  });
}
