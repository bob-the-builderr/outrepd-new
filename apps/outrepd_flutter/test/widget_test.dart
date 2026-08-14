import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:outrepd/main.dart';

void main() {
  testWidgets('welcome screen shows the brand and entry buttons',
      (WidgetTester tester) async {
    await tester.pumpWidget(const OutrepdApp());

    expect(find.text('OUTREPD'), findsOneWidget);
    expect(find.widgetWithText(FilledButton, 'Get Started'), findsOneWidget);
    expect(
      find.widgetWithText(OutlinedButton, 'Skip to the app'),
      findsOneWidget,
    );
  });
}
