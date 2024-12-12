import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:repository/models/sorttypes.dart';
import 'package:repository/page/detail.dart';
import 'package:repository/page/settings.dart';
import 'package:repository/providers/repository_provider.dart';
import 'package:repository/widgets/proceedabletile.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ListPage extends StatelessWidget {
  const ListPage({super.key});

  void _textChanged(RepositoryProvider model, String value) {
    model.setText(value);
  }

  void _onTap(BuildContext context, int index) {
    Navigator.push(context,
        MaterialPageRoute(builder: (context) => DetailPage(index: index)));
  }

  void _trailingPressed(BuildContext context) {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => SettingsPage()));
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    ColorScheme colorScheme = Theme.of(context).colorScheme;
    return Scaffold(
        appBar: AppBar(
          title: Text(
            AppLocalizations.of(context)!.list,
          ),
          actions: [
            IconButton(
                onPressed: () => _trailingPressed(context),
                icon: const Icon(Icons.settings))
          ],
        ),
        body: Consumer<RepositoryProvider>(
            builder: (context, model, _) => Stack(
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
                              Expanded(
                                child: TextField(
                                  autofillHints: [
                                    AppLocalizations.of(context)!.search
                                  ],
                                  decoration: InputDecoration(
                                      hintText:
                                          AppLocalizations.of(context)!.search,
                                      border: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(30.0),
                                      ),
                                      prefixIcon: const Icon(Icons.search)),
                                  onSubmitted: (value) =>
                                      _textChanged(model, value),
                                ),
                              ),
                              const SizedBox(
                                width: 16,
                              ),
                              PopupMenuButton<SortTypes>(
                                  onSelected: (value) {
                                    model.setSortType(value);
                                  },
                                  itemBuilder: (BuildContext context) {
                                    return SortTypes.values.map((item) {
                                      return PopupMenuItem<SortTypes>(
                                          value: item,
                                          child: Row(
                                            children: [
                                              Icon(item.icon()),
                                              const SizedBox(
                                                width: 8,
                                              ),
                                              Text(
                                                item.toString(),
                                                style: const TextStyle(
                                                    fontSize: 16),
                                              )
                                            ],
                                          ));
                                    }).toList();
                                  },
                                  child: Icon(
                                    model.sortType.icon(),
                                    size: 32,
                                  )),
                            ],
                          ),
                          const SizedBox(
                            height: 16,
                          ),
                          Expanded(
                            child: ListView.builder(
                                itemCount: model.items.length,
                                itemBuilder: (context, index) =>
                                    ProceedableTile(
                                        text: model.items[index].name,
                                        onTap: (context) =>
                                            _onTap(context, index))),
                          )
                        ],
                      ),
                    ),
                    if (model.isLoading)
                      const Positioned.fill(
                        child: Center(
                          child: CircularProgressIndicator(),
                        ),
                      ),
                  ],
                )));
  }
}
