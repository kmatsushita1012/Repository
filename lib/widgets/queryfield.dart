import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:repository/providers/repository_provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
class QueryField extends StatelessWidget {
  void _textChanged(RepositoryProvider model, String value) {
    model.setText(value);
  }

  @override
  Widget build(BuildContext context) {
    ColorScheme colorScheme = Theme.of(context).colorScheme;
    return Consumer<RepositoryProvider>(
      builder: (context, model, _) => TextField(
        autofillHints: [AppLocalizations.of(context)!.search],
        decoration: InputDecoration(
            fillColor: colorScheme.secondaryContainer,
            filled: true,
            hintText: AppLocalizations.of(context)!.search,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(30.0),
            ),
            prefixIcon: const Icon(Icons.search)),
        onSubmitted: (value) => _textChanged(model, value),
      ),
    );
  }
}