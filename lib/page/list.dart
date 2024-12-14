import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:repository/page/detail.dart';
import 'package:repository/page/settings.dart';
import 'package:repository/providers/repository_provider.dart';
import 'package:repository/widgets/proceedabletile.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:repository/widgets/queryfield.dart';
import 'package:repository/widgets/sortbutton.dart';

class ListPage extends StatelessWidget {
  const ListPage({super.key});

  @override
  Widget build(BuildContext context) {
    ColorScheme colorScheme = Theme.of(context).colorScheme;
    return Scaffold(
        appBar: AppBar(
          title: Text(
            AppLocalizations.of(context)!.list,
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          foregroundColor: colorScheme.onPrimary,
          backgroundColor: colorScheme.primary,
          actions: [
            IconButton(
                onPressed: () => Navigator.push(context,
                    MaterialPageRoute(builder: (context) => SettingsPage())),
                icon: const Icon(Icons.settings))
          ],
        ),
        body: Consumer<RepositoryProvider>(
            builder: (context, provider, _) => Stack(
                  alignment: Alignment.center,
                  children: [
                    Container(
                      margin: const EdgeInsets.all(16.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              Expanded(child: QueryField()),
                              const SizedBox(
                                width: 16,
                              ),
                              SizedBox(
                                  width: 48, height: 48, child: SortButton()),
                            ],
                          ),
                          const SizedBox(
                            height: 16,
                          ),
                          Expanded(
                            child: ListView.builder(
                              itemCount: provider.count,
                              itemBuilder: (context, index) => ProceedableTile(
                                  text: provider.getRepository(index).name,
                                  onTap: (context) => Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => DetailPage(
                                                index: index,
                                              )))),
                            ),
                          )
                        ],
                      ),
                    ),
                    if (provider.isLoading)
                      const Positioned.fill(
                        child: Center(
                          child: CircularProgressIndicator(),
                        ),
                      ),
                  ],
                )));
  }
}
