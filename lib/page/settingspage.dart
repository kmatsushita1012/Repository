import 'package:flutter/material.dart';
import 'package:repository/page/languagepage.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:repository/widgets/settingsitemtile.dart';

class SettingsPage extends StatelessWidget {
  void _onLanguageTap(BuildContext context) {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => LanguagePage()));
  }

  @override
  Widget build(BuildContext context) {
    ColorScheme colorScheme = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          AppLocalizations.of(context)!.settings,
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        foregroundColor: colorScheme.onPrimary,
        backgroundColor: colorScheme.primary,
      ),
      body: Container(
        margin: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
                child: ListView(
              children: [
                SettingsItemtile(
                    text: AppLocalizations.of(context)!.language_name,
                    onTap: _onLanguageTap)
              ],
            ))
          ],
        ),
      ),
    );
  }
}
