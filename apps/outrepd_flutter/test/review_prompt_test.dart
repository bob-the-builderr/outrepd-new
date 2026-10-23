/// When the app asks for a rating: a good moment, a few matches in, once a
/// session, and not again for sixty days.
library;

import 'package:clock/clock.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:outrepd/review_prompt.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late int asked;
  setUp(() {
    SharedPreferences.setMockInitialValues({});
    ReviewPrompt.resetSession();
    asked = 0;
    ReviewPrompt.ask = () async {
      asked++;
      return true;
    };
  });

  test('a good moment a few matches in asks, once a session', () async {
    expect(await ReviewPrompt.maybeAsk(goodMoment: true, matchesPlayed: 5), isTrue);
    expect(await ReviewPrompt.maybeAsk(goodMoment: true, matchesPlayed: 6), isFalse);
    expect(asked, 1);
  });

  test('not before a few matches, and not at a bad moment', () async {
    expect(await ReviewPrompt.maybeAsk(goodMoment: true, matchesPlayed: 2), isFalse);
    expect(await ReviewPrompt.maybeAsk(goodMoment: false, matchesPlayed: 9), isFalse);
    expect(asked, 0);
  });

  test('not again for sixty days, then again', () async {
    Future<bool> on(DateTime day) => withClock(
      Clock.fixed(day),
      () => ReviewPrompt.maybeAsk(goodMoment: true, matchesPlayed: 9),
    );

    expect(await on(DateTime(2026, 1, 1)), isTrue);
    ReviewPrompt.resetSession();
    expect(await on(DateTime(2026, 2, 1)), isFalse);
    ReviewPrompt.resetSession();
    expect(await on(DateTime(2026, 3, 5)), isTrue);
    expect(asked, 2);
  });
}
