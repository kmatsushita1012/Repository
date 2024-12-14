import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:repository/models/sorttypes.dart';
import 'package:repository/providers/repository_provider.dart';
import 'package:repository/widgets/detailcard.dart';
import 'package:repository/widgets/detailtile.dart';
import 'package:repository/widgets/proceedabletile.dart';
import 'package:repository/widgets/queryfield.dart';
import 'package:repository/widgets/sortbutton.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  // WidgetsBinding.instance.renderView.configuration = TestViewConfiguration(size: const Size(1080, 1920));

  testWidgets('DetailCard', (WidgetTester tester) async {
    String title = "Language";
    String value =
        "bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb";
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body:
              DetailCard(title: title, iconData: Icons.language, value: value),
        ),
      ),
    );
    expect(find.text(title), findsOneWidget);
    expect(find.text(value), findsOneWidget);
  });
  testWidgets('DetailTile', (WidgetTester tester) async {
    String title = "Issues";
    String value =
        "1000000000000000000000000000000000000000000000000000000000000000000";
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
            body: DetailTile(
                title: title, iconData: Icons.language, value: value)),
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
    final textFinder = find.text(title);
    expect(textFinder, findsOneWidget);
    expect(find.byType(Icon), findsOneWidget);
    await tester.tap(find.byType(Icon));
    await tester.pump();
    //なぜか失敗
    expect(isTapped, true);
  });

  testWidgets('SortButton', (WidgetTester tester) async {
    await tester.pumpWidget(
      ChangeNotifierProvider<RepositoryProvider>(
        create: (_) => RepositoryProvider(),
        child: MaterialApp(
          home: Scaffold(
            body: SizedBox(
              //サイズ大きくするといける
              width: 800,
              height: 800,
              child: SortButton(),
            ),
          ),
        ),
      ),
    );
    expect(find.byType(Icon), findsOneWidget);
    await tester.tap(find.byType(PopupMenuButton<SortTypes>));
    await tester.pumpAndSettle();
    expect(find.text("Forks"), findsOneWidget);
    expect(find.text("Issues"), findsOneWidget);
    expect(find.text("Last Updated"), findsOneWidget);
    expect(find.text("Stars"), findsOneWidget);
    await tester.tap(find.text("Last Updated"));
    await tester.pumpAndSettle();
    expect(find.byIcon(Icons.update), findsOneWidget);

    
  });

  testWidgets('QueryField', (WidgetTester tester) async {
    final text = 'sample';
    //   await tester.pumpWidget(
    //     ChangeNotifierProvider<RepositoryProvider>(
    //       create: (_) => RepositoryProvider(),
    //       child: MaterialApp(
    //         home: Scaffold(
    //           body: SizedBox(
    //             width: 400,
    //             height: 400,
    //             //サイズ大きくするといける
    //             child: QueryField(),
    //           ),
    //         ),
    //       ),
    //     ),
    //   );
    //   final textField = find.byType(TextField);
    //   expect(textField, findsOneWidget);
    //   await tester.enterText(textField, text);
    //   await tester.pumpAndSettle();
    //   expect(find.text(text), findsOneWidget);
  });
}
