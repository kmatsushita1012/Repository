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
  String get language_setting => '言語設定';
}
