// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:repository/main.dart';

import 'package:repository/widgets/proceedabletile.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();
  testWidgets('Integration Test', (WidgetTester tester) async {
    SharedPreferences.setMockInitialValues({'locale': 'en'});
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await tester.pumpWidget(MyApp(prefs: prefs));

    // テストコードをここに追加
    expect(find.text("List"), findsOneWidget);
    expect(find.byType(TextField), findsOneWidget);

    final textField = find.byType(TextField);
    await tester.showKeyboard(textField);
    await tester.pumpAndSettle();
    await tester.enterText(textField, 'Matool');
    await tester.pumpAndSettle();
    final testInput = TestTextInput();
    await testInput.receiveAction(TextInputAction.done);
    // await tester.pumpAndSettle();
    // expect(find.byType(CircularProgressIndicator), findsOneWidget);
    await tester.pumpAndSettle();
    final tiles = find.byType(ProceedableTile);
    await tester.tap(tiles.at(0));
    await tester.pumpAndSettle();

    expect(find.text("Language"), findsOneWidget);
    expect(find.text("Stars"), findsOneWidget);
    expect(find.text("Watchers"), findsOneWidget);
    expect(find.text("Forks"), findsOneWidget);
    expect(find.text("Issues"), findsOneWidget);
    expect(find.byType(CircleAvatar), findsOneWidget);
  });
}

extension TestUtilEx on WidgetTester {
  Future<void> pumpUntilFound(
    Finder finder, {
    Duration timeout = const Duration(seconds: 10),
    String description = '',
  }) async {
    var found = false;
    final timer = Timer(
      timeout,
      () => throw TimeoutException('Pump until has timed out $description'),
    );
    while (!found) {
      await pump();
      found = any(finder);
    }
    timer.cancel();
  }
}
