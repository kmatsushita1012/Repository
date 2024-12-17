import 'package:flutter/material.dart';
import 'package:repository/page/languagepage.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:repository/widgets/proceedabletile.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  //言語設定タップ時
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
      body: Padding(
          padding: const EdgeInsets.all(8),
          child: ListView(
            children: [
              ProceedableTile(
                  text: AppLocalizations.of(context)!.language_name,
                  onTap: _onLanguageTap)
            ],
          )),
    );
  }
}
