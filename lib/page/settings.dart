import 'package:flutter/material.dart';
import 'package:repository/page/language.dart';
import 'package:repository/widgets/proceedabletile.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class SettingsPage extends StatelessWidget {
  void _onLanguageTap(BuildContext context) {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => LanguagePage()));
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: Text(
          AppLocalizations.of(context)!.settings,
        ),
      ),
      body: Container(
        margin: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
                child: ListView(
              children: [
                ProceedableTile(
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
