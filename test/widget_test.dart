import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:repository/models/sorttypes.dart';
import 'package:repository/providers/repository_provider.dart';
import 'package:repository/widgets/detailcard.dart';
import 'package:repository/widgets/detailtile.dart';
import 'package:repository/widgets/proceedabletile.dart';
import 'package:repository/widgets/queryfield.dart';
import 'package:repository/widgets/selectabletile.dart';
import 'package:repository/widgets/sortbutton.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

void main() {
  setUpAll(() {
    // GetItのセットアップ
    final client = MockClient(handler);
    GetIt.I.registerLazySingleton<http.Client>(() => client);
  });
  testWidgets('DetailCard', (WidgetTester tester) async {
    String title = "Stars";
    int value = -9223372036854775808;
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: DetailCard(
            title: title,
            iconData: Icons.language,
            value: value,
            animation: AlwaysStoppedAnimation(1.0),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
    expect(find.text(title), findsOneWidget);
    expect(find.text(NumberFormat('#,###').format(value)), findsOneWidget);
  });
  testWidgets('DetailTile', (WidgetTester tester) async {
    String title = "Language";
    String value =
        "AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA";
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
            body: DetailTile(
          title: title,
          iconData: Icons.language,
          value: value,
          animation: AlwaysStoppedAnimation(1.0),
        )),
      ),
    );
    expect(find.text(title), findsOneWidget);
    expect(find.text(value), findsOneWidget);
  });
  testWidgets('ProceedableTile', (WidgetTester tester) async {
    String title =
        "AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA";
    bool isTapped = false;
    await tester.pumpWidget(MaterialApp(
        home: Scaffold(
            body: ProceedableTile(
                text: title,
                height: 400,
                onTap: (context) {
                  isTapped = true;
                }))));
    expect(find.text(title), findsOneWidget);
    expect(find.byType(Icon), findsOneWidget);
    await tester.tap(find.byType(Icon));
    await tester.pump();
    expect(isTapped, true);
  });

  group('SelectableTile Widget Tests', () {
    testWidgets('displays correctly when not selected',
        (WidgetTester tester) async {
      const String testText = 'Test Tile';
      bool isTapped = false;

      await tester.pumpWidget(MaterialApp(
        home: Scaffold(
          body: SelectableTile(
            isSelected: false,
            text: testText,
            onTap: () {
              isTapped = true;
            },
          ),
        ),
      ));

      expect(find.text(testText), findsOneWidget);
      expect(find.byIcon(Icons.check), findsNothing);
      expect(isTapped, isFalse);
    });

    testWidgets('displays correctly when selected',
        (WidgetTester tester) async {
      const String testText = 'Test Tile';

      await tester.pumpWidget(MaterialApp(
        home: Scaffold(
          body: SelectableTile(
            isSelected: true,
            text: testText,
            onTap: () {},
          ),
        ),
      ));

      expect(find.text(testText), findsOneWidget);
      expect(find.byIcon(Icons.check), findsOneWidget);
    });

    testWidgets('triggers onTap when tapped', (WidgetTester tester) async {
      const String testText = 'Test Tile';
      bool isTapped = false;

      await tester.pumpWidget(MaterialApp(
        home: Scaffold(
          body: SelectableTile(
            isSelected: false,
            text: testText,
            onTap: () {
              isTapped = true;
            },
            height: 200,
          ),
        ),
      ));

      await tester.tap(find.byType(SelectableTile));
      await tester.pumpAndSettle();
      expect(isTapped, isTrue);
    });
  });

  group('QueryField Widget Test', () {
    late RepositoryProvider mockProvider;
    String? query;
    setUp(() {
      mockProvider = RepositoryProvider();
    });
    Widget createTestableWidget() {
      return MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        locale: Locale('en'),
        home: ChangeNotifierProvider<RepositoryProvider>.value(
          value: mockProvider,
          child:
              Scaffold(body: QueryField(onSubmitted: (value) => query = value)),
        ),
      );
    }

    testWidgets('renders QueryField correctly', (WidgetTester tester) async {
      await tester.pumpWidget(createTestableWidget());
      expect(find.byType(TextField), findsOneWidget);
      expect(find.byIcon(Icons.search), findsOneWidget);
      expect(find.text('Search'), findsOneWidget);
    });

    testWidgets('onSubmitted updates query in provider',
        (WidgetTester tester) async {
      await tester.pumpWidget(createTestableWidget());
      const queryText = 'test query';
      await tester.enterText(find.byType(TextField), queryText);
      await tester.testTextInput.receiveAction(TextInputAction.done);
      await tester.pump();
      expect(query, queryText);
    });
  });
  group('SortButton Widget Test', () {
    late RepositoryProvider mockProvider;
    late SortTypes type;
    setUp(() {
      mockProvider = RepositoryProvider();
    });
    Widget createTestableWidget() {
      return MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        locale: Locale('en'),
        home: ChangeNotifierProvider<RepositoryProvider>.value(
          value: mockProvider,
          child: Scaffold(
              body: SizedBox(
            //サイズ大きくするといける
            width: 800,
            height: 800,
            child: SortButton(onSelected: (value) => type = value),
          )),
        ),
      );
    }

    testWidgets('renders SortButton correctly', (WidgetTester tester) async {
      await tester.pumpWidget(createTestableWidget());
      expect(find.byType(PopupMenuButton<SortTypes>), findsOneWidget);
      expect(find.byType(Icon), findsOneWidget);
      await tester.tap(find.byType(PopupMenuButton<SortTypes>));
      await tester.pumpAndSettle();
      expect(find.text("Forks"), findsOneWidget);
      expect(find.text("Issues"), findsOneWidget);
      expect(find.text("Last Updated"), findsOneWidget);
      expect(find.text("Stars"), findsOneWidget);
      expect(find.text("Best Match"), findsOneWidget);
    });

    testWidgets('onSelected updates sorType in provider',
        (WidgetTester tester) async {
      await tester.pumpWidget(createTestableWidget());
      await tester.tap(find.byType(PopupMenuButton<SortTypes>));
      await tester.pumpAndSettle();
      await tester.tap(find.text("Stars"));
      await tester.pumpAndSettle();
      expect(type, SortTypes.stars);
    });
  });
}

Future<http.Response> handler(http.Request request) async {
  if (request.url.queryParameters.containsValue('500')) {
    return http.Response('', 500);
  } else if (request.url.queryParameters.containsValue('422')) {
    return http.Response('', 422);
  }
  return http.Response('''{
          "total_count": 1,
          "items": [
            {
              "id": 1,
              "name": "q",
              "stargazers_count": 100,
              "watchers_count": 100,
              "forks_count": 10,
              "open_issues_count": 5,
              "owner": {
                "avatar_url": "https://avatars.githubusercontent.com/u/60294?v=4"
              },
              "size": 1428,
              "stargazers_count": 14927,
              "watchers_count": 14927,
              "language": "JavaScript",
              "forks_count": 1199,
              "open_issues_count": 116,
              "forks": 1199,
              "open_issues": 116,
              "watchers": 14927
            }
          ]
        }''', 200);
}
