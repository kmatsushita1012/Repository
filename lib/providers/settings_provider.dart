import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsProvider extends ChangeNotifier {
  late SharedPreferences _prefs;
  //現在の言語
  late Locale _locale;
  //全ての言語のLocale,AppLocalizationsのリスト　言語選択で使用
  final List<MapEntry<Locale, AppLocalizations>> _appLocalizationsEntryList =
      [];

  Locale get locale => _locale;
  List<MapEntry<Locale, AppLocalizations>> get appLocalizationsEntryList =>
      _appLocalizationsEntryList;

  //SharedPreferencesはモック導入のため入れ替え可能
  SettingsProvider(SharedPreferences prefs) {
    _prefs = prefs;
    String? localeCode = _prefs.getString("locale");
    //初期設定
    if (localeCode != null) {
      _locale = Locale(localeCode);
    } else {
      //未設定なら最初の言語に
      _locale = AppLocalizations.supportedLocales.first;
      _prefs.setString("locale", _locale.languageCode);
    }
    _setLocalizations();
    notifyListeners();
  }
  //言語リストをセットアップ
  Future<void> _setLocalizations() async {
    for (Locale locale in AppLocalizations.supportedLocales) {
      AppLocalizations appLocalizations =
          await AppLocalizations.delegate.load(locale);
      appLocalizationsEntryList.add(MapEntry(locale, appLocalizations));
    }
  }

  //言語切り替え時
  void setLocale(Locale locale) {
    _locale = locale;
    _prefs.setString("locale", locale.languageCode);
    notifyListeners();
  }
}
