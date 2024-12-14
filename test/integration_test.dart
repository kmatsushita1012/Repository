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

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();
  setUpAll(() {
    // GetItのセットアップ
    final client = MockClient(normalRequestHandler);
    GetIt.I.registerLazySingleton<http.Client>(() => client);
  });
  testWidgets('Integration Test', (WidgetTester tester) async {
    SharedPreferences.setMockInitialValues({'locale': 'en'});
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await tester.pumpWidget(MyApp(prefs: prefs));

    expect(find.text("List"), findsOneWidget);
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
