import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:repository/models/repository.dart';
import 'package:repository/providers/repository_provider.dart';
import 'package:repository/providers/settings_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'helpers/mockapi.dart';

void main() {
  group('Repository Tests', () {
    late RepositoryProvider repositoryProvider;
    late MockClient mockClient;
    final sampleText = 'sample';
    late int code;
    Repository? item;

    setUp(() {
      GetIt.I.reset();
      //handlerに挙動を定義してモックに与える
      mockClient = MockClient(mockAPI);
      //クライアントを登録
      GetIt.I.registerLazySingleton<http.Client>(() => mockClient);

      repositoryProvider = RepositoryProvider();
      repositoryProvider.addListener(() {
        item = repositoryProvider.count != 0
            ? repositoryProvider.getRepository(0)
            : null;
      });
      code = 0;
    });
    //通常時リクエスト直後
    test('Query before getting result', () async {
      repositoryProvider.setQuery(sampleText,
          onSuccess: (value) => code = value, onError: (value) => code = value);
      expect(repositoryProvider.isLoading, true);
      expect(repositoryProvider.query, sampleText);
      expect(code, 0);
    });
    //通常時レスポンス取得後
    test('Query after getting success response', () async {
      await repositoryProvider.setQuery(sampleText,
          onSuccess: (value) => code = value, onError: (value) => code = value);
      expect(repositoryProvider.isLoading, false);
      expect(code, 200);
      expect(item, isNotNull);
      expect(item!.name, 'q');
      expect(item!.stars, 14927);
      expect(item!.forks, 1199);
      expect(item!.issues, 116);
    });
    //一般的なエラー
    test('Query after getting 500 response', () async {
      await repositoryProvider.setQuery('500',
          onSuccess: (value) => code = value, onError: (value) => code = value);
      expect(repositoryProvider.isLoading, false);
      expect(code, 500);
      expect(item, isNull);
    });
    //不適切なクエリのエラー
    test('Query after getting 422 response', () async {
      await repositoryProvider.setQuery('422',
          onSuccess: (value) => code = value, onError: (value) => code = value);
      expect(repositoryProvider.isLoading, false);
      expect(code, 422);
      expect(item, isNull);
    });
    //結果なしの場合
    test('Query after getting 204 response', () async {
      await repositoryProvider.setQuery('204',
          onSuccess: (value) => code = value, onError: (value) => code = value);
      expect(repositoryProvider.isLoading, false);
      expect(code, 200);
      expect(item, isNull);
    });
  });
  //設定用Providerのテスト
  group('SettingsProvider Tests', () {
    late SharedPreferences prefs;
    late SettingsProvider settingsProvider;

    setUp(() async {
      //初期値は英語に設定
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
