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
import 'package:repository/widgets/sortbutton.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

void main() {
  setUpAll(() {
    // GetItのセットアップ
    final client = MockClient(normalRequestHandler);
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
    final textFinder = find.text(title);
    expect(textFinder, findsOneWidget);
    expect(find.byType(Icon), findsOneWidget);
    await tester.tap(find.byType(Icon));
    await tester.pump();
    expect(isTapped, true);
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
          child: const Scaffold(
              body: SizedBox(
            //サイズ大きくするといける
            width: 800,
            height: 800,
            child: SortButton(),
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
      const sortType = SortTypes.stars;
      await tester.tap(find.text("Stars"));
      await tester.pumpAndSettle();
      expect(mockProvider.sortType, sortType);
    });
  });
}

Future<http.Response> normalRequestHandler(http.Request request) async {
  return http.Response('''{
  "total_count": 1,
  "incomplete_results": false,
  "items": [
    {
      "id": 887025,
      "node_id": "MDEwOlJlcG9zaXRvcnk4ODcwMjU=",
      "name": "q",
      "full_name": "kriskowal/q",
      "private": false,
      "owner": {
        "login": "kriskowal",
        "id": 60294,
        "node_id": "MDQ6VXNlcjYwMjk0",
        "avatar_url": "https://avatars.githubusercontent.com/u/60294?v=4",
        "gravatar_id": "",
        "url": "https://api.github.com/users/kriskowal",
        "html_url": "https://github.com/kriskowal",
        "followers_url": "https://api.github.com/users/kriskowal/followers",
        "following_url": "https://api.github.com/users/kriskowal/following{/other_user}",
        "gists_url": "https://api.github.com/users/kriskowal/gists{/gist_id}",
        "starred_url": "https://api.github.com/users/kriskowal/starred{/owner}{/repo}",
        "subscriptions_url": "https://api.github.com/users/kriskowal/subscriptions",
        "organizations_url": "https://api.github.com/users/kriskowal/orgs",
        "repos_url": "https://api.github.com/users/kriskowal/repos",
        "events_url": "https://api.github.com/users/kriskowal/events{/privacy}",
        "received_events_url": "https://api.github.com/users/kriskowal/received_events",
        "type": "User",
        "user_view_type": "public",
        "site_admin": false
      },
      "html_url": "https://github.com/kriskowal/q",
      "description": "A promise library for JavaScript",
      "fork": false,
      "url": "https://api.github.com/repos/kriskowal/q",
      "forks_url": "https://api.github.com/repos/kriskowal/q/forks",
      "keys_url": "https://api.github.com/repos/kriskowal/q/keys{/key_id}",
      "collaborators_url": "https://api.github.com/repos/kriskowal/q/collaborators{/collaborator}",
      "teams_url": "https://api.github.com/repos/kriskowal/q/teams",
      "hooks_url": "https://api.github.com/repos/kriskowal/q/hooks",
      "issue_events_url": "https://api.github.com/repos/kriskowal/q/issues/events{/number}",
      "events_url": "https://api.github.com/repos/kriskowal/q/events",
      "assignees_url": "https://api.github.com/repos/kriskowal/q/assignees{/user}",
      "branches_url": "https://api.github.com/repos/kriskowal/q/branches{/branch}",
      "tags_url": "https://api.github.com/repos/kriskowal/q/tags",
      "blobs_url": "https://api.github.com/repos/kriskowal/q/git/blobs{/sha}",
      "git_tags_url": "https://api.github.com/repos/kriskowal/q/git/tags{/sha}",
      "git_refs_url": "https://api.github.com/repos/kriskowal/q/git/refs{/sha}",
      "trees_url": "https://api.github.com/repos/kriskowal/q/git/trees{/sha}",
      "statuses_url": "https://api.github.com/repos/kriskowal/q/statuses/{sha}",
      "languages_url": "https://api.github.com/repos/kriskowal/q/languages",
      "stargazers_url": "https://api.github.com/repos/kriskowal/q/stargazers",
      "contributors_url": "https://api.github.com/repos/kriskowal/q/contributors",
      "subscribers_url": "https://api.github.com/repos/kriskowal/q/subscribers",
      "subscription_url": "https://api.github.com/repos/kriskowal/q/subscription",
      "commits_url": "https://api.github.com/repos/kriskowal/q/commits{/sha}",
      "git_commits_url": "https://api.github.com/repos/kriskowal/q/git/commits{/sha}",
      "comments_url": "https://api.github.com/repos/kriskowal/q/comments{/number}",
      "issue_comment_url": "https://api.github.com/repos/kriskowal/q/issues/comments{/number}",
      "contents_url": "https://api.github.com/repos/kriskowal/q/contents/{+path}",
      "compare_url": "https://api.github.com/repos/kriskowal/q/compare/{base}...{head}",
      "merges_url": "https://api.github.com/repos/kriskowal/q/merges",
      "archive_url": "https://api.github.com/repos/kriskowal/q/{archive_format}{/ref}",
      "downloads_url": "https://api.github.com/repos/kriskowal/q/downloads",
      "issues_url": "https://api.github.com/repos/kriskowal/q/issues{/number}",
      "pulls_url": "https://api.github.com/repos/kriskowal/q/pulls{/number}",
      "milestones_url": "https://api.github.com/repos/kriskowal/q/milestones{/number}",
      "notifications_url": "https://api.github.com/repos/kriskowal/q/notifications{?since,all,participating}",
      "labels_url": "https://api.github.com/repos/kriskowal/q/labels{/name}",
      "releases_url": "https://api.github.com/repos/kriskowal/q/releases{/id}",
      "deployments_url": "https://api.github.com/repos/kriskowal/q/deployments",
      "created_at": "2010-09-04T01:21:12Z",
      "updated_at": "2024-12-08T05:25:15Z",
      "pushed_at": "2023-11-08T10:50:34Z",
      "git_url": "git://github.com/kriskowal/q.git",
      "ssh_url": "git@github.com:kriskowal/q.git",
      "clone_url": "https://github.com/kriskowal/q.git",
      "svn_url": "https://github.com/kriskowal/q",
      "homepage": "",
      "size": 1428,
      "stargazers_count": 14927,
      "watchers_count": 14927,
      "language": "JavaScript",
      "has_issues": true,
      "has_projects": true,
      "has_downloads": true,
      "has_wiki": true,
      "has_pages": true,
      "has_discussions": false,
      "forks_count": 1199,
      "mirror_url": null,
      "archived": false,
      "disabled": false,
      "open_issues_count": 116,
      "license": {
        "key": "mit",
        "name": "MIT License",
        "spdx_id": "MIT",
        "url": "https://api.github.com/licenses/mit",
        "node_id": "MDc6TGljZW5zZTEz"
      },
      "allow_forking": true,
      "is_template": false,
      "web_commit_signoff_required": false,
      "topics": [],
      "visibility": "public",
      "forks": 1199,
      "open_issues": 116,
      "watchers": 14927,
      "default_branch": "master",
      "score": 1
    }
  ]
}
''', 200);
}
