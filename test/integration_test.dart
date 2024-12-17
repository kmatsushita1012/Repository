// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:integration_test/integration_test.dart';
import 'package:repository/main.dart';
import 'package:repository/widgets/proceedabletile.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'helpers/mockapi.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();
  late MockClient mockClient;
  late SharedPreferences prefs;

  setUpAll(() async {
    mockClient = MockClient(mockAPI);
    GetIt.I.registerLazySingleton<http.Client>(() => mockClient);
    SharedPreferences.setMockInitialValues({'locale': 'en'});
    prefs = await SharedPreferences.getInstance();
  });
  //通常
  testWidgets('Normal', (WidgetTester tester) async {
    await tester.pumpWidget(MyApp(prefs: prefs));

    expect(find.text("List"), findsOneWidget);
    expect(find.text("Enter a keyword to search for repositories."),
        findsOneWidget);
    final textField = find.byType(TextField);
    expect(textField, findsOneWidget);

    await tester.showKeyboard(textField);
    await tester.pumpAndSettle();
    await tester.enterText(textField, 'q');
    await tester.pumpAndSettle();
    final testInput = TestTextInput();
    await testInput.receiveAction(TextInputAction.done);
    await tester.pumpAndSettle();
    final tiles = find.byType(ProceedableTile);
    expect(tiles, findsWidgets);
    await tester.tap(tiles.at(0));
    await tester.pumpAndSettle();

    expect(find.text("Language"), findsOneWidget);
    expect(find.text("Stars"), findsOneWidget);
    expect(find.text("Watchers"), findsOneWidget);
    expect(find.text("Forks"), findsOneWidget);
    expect(find.text("Issues"), findsOneWidget);
    expect(find.byType(CircleAvatar), findsOneWidget);
  });
  //ネットワークエラー等
  testWidgets('Error 500', (WidgetTester tester) async {
    await tester.pumpWidget(MyApp(prefs: prefs));

    final textField = find.byType(TextField);
    await tester.showKeyboard(textField);
    await tester.pumpAndSettle();
    await tester.enterText(textField, '500');
    await tester.pumpAndSettle();
    final testInput = TestTextInput();
    await testInput.receiveAction(TextInputAction.done);
    await tester.pumpAndSettle();
    expect(find.text("Error"), findsOneWidget);
    expect(find.text("An unexpected error has occurred. Please try again."),
        findsOneWidget);
  });
  //不適切なクエリ
  testWidgets('Error 422', (WidgetTester tester) async {
    await tester.pumpWidget(MyApp(prefs: prefs));

    final textField = find.byType(TextField);
    await tester.showKeyboard(textField);
    await tester.pumpAndSettle();
    await tester.enterText(textField, '422');
    await tester.pumpAndSettle();
    final testInput = TestTextInput();
    await testInput.receiveAction(TextInputAction.done);
    await tester.pumpAndSettle();
    expect(find.text("Error"), findsOneWidget);
    expect(
        find.text(
            "The search query you entered is invalid. Please check it again."),
        findsOneWidget);
  });
  //結果0件
  testWidgets('Notice 204', (WidgetTester tester) async {
    await tester.pumpWidget(MyApp(prefs: prefs));

    final textField = find.byType(TextField);
    await tester.showKeyboard(textField);
    await tester.pumpAndSettle();
    await tester.enterText(textField, '204');
    await tester.pumpAndSettle();
    final testInput = TestTextInput();
    await testInput.receiveAction(TextInputAction.done);
    await tester.pumpAndSettle();
    expect(find.byType(AlertDialog), findsOneWidget);
    expect(find.text("Notice"), findsOneWidget);
    expect(find.text("No results found."), findsOneWidget);
  });
  //設定
  testWidgets('Setting', (WidgetTester tester) async {
    await tester.pumpWidget(MyApp(prefs: prefs));
    await tester.tap(find.byType(IconButton));
    await tester.pumpAndSettle();
    expect(find.text("Settings"), findsOneWidget);
    expect(find.text("English"), findsOneWidget);
    await tester.tap(find.text("English"));
    await tester.pumpAndSettle();
    expect(find.text("Set Language"), findsOneWidget);
    await tester.tap(find.text("日本語"));
    await tester.pumpAndSettle();
    expect(find.text("言語設定"), findsOneWidget);
    await tester.tap(find.byType(BackButton));
    await tester.pumpAndSettle();
    expect(find.text("設定"), findsOneWidget);
  });
}
