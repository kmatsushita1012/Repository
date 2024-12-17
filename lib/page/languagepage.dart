import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import 'package:repository/providers/settings_provider.dart';
import 'package:repository/widgets/selectabletile.dart';

class LanguagePage extends StatelessWidget {
  const LanguagePage({super.key});

  @override
  Widget build(BuildContext context) {
    ColorScheme colorScheme = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          AppLocalizations.of(context)!.language_setting,
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        foregroundColor: colorScheme.onPrimary,
        backgroundColor: colorScheme.primary,
      ),
      body: Consumer<SettingsProvider>(
          builder: (context, provider, _) => Container(
                margin: const EdgeInsets.all(8.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                        child: ListView.builder(
                            itemCount:
                                provider.appLocalizationsEntryList.length,
                            itemBuilder: (context, index) {
                              //各言語のLocaleとAppLocalizationsを取得
                              MapEntry<Locale, AppLocalizations> language =
                                  provider.appLocalizationsEntryList[index];
                              Locale locale = language.key;
                              AppLocalizations appLocalizations =
                                  language.value;
                              return SelectableTile(
                                isSelected: locale.toLanguageTag() ==
                                    provider.locale.toLanguageTag(),
                                text: appLocalizations.language_name,
                                onTap: () => provider.setLocale(locale),
                              );
                            }))
                  ],
                ),
              )),
    );
  }
}
