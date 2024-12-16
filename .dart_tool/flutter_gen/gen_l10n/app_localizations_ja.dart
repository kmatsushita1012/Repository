import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Japanese (`ja`).
class AppLocalizationsJa extends AppLocalizations {
  AppLocalizationsJa([String locale = 'ja']) : super(locale);

  @override
  String get language_name => '日本語';

  @override
  String get title => 'RepositoryViewer';

  @override
  String get list => 'リスト';

  @override
  String get detail => '詳細';

  @override
  String get search => '検索';

  @override
  String get settings => '設定';

  @override
  String get language => '言語';

  @override
  String get language_setting => '言語設定';

  @override
  String get best_match => 'おすすめ';

  @override
  String get last_updated => '最新の更新';

  @override
  String get unset => '未設定 ';

  @override
  String get stars => 'Stars';

  @override
  String get wathcers => 'Watchers';

  @override
  String get forks => 'Forks';

  @override
  String get issues => 'Issues';

  @override
  String get error => 'エラー';

  @override
  String get http_error => '予期しないエラーが発生しました。もう一度お試しください。';

  @override
  String get invalid_query => '入力された検索条件が無効です。再度確認してください。';

  @override
  String get empty_list => 'キーワードを入力してレポジトリを探しましょう。';
}
