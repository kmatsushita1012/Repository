import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get language_name => 'English';

  @override
  String get title => 'RepositoryViewer';

  @override
  String get list => 'List';

  @override
  String get detail => 'Detail';

  @override
  String get search => 'Search';

  @override
  String get settings => 'Settings';

  @override
  String get language_setting => 'Set Language';
}
