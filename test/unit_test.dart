import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:repository/models/repository.dart';
import 'package:repository/providers/repository_provider.dart';
import 'package:repository/providers/settings_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  group('Repository Tests', () {
    late RepositoryProvider repositoryProvider;
    late MockClient mockClient;
    final sampleText = 'sample';
    int code = 0;
    bool isLoading = false;
    Repository? item;

    setUp(() {
      GetIt.I.reset();
      mockClient = MockClient(handler);
      GetIt.I.registerLazySingleton<http.Client>(() => mockClient);

      repositoryProvider = RepositoryProvider();
      repositoryProvider.addListener(() {
        isLoading = repositoryProvider.isLoading;
        item = repositoryProvider.count != 0
            ? repositoryProvider.getRepository(0)
            : null;
      });
      code = 0;
    });

    test('Query before getting result', () async {
      repositoryProvider.setQuery(sampleText, (value) => code = value);
      expect(isLoading, true);
      expect(repositoryProvider.query, sampleText);
      expect(code, 0);
    });

    test('Query after getting success response', () async {
      await repositoryProvider.setQuery(sampleText, (value) => code = value);
      expect(isLoading, false);
      expect(code, 0);
      expect(item, isNotNull);
      expect(item!.name, 'q');
      expect(item!.stars, 14927);
      expect(item!.forks, 1199);
      expect(item!.issues, 116);
    });

    test('Query after getting 500 response', () async {
      await repositoryProvider.setQuery('500', (value) => code = value);
      expect(isLoading, false);
      expect(code, 500);
      expect(item, isNull);
    });

    test('Query after getting 422 response', () async {
      await repositoryProvider.setQuery('422', (value) => code = value);
      expect(isLoading, false);
      expect(code, 422);
      expect(item, isNull);
    });
  });

  group('SettingsProvider Tests', () {
    late SharedPreferences prefs;
    late SettingsProvider settingsProvider;

    setUp(() async {
      SharedPreferences.setMockInitialValues({'locale': 'en'});
      prefs = await SharedPreferences.getInstance();
      settingsProvider = SettingsProvider(prefs);
    });

    test('Set locale to Japanese', () async {
      settingsProvider.setLocale(Locale('ja'));
      expect(settingsProvider.locale.languageCode, 'ja');
      expect(prefs.getString('locale'), 'ja');
    });

    test('Verify locale list', () async {
      final entries = settingsProvider.appLocalizationsEntryList;
      expect(entries[0].key.languageCode, 'en');
      expect(entries[1].key.languageCode, 'ja');
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
