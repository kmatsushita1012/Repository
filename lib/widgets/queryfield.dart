import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:repository/providers/repository_provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

//クエリのテキストフィールド
class QueryField extends StatelessWidget {
  //こちらで処理しても良かったがアニメーション等を考えてコールバックにした
  final void Function(String) onSubmitted;

  const QueryField({super.key, required this.onSubmitted});

  @override
  Widget build(BuildContext context) {
    ColorScheme colorScheme = Theme.of(context).colorScheme;
    return Consumer<RepositoryProvider>(
      builder: (context, provider, _) => TextField(
        autofillHints: [AppLocalizations.of(context)!.search],
        controller: TextEditingController(text: provider.query),
        decoration: InputDecoration(
            fillColor: colorScheme.secondaryContainer,
            filled: true,
            hintText: AppLocalizations.of(context)!.search,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(30.0),
            ),
            prefixIcon: const Icon(Icons.search)),
        onSubmitted: onSubmitted,
      ),
    );
  }
}
