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
  String get language => 'Language';

  @override
  String get language_setting => 'Set Language';

  @override
  String get best_match => 'Best Match';

  @override
  String get last_updated => 'Last Updated';

  @override
  String get unset => 'Unset ';

  @override
  String get stars => 'Stars';

  @override
  String get wathcers => 'Watchers';

  @override
  String get forks => 'Forks';

  @override
  String get issues => 'Issues';

  @override
  String get error => 'Error';

  @override
  String get http_error => 'An unexpected error has occurred. Please try again.';

  @override
  String get invalid_query => 'The search query you entered is invalid. Please check it again.';

  @override
  String get empty_list => 'Enter a keyword to search for repositories.';

  @override
  String get notice => 'Notice';

  @override
  String get no_results => 'No results found.';
}
